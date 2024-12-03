INSERT INTO TipoCliente (idTipoCliente, nombre, descuento)
VALUES
    (1, 'Público en general', 0.00),
    (2, 'Fijo', 0.10);

INSERT INTO Clientes (idCliente, nombre, telefono, idTipoCliente)
VALUES
    (1, 'Público en general', NULL, 1),
    (2, 'María Fernández', '555-1234', 2),
    (3, 'Juan Pérez', '555-5678', 1),
    (4, 'Ana Ramírez', '555-9012', 2),
    (5, 'Pedro Gómez', '555-3456', 1),
    (6, 'Laura Torres', '555-7890', 2),
    (7, 'Carlos Ruiz', '555-2345', 1),
    (8, 'Marta Sánchez', '555-6789', 2),
    (9, 'Luis Castro', '555-0123', 1),
    (10, 'Sofía Vargas', '555-4567', 2),
    (11, 'Diego Mendoza', '555-8901', 1),
    (12, 'Isabella Ortega', '555-2345', 2),
    (13, 'Javier Morales', '555-6789', 1),
    (14, 'Valentina Rojas', '555-0123', 2),
    (15, 'Andrés Herrera', '555-4567', 1),
    (16, 'Camila Gutiérrez', '555-8901', 2),
    (17, 'Sebastián Navarro', '555-2345', 1),
    (18, 'Daniela Jiménez', '555-6789', 2),
    (19, 'Mateo Paredes', '555-0123', 1),
    (20, 'Valeria Vega', '555-4567', 2);

INSERT INTO Cuenta (idCuenta, titular, numeroCuenta, saldo)
VALUES (1, 'Paletería La Michoacana', '1234567890', 50000.00);

INSERT INTO Categoria (idCategoria, nombre)
VALUES
    (1, 'Paletas de agua'),
    (2, 'Paletas de leche'),
    (3, 'Especiales');

INSERT INTO Productos (idProducto, nombre, idCategoria, precio, stock)
VALUES
    (1, 'Paleta de limón', 1, 10.00, 100),
    (2, 'Paleta de fresa', 1, 10.00, 100),
    (3, 'Paleta de mango', 1, 10.00, 100),
    (4, 'Paleta de tamarindo', 1, 10.00, 100),
    (5, 'Paleta de jamaica', 1, 10.00, 100),
    (6, 'Paleta de coco', 2, 15.00, 80),
    (7, 'Paleta de chocolate', 2, 15.00, 80),
    (8, 'Paleta de vainilla', 2, 15.00, 80),
    (9, 'Paleta de cajeta', 2, 15.00, 80),
    (10, 'Paleta de queso', 2, 15.00, 80),
    (11, 'Paleta de piña colada', 3, 20.00, 50),
    (12, 'Paleta de mojito', 3, 20.00, 50),
    (13, 'Paleta de margarita', 3, 20.00, 50),
    (14, 'Paleta de chicle', 3, 20.00, 50),
    (15, 'Paleta de grosella', 3, 20.00, 50),
    (16, 'Paleta de sandía', 1, 10.00, 100),
    (17, 'Paleta de guayaba', 1, 10.00, 100),
    (18, 'Paleta de maracuyá', 1, 10.00, 100),
    (19, 'Paleta de coco con chocolate', 2, 15.00, 80),
    (20, 'Paleta de fresa con crema', 2, 15.00, 80),
    (21, 'Paleta de mango con chile', 3, 20.00, 50),
    (22, 'Paleta de tamarindo con chamoy', 3, 20.00, 50),
    (23, 'Paleta de pay de limón', 3, 20.00, 50),
    (24, 'Paleta de chocolate con almendras', 3, 20.00, 50),
    (25, 'Paleta de yogurt con frutas', 3, 20.00, 50);

INSERT INTO Trabajadores (idTrabajador, nombre, telefono, salario)
VALUES
    (1, 'Alejandro Sánchez', '555-1111', 8000.00),
    (2, 'Gabriela Ramírez', '555-2222', 8000.00),
    (3, 'Diego Fernández', '555-3333', 8000.00);

