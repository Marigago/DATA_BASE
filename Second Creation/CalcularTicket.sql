--Calcular ticket
CREATE PROCEDURE calculaticket
    @idticket INT
AS
BEGIN
    -- Declarar variables locales
    DECLARE @iva DECIMAL(18, 2),
            @descuento DECIMAL(18, 2),
            @total DECIMAL(18, 2),
            @subtotal DECIMAL(18, 2);

    -- Calcular total del detalle
    UPDATE TicketProducto
    SET total = cantidad * (SELECT precioUnitario FROM Producto WHERE idProducto = TicketProducto.idProducto)
    WHERE idTicket = @idticket;

    -- Obtener el IVA desglosado
    SELECT @iva = SUM(tp.total * p.porcentajeIVA / 100)
    FROM TicketProducto tp
    INNER JOIN Producto p ON p.idProducto = tp.idProducto
    WHERE tp.idTicket = @idticket;

    -- Calcular el descuento global
    SELECT @descuento = SUM(tp.total * p.descuento / 100)
    FROM TicketProducto tp
    INNER JOIN Producto p ON p.idProducto = tp.idProducto
    WHERE tp.idTicket = @idticket;

    -- Calcular el subtotal del ticket
    SELECT @subtotal = SUM(tp.total)
    FROM TicketProducto tp
    INNER JOIN Producto p ON p.idProducto = tp.idProducto
    WHERE tp.idTicket = @idticket;

    -- Quitar el descuento global
    SET @total = @subtotal - @descuento;

    -- Actualizar el registro del ticket
    UPDATE Ticket
    SET total = @total,
        subtotal = @subtotal,
        iva = @iva,
        descuentoAplicado = @descuento,
        folio = 'T000' + CONVERT(CHAR(10), @idticket)
    WHERE idTicket = @idticket;
END;