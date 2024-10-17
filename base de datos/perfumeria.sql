-- Creamos la Base de Datos
CREATE DATABASE IF NOT EXISTS perfumeria;
-- Usamos la Base de Datos para crear las tablas
USE perfumeria;
-- Creamos la Tabla Usuario
CREATE TABLE Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(100) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    CONSTRAINT chk_email CHECK (email LIKE '%_@__%.__%')
    );
-- Creamos la Tabla Administrador
CREATE  TABLE Administrador (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    nivel_acceso ENUM('superadmin', 'admin') NOT NULL DEFAULT 'admin',
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id)
    );
-- Creamos la Tabla Marca
CREATE TABLE Marca (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- Creamos la Tabla Categoria
CREATE TABLE Categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- Creamos la Tabla Producto
CREATE TABLE Producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    id_marca INT,
    id_categoria INT,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    stock INT NOT NULL CHECK (stock >= 0),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    imagen_url VARCHAR(255),
    FOREIGN KEY (id_marca) REFERENCES Marca(id),
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id)
);
-- Creamos la Tabla Froma_Pago
CREATE TABLE Forma_Pago (
    id INT AUTO_INCREMENT PRIMARY KEY,
    metodo VARCHAR(50) NOT NULL,
    descripcion TEXT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- Creamos la Tabla Factura
CREATE TABLE Factura (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    id_forma_pago INT,
    fecha DATE NOT NULL,
    total DECIMAL(10, 2) NOT NULL CHECK (total >= 0),
    direccion_envio VARCHAR(255),
    estado ENUM('pendiente', 'pagado', 'cancelado') DEFAULT 'pendiente',
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id),
    FOREIGN KEY (id_forma_pago) REFERENCES Forma_Pago(id)
);
-- Creamos la Tabla Detalle_Factura
CREATE TABLE Detalle_Factura (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_factura INT,
    id_producto INT,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    subtotal DECIMAL(10, 2) NOT NULL CHECK (subtotal >= 0),
    FOREIGN KEY (id_factura) REFERENCES Factura(id),
    FOREIGN KEY (id_producto) REFERENCES Producto(id)
);

-- Añadimos comentarios a todas las Tablas
ALTER TABLE Usuario COMMENT 'Almacena información sobre los usuarios registrados';
ALTER TABLE Administrador COMMENT 'Almacena información sobre los administradores del sustema';
ALTER TABLE Marca COMMENT 'Almacena información sobre las marcas de los productos';
ALTER TABLE Categoria COMMENT 'Almacena información sobre las categórias de los productos';
ALTER TABLE Producto COMMENT 'Almacena información sobre los productos';
ALTER TABLE Forma_Pago COMMENT 'Almacena información sobre los métodos de pagos';
ALTER TABLE Factura COMMENT 'Almacena información sobre las facturas';
ALTER TABLE Detalle_Factura COMMENT 'Almacena información detallada de los productos en cada factura';
-- Agragamos Indices para un mejor rendimiento de las consultas
CREATE INDEX idx_usuario_email ON Usuario(email);
CREATE INDEX idx_producto_marca ON Producto(id_marca);
CREATE INDEX idx_producto_categoria ON Producto(id_categoria);
CREATE INDEX idx_factura_usuario ON Factura(id_usuario);
CREATE INDEX idx_detalle_factura_factura ON Detalle_Factura(id_factura);
CREATE INDEX idx_detalle_factura_producto ON Detalle_Factura(id_producto);
CREATE INDEX idx_factura_forma_pago ON Factura(id_forma_pago);