USE Frias
GO

--Registrar compra
CREATE PROCEDURE RegistrarCompra
    @idProveedor INT,
    @fecha DATE,
    @totalPagado DECIMAL(10, 2),
    @idEmpleado INT
AS
BEGIN
    -- Insertar la compra
    INSERT INTO Compra (idProveedor, fecha, totalPagado, idEmpleado)
    VALUES (@idProveedor, @fecha, @totalPagado, @idEmpleado);

    -- Obtener el ID de la compra recién insertada
    DECLARE @idCompra INT;
    SET @idCompra = SCOPE_IDENTITY();

    -- Actualizar el saldo de la cuenta (restar el totalPagado)
    UPDATE Cuenta
    SET saldo = saldo - @totalPagado
    WHERE idCuenta = 1;

    -- Actualizar el stock de los productos comprados
    UPDATE Producto
    SET stock = stock + dc.cantidad
    FROM DetalleCompra dc
    WHERE dc.idCompra = @idCompra AND Producto.idProducto = dc.idProducto;
END;