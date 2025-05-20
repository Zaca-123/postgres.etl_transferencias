SELECT
    transferencia.registro_seccional_descripcion AS registro_seccional_descripcion,
    transferencia.automotor_anio_modelo,
    COUNT(*) AS cantidad
FROM transferencia
GROUP BY
    transferencia.registro_seccional_descripcion,
    transferencia.automotor_anio_modelo;

SELECT
    transferencia.automotor_tipo_codigo AS automotor_tipo_codigo,
    transferencia.automotor_tipo_descripcion AS automotor_tipo_descripcion,
    transferencia.automotor_modelo_descripcion AS automotor_modelo_descripcion,
    COUNT(*) AS cantidad
FROM transferencia
GROUP BY
    transferencia.automotor_tipo_codigo,
    transferencia.automotor_tipo_descripcion,
    transferencia.automotor_modelo_descripcion;

SELECT transferencia.tramite_fecha, transferencia.automotor_origen, COUNT(*) AS cantidad
FROM transferencia
GROUP BY
    transferencia.tramite_fecha,
    transferencia.automotor_origen
ORDER BY transferencia.tramite_fecha DESC;