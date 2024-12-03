USE [FriasPaleteria]
GO

CREATE PROCEDURE [dbo].[RegistrarAsistencia]
    @idTrabajador INT,
    @fecha DATE,
    @horaEntrada TIME,
    @horaSalida TIME
AS
BEGIN
    -- Verificar si ya existe un registro de asistencia para el trabajador en la fecha especificada
    IF NOT EXISTS (SELECT * FROM Asistencia WHERE idTrabajador = @idTrabajador AND fecha = @fecha)
    BEGIN
        -- Obtener el último ID de asistencia
        DECLARE @idAsistencia INT;
        SELECT @idAsistencia = ISNULL(MAX(idAsistencia), 0) + 1 FROM Asistencia;
        
        -- Insertar el registro de asistencia
        INSERT INTO Asistencia (idAsistencia, idTrabajador, fecha, horaEntrada, horaSalida)
        VALUES (@idAsistencia, @idTrabajador, @fecha, @horaEntrada, @horaSalida);
        
        PRINT 'Asistencia registrada correctamente.';
    END
    ELSE
    BEGIN
        PRINT 'Ya existe un registro de asistencia para el trabajador en la fecha especificada.';
    END
END