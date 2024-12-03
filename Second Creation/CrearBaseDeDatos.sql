CREATE TABLE Proveedor (
    idProveedor INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Direccion VARCHAR(200),
    Telefono VARCHAR(20)
);

CREATE TABLE Empleado (
    idEmpleado INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE Producto (
    idProducto INT PRIMARY KEY,
    descripcion VARCHAR(200),
    precioUnitario DECIMAL(10, 2),
    idCategoria INT,
    idTamaño INT,
    idSabor INT,
    stock INT,
    descuento DECIMAL(5, 2),
    porcentajeIVA DECIMAL(5, 2)
);

CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    email VARCHAR(100),
    tipoCliente VARCHAR(20)
);

CREATE TABLE Compra (
    idCompra INT PRIMARY KEY,
    idProveedor INT,
    fecha DATE,
    totalPagado DECIMAL(10, 2),
    idEmpleado INT,
    FOREIGN KEY (idProveedor) REFERENCES Proveedor(idProveedor),
    FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado)
);

CREATE TABLE DetalleCompra (
    idDetalleCompra INT PRIMARY KEY,
    idCompra INT,
    idProducto INT,
    cantidad INT,
    precioUnitario DECIMAL(10, 2),
    FOREIGN KEY (idCompra) REFERENCES Compra(idCompra),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);

CREATE TABLE Ticket (
    idTicket INT PRIMARY KEY,
    fecha DATE,
    total DECIMAL(10, 2),
    subtotal DECIMAL(10, 2),
    iva DECIMAL(10, 2),
    descuentoAplicado DECIMAL(10, 2),
    folio VARCHAR(20),
    idCliente INT,
    idEmpleado INT,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado)
);

CREATE TABLE TicketProducto (
    idTicketProducto INT PRIMARY KEY,
    idTicket INT,
    idProducto INT,
    cantidad INT,
    total DECIMAL(10, 2),
    FOREIGN KEY (idTicket) REFERENCES Ticket(idTicket),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);

CREATE TABLE Cuenta (
    idCuenta INT PRIMARY KEY,
    saldo DECIMAL(10, 2)
);

CREATE TABLE PagoEmpleado (
    idPagoEmpleado INT PRIMARY KEY,
    idEmpleado INT,
    fecha DATE,
    monto DECIMAL(10, 2),
    FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado)
);