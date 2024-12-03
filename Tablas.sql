-- Tabla Categoria
CREATE TABLE Categoria (
    idCategoria INT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Tabla Productos
CREATE TABLE Productos (
    idProducto INT PRIMARY KEY,
    nombre VARCHAR(100),
    idCategoria INT,
    precio DECIMAL(10,2),
    stock INT,
    FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
);

-- Tabla Clientes
CREATE TABLE Clientes (
    idCliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    telefono VARCHAR(20),
    idTipoCliente INT
);

-- Tabla Trabajadores
CREATE TABLE Trabajadores (
    idTrabajador INT PRIMARY KEY,
    nombre VARCHAR(100),
    telefono VARCHAR(20),
    salario DECIMAL(10,2)
);

-- Tabla Proveedor
CREATE TABLE Proveedor (
    idProveedor INT PRIMARY KEY,
    nombre VARCHAR(100),
    telefono VARCHAR(20)
);

-- Tabla Pedidos
CREATE TABLE Pedidos (
    idPedido INT PRIMARY KEY,
    idProveedor INT,
    fechaPedido DATE,
    fechaPago DATE,
    total DECIMAL(10,2),
    idTrabajador INT,
    FOREIGN KEY (idProveedor) REFERENCES Proveedor(idProveedor),
    FOREIGN KEY (idTrabajador) REFERENCES Trabajadores(idTrabajador)
);

-- Tabla DetallePedido
CREATE TABLE DetallePedido (
    idPedido INT,
    idProducto INT,
    cantidad INT,
    PRIMARY KEY (idPedido, idProducto),
    FOREIGN KEY (idPedido) REFERENCES Pedidos(idPedido),
    FOREIGN KEY (idProducto) REFERENCES Productos(idProducto)
);

-- Tabla Ventas
CREATE TABLE Ventas (
    idVenta INT PRIMARY KEY,
    idCliente INT,
    idTrabajador INT,
    fechaVenta DATE,
    total DECIMAL(10,2),
    FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente),
    FOREIGN KEY (idTrabajador) REFERENCES Trabajadores(idTrabajador)
);

CREATE TYPE TVP_DetalleVenta AS TABLE (
    idProducto INT,
    cantidad INT
);

CREATE TYPE TVP_DetallePedido AS TABLE (
    idProducto INT,
    cantidad INT
);
GO

-- Tabla Asistencia
CREATE TABLE Asistencia (
    idAsistencia INT PRIMARY KEY,
    idTrabajador INT,
    fecha DATE,
    horaEntrada TIME,
    horaSalida TIME,
    FOREIGN KEY (idTrabajador) REFERENCES Trabajadores(idTrabajador)
);

-- Tabla Cuenta
CREATE TABLE Cuenta (
    idCuenta INT PRIMARY KEY,
    titular VARCHAR(100),
    numeroCuenta VARCHAR(20),
    saldo DECIMAL(10,2)
);

-- Tabla Movimientos
CREATE TABLE Movimientos (
    idMovimiento INT PRIMARY KEY,
    idCuenta INT,
    fecha DATE,
    tipo VARCHAR(20),
    monto DECIMAL(10,2),
    descripcion VARCHAR(100),
    FOREIGN KEY (idCuenta) REFERENCES Cuenta(idCuenta)
);

-- Tabla Ticket
CREATE TABLE Ticket (
    idTicket INT PRIMARY KEY,
    idVenta INT,
    fecha DATE,
    hora TIME,
    total DECIMAL(10,2),
    descuento DECIMAL(10,2),
    iva DECIMAL(10,2),
    FOREIGN KEY (idVenta) REFERENCES Ventas(idVenta)
);

-- Tabla DetalleTicket
CREATE TABLE DetalleTicket (
    idTicket INT,
    cantidad INT,
    precioUnitario DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    PRIMARY KEY (idTicket),
    FOREIGN KEY (idTicket) REFERENCES Ticket(idTicket)
);

CREATE TABLE TipoCliente (
    idTipoCliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    descuento DECIMAL(5,2)
);