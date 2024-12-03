--Mostrar el ticket

CREATE PROCEDURE muestraticket
    @idticket INT
AS
BEGIN
    -- Selección de productos asociados con el ticket
    SELECT
        tp.cantidad,
        p.descripcion AS articulo,
        p.precioUnitario,
        tp.total,
        CASE
            WHEN p.descuento = 0 THEN ''
            ELSE '!*'
        END AS ahorro
    FROM
        Producto p
        INNER JOIN TicketProducto tp ON tp.idProducto = p.idProducto
    WHERE
        tp.idTicket = @idticket;

    -- Información del ticket
    SELECT
        folio,
        fecha,
        iva AS impuesto,
        subtotal,
        descuentoAplicado,
        total
    FROM
        Ticket
    WHERE
        idTicket = @idticket;

    -- Mensaje de ahorro
    SELECT
        'Hoy te ahorraste el ' + CONVERT(CHAR(5), descuentoAplicado * 100 / subtotal) + '% de tu compra que son $' + CONVERT(CHAR(5), descuentoAplicado) + ' menos'
    FROM
        Ticket
    WHERE
        idTicket = @idticket;

    -- Información del empleado
    SELECT
        'Le atendió ' + nombre + ' ' + apellido
    FROM
        Empleado
    WHERE
        idEmpleado = (SELECT idEmpleado FROM Ticket WHERE idTicket = @idticket);
END;