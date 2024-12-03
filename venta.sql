USE [FriasPaleteria]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[RegistrarVenta]
    @idCliente INT,
    @idTrabajador INT,
    @fechaVenta DATE,
    @total DECIMAL(10,2),
    @detalleVenta TVP_DetalleVenta READONLY,
    @esCancelacion BIT = 0
AS
BEGIN
    -- Obtener el tipo de cliente y su descuento
    DECLARE @descuento DECIMAL(5,2);
    SELECT @descuento = tc.descuento
    FROM Clientes c
    INNER JOIN TipoCliente tc ON c.idTipoCliente = tc.idTipoCliente
    WHERE c.idCliente = @idCliente;

    -- Calcular el total con descuento
    DECLARE @totalConDescuento DECIMAL(10,2);
    SET @totalConDescuento = @total - (@total * @descuento);

    -- Obtener el último ID de venta
    DECLARE @idVenta INT;
    SELECT @idVenta = ISNULL(MAX(idVenta), 0) + 1 FROM Ventas;

    -- Insertar la venta en la tabla Ventas
    INSERT INTO Ventas (idVenta, idCliente, idTrabajador, fechaVenta, total)
    VALUES (@idVenta, @idCliente, @idTrabajador, @fechaVenta, CASE WHEN @esCancelacion = 1 THEN -@totalConDescuento ELSE @totalConDescuento END);

    -- Obtener el último ID de movimiento
    DECLARE @idMovimiento INT;
    SELECT @idMovimiento = ISNULL(MAX(idMovimiento), 0) + 1 FROM Movimientos;

    -- Insertar el movimiento en la tabla Movimientos
    INSERT INTO Movimientos (idMovimiento, idCuenta, fecha, tipo, monto, descripcion)
    VALUES (@idMovimiento, 1, @fechaVenta, CASE WHEN @esCancelacion = 1 THEN 'Egreso' ELSE 'Ingreso' END, CASE WHEN @esCancelacion = 1 THEN @totalConDescuento ELSE -@totalConDescuento END, 'Venta: #' + CAST(@idVenta AS VARCHAR(10)));

    -- Actualizar el saldo de la cuenta
    UPDATE Cuenta SET saldo = saldo + CASE WHEN @esCancelacion = 1 THEN -@totalConDescuento ELSE @totalConDescuento END WHERE idCuenta = 1;

    -- Obtener el último ID de ticket
    DECLARE @idTicket INT;
    SELECT @idTicket = ISNULL(MAX(idTicket), 0) + 1 FROM Ticket;

    -- Generar el ticket de venta
    INSERT INTO Ticket (idTicket, idVenta, fecha, hora, total, descuento, iva)
    VALUES (@idTicket, @idVenta, @fechaVenta, GETDATE(), CASE WHEN @esCancelacion = 1 THEN -@totalConDescuento ELSE @totalConDescuento END, @descuento, 0.16);

    -- Insertar los detalles del ticket
    INSERT INTO DetalleTicket (idTicket, cantidad, precioUnitario, subtotal)
    SELECT @idTicket, dv.cantidad, p.precio, (dv.cantidad * p.precio)
    FROM @detalleVenta dv
    INNER JOIN Productos p ON dv.idProducto = p.idProducto;

    -- Actualizar el stock de los productos vendidos (solo si no es cancelación)
    IF @esCancelacion = 0
    BEGIN
        UPDATE p
        SET p.stock = p.stock - dv.cantidad
        FROM Productos p
        INNER JOIN @detalleVenta dv ON p.idProducto = dv.idProducto;
    END
END