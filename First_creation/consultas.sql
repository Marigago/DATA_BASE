-- Emisión de ticket
SELECT 
    t.idTicket,
    t.fecha,
    t.hora,
    tr.nombre AS trabajador,
    c.nombre AS cliente,
    p.nombre AS producto,
    dt.cantidad,
    dt.precioUnitario,
    dt.subtotal,
    t.descuento,
    t.iva,
    t.total
FROM 
    Ticket t
    INNER JOIN Ventas v ON t.idVenta = v.idVenta
    INNER JOIN Trabajadores tr ON v.idTrabajador = tr.idTrabajador
    INNER JOIN Clientes c ON v.idCliente = c.idCliente
    INNER JOIN DetalleTicket dt ON t.idTicket = dt.idTicket
    INNER JOIN Productos p ON dt.idProducto = p.idProducto
WHERE 
    t.idTicket = @idTicket;

-- Reporte del producto con su cantidad y su monto en dinero en un rango de fechas determinado, incluir productos que no se vendieron en ese periodo
SELECT 
    p.idProducto,
    p.nombre,
    ISNULL(SUM(dt.cantidad), 0) AS cantidad,
    ISNULL(SUM(dt.subtotal), 0) AS monto
FROM 
    Productos p
    LEFT JOIN DetalleTicket dt ON p.idProducto = dt.idProducto
    LEFT JOIN Ticket t ON dt.idTicket = t.idTicket
WHERE 
    t.fecha BETWEEN @fechaInicio AND @fechaFin OR t.fecha IS NULL
GROUP BY 
    p.idProducto, p.nombre;

-- Reporte de los 10 mejores productos vendidos por rango de fechas
SELECT TOP 10
    p.idProducto,
    p.nombre,
    SUM(dt.cantidad) AS cantidad,
    SUM(dt.subtotal) AS monto
FROM 
    Productos p
    INNER JOIN DetalleTicket dt ON p.idProducto = dt.idProducto
    INNER JOIN Ticket t ON dt.idTicket = t.idTicket
WHERE 
    t.fecha BETWEEN @fechaInicio AND @fechaFin
GROUP BY 
    p.idProducto, p.nombre
ORDER BY 
    cantidad DESC;

-- Reporte de ingresos de ventas por cliente
SELECT 
    c.idCliente,
    c.nombre,
    SUM(v.total) AS ingresos
FROM 
    Clientes c
    INNER JOIN Ventas v ON c.idCliente = v.idCliente
GROUP BY 
    c.idCliente, c.nombre;

-- Reporte de ventas por mes, filtrados por año
SELECT 
    MONTH(v.fechaVenta) AS mes,
    SUM(v.total) AS ventas
FROM 
    Ventas v
WHERE 
    YEAR(v.fechaVenta) = @anio
GROUP BY 
    MONTH(v.fechaVenta)
ORDER BY 
    mes;

-- Corte de caja, por vendedor, en una fecha determinada, cuánto ingresó
SELECT 
    t.idTrabajador,
    t.nombre,
    SUM(v.total) AS ingresos
FROM 
    Trabajadores t
    INNER JOIN Ventas v ON t.idTrabajador = v.idTrabajador
WHERE 
    t.idTrabajador = @idTrabajador AND v.fechaVenta = @fecha
GROUP BY 
    t.idTrabajador, t.nombre;

-- Corte de caja detallado, incluir listado de tickets y totales del reporte anterior
SELECT 
    t.idTrabajador,
    t.nombre,
    tk.idTicket,
    tk.total
FROM 
    Trabajadores t
    INNER JOIN Ventas v ON t.idTrabajador = v.idTrabajador
    INNER JOIN Ticket tk ON v.idVenta = tk.idVenta
WHERE 
    t.idTrabajador = @idTrabajador AND v.fechaVenta = @fecha;

SELECT 
    SUM(tk.total) AS totalIngresos
FROM 
    Trabajadores t
    INNER JOIN Ventas v ON t.idTrabajador = v.idTrabajador
    INNER JOIN Ticket tk ON v.idVenta = tk.idVenta
WHERE 
    t.idTrabajador = @idTrabajador AND v.fechaVenta = @fecha;

-- Reporte de existencias por producto al día de hoy
SELECT 
    idProducto,
    nombre,
    stock
FROM 
    Productos;

-- Estado de cuenta de dinero, ingresos y egresos, por rango de fechas
SELECT 
    m.fecha,
    m.tipo,
    m.monto,
    m.descripcion
FROM 
    Movimientos m
WHERE 
    m.fecha BETWEEN @fechaInicio AND @fechaFin
ORDER BY 
    m.fecha;

-- Reporte de la paleta que más compra un cliente en un mes específico
SELECT TOP 1
    p.idProducto,
    p.nombre,
    SUM(dt.cantidad) AS cantidad
FROM 
    Productos p
    INNER JOIN DetalleTicket dt ON p.idProducto = dt.idProducto
    INNER JOIN Ticket t ON dt.idTicket = t.idTicket
    INNER JOIN Ventas v ON t.idVenta = v.idVenta
WHERE 
    v.idCliente = @idCliente AND YEAR(v.fechaVenta) = @anio AND MONTH(v.fechaVenta) = @mes
GROUP BY 
    p.idProducto, p.nombre
ORDER BY 
    cantidad DESC;