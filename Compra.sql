USE [FriasPaleteria]
GO

-- Crear el tipo de tabla para el detalle del pedido
CREATE TYPE TVP_DetallePedido AS TABLE (
    idProducto INT,
    cantidad INT
);
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