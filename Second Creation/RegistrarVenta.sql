--Registrar venta

CREATE PROCEDURE RegistrarVenta
    @fecha DATE,
    @idCliente INT,
    @idEmpleado INT
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
    WHERE idCuenta = 1;

    -- Actualizar el stock de los productos vendidos
    UPDATE Producto
    SET stock = stock - tp.cantidad
    FROM TicketProducto tp
    WHERE tp.idTicket = @idTicket AND Producto.idProducto = tp.idProducto;
END;