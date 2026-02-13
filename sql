IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'TallerTextilDB')
CREATE DATABASE TallerTextilDB;
GO
USE TallerTextilDB;
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categorias]') AND type in
(N'U'))
BEGIN
 CREATE TABLE [dbo].[Categorias](
 [ID] INT PRIMARY KEY IDENTITY(1,1),
 [Nombre] NVARCHAR(100) NOT NULL
 )
END
GO 


IF NOT EXISTS (SELECT * FROM sys.objects 
               WHERE object_id = OBJECT_ID(N'[dbo].[CLIENTE]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[CLIENTE](
        id_cliente INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(150) NOT NULL,
        telefono NVARCHAR(50),
        empresa NVARCHAR(150),
        direccion NVARCHAR(200),
        tipo_cliente NVARCHAR(50)
    );
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects 
               WHERE object_id = OBJECT_ID(N'[dbo].[EMPLEADA]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[EMPLEADA](
        id_empleada INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(150) NOT NULL,
        telefono NVARCHAR(50),
        fecha_ingreso DATE,
        salario_base DECIMAL(10,2),
        estado NVARCHAR(50)
    );
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects 
               WHERE object_id = OBJECT_ID(N'[dbo].[TELA]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[TELA](
        id_tela INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(150) NOT NULL,
        tipo NVARCHAR(100),
        color NVARCHAR(100),
        costo_por_metro DECIMAL(10,2),
        stock_actual_metros DECIMAL(10,2)
    );
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects 
               WHERE object_id = OBJECT_ID(N'[dbo].[PEDIDO]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[PEDIDO](
        id_pedido INT IDENTITY(1,1) PRIMARY KEY,
        id_cliente INT NOT NULL,
        fecha_pedido DATE,
        fecha_entrega DATE,
        estado NVARCHAR(50),
        total_prendas INT,
        precio_total DECIMAL(12,2),
        ganancia DECIMAL(12,2)
    );
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects 
               WHERE object_id = OBJECT_ID(N'[dbo].[DETALLE_PEDIDO]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[DETALLE_PEDIDO](
        id_detalle INT IDENTITY(1,1) PRIMARY KEY,
        id_pedido INT NOT NULL,
        tipo_prenda NVARCHAR(100),
        talla NVARCHAR(20),
        cantidad INT,
        precio_unitario DECIMAL(10,2)
    );
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects 
               WHERE object_id = OBJECT_ID(N'[dbo].[PRODUCCION]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[PRODUCCION](
        id_produccion INT IDENTITY(1,1) PRIMARY KEY,
        id_detalle INT NOT NULL,
        id_empleada INT NOT NULL,
        cantidad_asignada INT,
        cantidad_terminada INT,
        fecha_inicio DATE,
        fecha_fin DATE,
        estado NVARCHAR(50)
    );
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects 
               WHERE object_id = OBJECT_ID(N'[dbo].[PAGOS_MANO_OBRA]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[PAGOS_MANO_OBRA](
        id_pago INT IDENTITY(1,1) PRIMARY KEY,
        id_empleada INT NOT NULL,
        id_pedido INT NOT NULL,
        monto DECIMAL(10,2),
        fecha DATE
    );
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects 
               WHERE object_id = OBJECT_ID(N'[dbo].[GASTOS]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[GASTOS](
        id_gasto INT IDENTITY(1,1) PRIMARY KEY,
        tipo_gasto NVARCHAR(100),
        monto DECIMAL(10,2),
        fecha DATE,
        descripcion NVARCHAR(200)
    );
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects 
               WHERE object_id = OBJECT_ID(N'[dbo].[COMPRA_TELA]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[COMPRA_TELA](
        id_compra INT IDENTITY(1,1) PRIMARY KEY,
        id_tela INT NOT NULL,
        fecha_compra DATE,
        metros_comprados DECIMAL(10,2),
        costo_total DECIMAL(12,2)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects 
               WHERE object_id = OBJECT_ID(N'[dbo].[CONSUMO_TELA]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[CONSUMO_TELA](
        id_consumo INT IDENTITY(1,1) PRIMARY KEY,
        id_pedido INT NOT NULL,
        metros_usados DECIMAL(10,2),
        merma DECIMAL(10,2),
        fecha DATE
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PEDIDO_CLIENTE')
ALTER TABLE PEDIDO
ADD CONSTRAINT FK_PEDIDO_CLIENTE
FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente);
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_DETALLE_PEDIDO_PEDIDO')
ALTER TABLE DETALLE_PEDIDO
ADD CONSTRAINT FK_DETALLE_PEDIDO_PEDIDO
FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido);
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PRODUCCION_DETALLE')
ALTER TABLE PRODUCCION
ADD CONSTRAINT FK_PRODUCCION_DETALLE
FOREIGN KEY (id_detalle) REFERENCES DETALLE_PEDIDO(id_detalle);
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PRODUCCION_EMPLEADA')
ALTER TABLE PRODUCCION
ADD CONSTRAINT FK_PRODUCCION_EMPLEADA
FOREIGN KEY (id_empleada) REFERENCES EMPLEADA(id_empleada);
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PAGO_EMPLEADA')
ALTER TABLE PAGOS_MANO_OBRA
ADD CONSTRAINT FK_PAGO_EMPLEADA
FOREIGN KEY (id_empleada) REFERENCES EMPLEADA(id_empleada);
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PAGO_PEDIDO')
ALTER TABLE PAGOS_MANO_OBRA
ADD CONSTRAINT FK_PAGO_PEDIDO
FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido);
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_COMPRA_TELA')
ALTER TABLE COMPRA_TELA
ADD CONSTRAINT FK_COMPRA_TELA
FOREIGN KEY (id_tela) REFERENCES TELA(id_tela);
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_CONSUMO_PEDIDO')
ALTER TABLE CONSUMO_TELA
ADD CONSTRAINT FK_CONSUMO_PEDIDO
FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido);
GO