INSERT INTO Proveedor (idProveedor, nombre, telefono)
VALUES (1, 'Distribuidora de Paletas S.A.', '555-9999');

USE [FriasPaleteria]
GO

-- Pedido 1
DECLARE @detallePedido1 TVP_DetallePedido;

INSERT INTO @detallePedido1 (idProducto, cantidad)
VALUES
    (1, 50),
    (3, 30),
    (5, 20);

EXEC dbo.RegistrarCompra
    @idProveedor = 1,
    @fechaPedido = '2024-01-15',
    @fechaPago = '2024-01-20',
    @total = 1500.00,
    @idTrabajador = 1,
    @detallePedido = @detallePedido1;

-- Pedido 2
DECLARE @detallePedido2 TVP_DetallePedido;

INSERT INTO @detallePedido2 (idProducto, cantidad)
VALUES
    (2, 40),
    (4, 25),
    (6, 15);

EXEC dbo.RegistrarCompra
    @idProveedor = 2,
    @fechaPedido = '2024-02-10',
    @fechaPago = '2024-02-15',
    @total = 1800.00,
    @idTrabajador = 2,
    @detallePedido = @detallePedido2;

-- Pedido 3
DECLARE @detallePedido3 TVP_DetallePedido;

INSERT INTO @detallePedido3 (idProducto, cantidad)
VALUES
    (7, 60),
    (9, 35),
    (11, 25);

EXEC dbo.RegistrarCompra
    @idProveedor = 3,
    @fechaPedido = '2024-03-05',
    @fechaPago = '2024-03-10',
    @total = 2200.00,
    @idTrabajador = 3,
    @detallePedido = @detallePedido3;

USE [FriasPaleteria]
GO

-- Crear el tipo de tabla para el detalle de la venta
CREATE TYPE TVP_DetalleVenta AS TABLE (
    idProducto INT,
    cantidad INT
);
GO

-- Venta 1
DECLARE @detalleVenta1 TVP_DetalleVenta;

INSERT INTO @detalleVenta1 (idProducto, cantidad)
VALUES
    (1, 5),
    (3, 3),
    (5, 2);

EXEC dbo.RegistrarVenta
    @idCliente = 1,
    @idTrabajador = 1,
    @fechaVenta = '2024-01-22',
    @total = 150.00,
    @detalleVenta = @detalleVenta1;

-- Venta 2
DECLARE @detalleVenta2 TVP_DetalleVenta;

INSERT INTO @detalleVenta2 (idProducto, cantidad)
VALUES
    (2, 4),
    (4, 2),
    (6, 1);

EXEC dbo.RegistrarVenta
    @idCliente = 2,
    @idTrabajador = 2,
    @fechaVenta = '2024-02-18',
    @total = 180.00,
    @detalleVenta = @detalleVenta2;

-- Venta 3
DECLARE @detalleVenta3 TVP_DetalleVenta;

INSERT INTO @detalleVenta3 (idProducto, cantidad)
VALUES
    (7, 6),
    (9, 3),
    (11, 2);

EXEC dbo.RegistrarVenta
    @idCliente = 3,
    @idTrabajador = 3,
    @fechaVenta = '2024-03-12',
    @total = 220.00,
    @detalleVenta = @detalleVenta3;

-- Generar 120 ventas aleatorias
DECLARE @i INT = 1;
DECLARE @fechaInicio DATE = '2024-01-01';
DECLARE @fechaFin DATE = '2024-12-31';

