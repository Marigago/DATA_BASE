USE [FriasPaleteria]
GO
/****** Object:  StoredProcedure [dbo].[RegistrarPagoEmpleado]    Script Date: 06/05/2024 10:37:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[RegistrarPagoEmpleado]
    @idTrabajador INT,
    @monto DECIMAL(10,2),
    @fecha DATE
AS
BEGIN
    -- Insertar el movimiento en la tabla Movimientos
    INSERT INTO Movimientos (idCuenta, fecha, tipo, monto, descripcion)
    VALUES (1, @fecha, 'Egreso', @monto, 'Pago a empleado: ' + CAST(@idTrabajador AS VARCHAR(10)));

    -- Actualizar el saldo de la cuenta
    UPDATE Cuenta SET saldo = saldo - @monto WHERE idCuenta = 1;
END