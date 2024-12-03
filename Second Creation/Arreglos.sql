USE Frias
GO
--CORECCIONES DE LA BASE DE DATOS

--Agregar titular y numero de cuenta a la tabla Cuenta
ALTER TABLE Cuenta
ADD numeroCuenta VARCHAR(20),
    titular VARCHAR(100);

--Se modifica el proceso de compra
ALTER PROCEDURE RegistrarCompra
    @idProveedor INT,
    @fecha DATE,
    @totalPagado DECIMAL(10, 2),
    @idEmpleado INT,
    @idCuenta INT
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
    WHERE idCuenta = @idCuenta;

    -- Actualizar el stock de los productos comprados
    UPDATE Producto
    SET stock = stock + dc.cantidad
    FROM DetalleCompra dc
    WHERE dc.idCompra = @idCompra AND Producto.idProducto = dc.idProducto;
END;

--Modificar el proceso de venta
CREATE PROCEDURE RegistrarVenta
    @fecha DATE,
    @idCliente INT,
    @idEmpleado INT,
    @idCuenta INT
AS
BEGIN
    -- Insertar el ticket
    INSERT INTO Ticket (fecha, idCliente, idEmpleado)
    VALUES (@fecha, @idCliente, @idEmpleado);

    -- Obtener el ID del ticket recién insertado
    DECLARE @idTicket INT;
    SET @idTicket = SCOPE_IDENTITY();

    -- Calcular el ticket (llamada al procedimiento almacenado calculaticket)
    EXEC calculaticket @idTicket;

    -- Actualizar el saldo de la cuenta (sumar el total del ticket)
    UPDATE Cuenta
    SET saldo = saldo + (SELECT total FROM Ticket WHERE idTicket = @idTicket)
    WHERE idCuenta = @idCuenta;

    -- Actualizar el stock de los productos vendidos
    UPDATE Producto
    SET stock = stock - tp.cantidad
    FROM TicketProducto tp
    WHERE tp.idTicket = @idTicket AND Producto.idProducto = tp.idProducto;
END;

--Creamo el pago de los empleados
CREATE PROCEDURE RegistrarPagoEmpleado
    @idEmpleado INT,
    @fecha DATE,
    @monto DECIMAL(10, 2),
    @idCuenta INT
AS
BEGIN
    -- Insertar el pago del empleado
    INSERT INTO PagoEmpleado (idEmpleado, fecha, monto)
    VALUES (@idEmpleado, @fecha, @monto);

    -- Actualizar el saldo de la cuenta (restar el monto del pago)
    UPDATE Cuenta
    SET saldo = saldo - @monto
    WHERE idCuenta = @idCuenta;
END;