WHILE @i <= 120
BEGIN
    -- Generar datos aleatorios para la venta
    DECLARE @idCliente INT = (SELECT TOP 1 idCliente FROM Clientes ORDER BY NEWID());
    DECLARE @idTrabajador INT = (SELECT TOP 1 idTrabajador FROM Trabajadores ORDER BY NEWID());
    DECLARE @fechaVenta DATE = DATEADD(DAY, RAND() * DATEDIFF(DAY, @fechaInicio, @fechaFin), @fechaInicio);
    
    -- Generar detalles aleatorios para la venta
    DECLARE @detalleVenta TVP_DetalleVenta;
    INSERT INTO @detalleVenta (idProducto, cantidad)
    SELECT TOP (RAND() * 5 + 1) idProducto, RAND() * 10 + 1
    FROM Productos
    ORDER BY NEWID();
    
    -- Calcular el total de la venta
    DECLARE @total DECIMAL(10, 2);
    SELECT @total = SUM(p.precio * dv.cantidad)
    FROM @detalleVenta dv
    INNER JOIN Productos p ON dv.idProducto = p.idProducto;
    
    -- Ejecutar el procedimiento almacenado para registrar la venta
    EXEC dbo.RegistrarVenta
        @idCliente = @idCliente,
        @idTrabajador = @idTrabajador,
        @fechaVenta = @fechaVenta,
        @total = @total,
        @detalleVenta = @detalleVenta;
    
    SET @i = @i + 1;
END;

-- Cancelaciones de ejemplo (5 cancelaciones)
EXEC dbo.RegistrarVenta
    @idCliente = 16,
    @idTrabajador = 3,
    @fechaVenta = '2023-01-01',
    @total = 417.28,
    @detalleVenta = (SELECT idProducto, cantidad FROM DetalleTicket WHERE idTicket = 1),
    @esCancelacion = 1;

EXEC dbo.RegistrarVenta
    @idCliente = 19,
    @idTrabajador = 2,
    @fechaVenta = '2023-01-02',
    @total = 136.70,
    @detalleVenta = (SELECT idProducto, cantidad FROM DetalleTicket WHERE idTicket = 2),
    @esCancelacion = 1;

EXEC dbo.RegistrarVenta
    @idCliente = 6,
    @idTrabajador = 3,
    @fechaVenta = '2023-01-03',
    @total = 487.08,
    @detalleVenta = (SELECT idProducto, cantidad FROM DetalleTicket WHERE idTicket = 4),
    @esCancelacion = 1;

EXEC dbo.RegistrarVenta
    @idCliente = 19,
    @idTrabajador = 3,
    @fechaVenta = '2023-01-05',
    @total = 515.66,
    @detalleVenta = (SELECT idProducto, cantidad FROM DetalleTicket WHERE idTicket = 5),
    @esCancelacion = 1;


EXEC dbo.RegistrarVenta
    @idCliente = 5,
    @idTrabajador = 1,
    @fechaVenta = '2023-01-06',
    @total = 68.03,
    @detalleVenta = (SELECT idProducto, cantidad FROM DetalleTicket WHERE idTicket = 6),
    @esCancelacion = 1;

EXEC dbo.RegistrarVenta
    @idCliente = 8,
    @idTrabajador = 1,
    @fechaVenta = '2023-01-07',
    @total = 389.95,
    @detalleVenta = (SELECT idProducto, cantidad FROM DetalleTicket WHERE idTicket = 7),
    @esCancelacion = 1;

EXEC dbo.RegistrarVenta
    @idCliente = 20,
    @idTrabajador = 3,
    @fechaVenta = '2023-01-09',
    @total = 46.67,
    @detalleVenta = (SELECT idProducto, cantidad FROM DetalleTicket WHERE idTicket = 9),
    @esCancelacion = 1;

EXEC dbo.RegistrarVenta
    @idCliente = 18,
    @idTrabajador = 2,
    @fechaVenta = '2023-01-10',
    @total = 386.15,
    @detalleVenta = (SELECT idProducto, cantidad FROM DetalleTicket WHERE idTicket = 10),
    @esCancelacion = 1;

EXEC dbo.RegistrarVenta
    @idCliente = 20,
    @idTrabajador = 1,
    @fechaVenta = '2023-01-12',
    @total = 509.00,
    @detalleVenta = (SELECT idProducto, cantidad FROM DetalleTicket WHERE idTicket = 11),
    @esCancelacion = 1;

