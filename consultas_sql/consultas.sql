SELECT
    registro_seccional.descripcion AS registro_seccional_descripcion,
    automotor.automotor_anio_modelo,
    COUNT(*) AS cantidad
FROM
    transferencia
    INNER JOIN automotor ON transferencia.automotor_id = automotor.id
    INNER JOIN registro_seccional ON automotor.registro_seccional_id = registro_seccional.id
GROUP BY
    registro_seccional.descripcion,
    automotor.automotor_anio_modelo;

SELECT
    tipo_automotor.codigo AS automotor_tipo_codigo,
    tipo_automotor.descripcion AS automotor_tipo_descripcion,
    automotor.modelo_descripcion AS automotor_modelo_descripcion,
    COUNT(*) AS cantidad
FROM
    transferencia
    INNER JOIN automotor ON transferencia.automotor_id = automotor.id
    INNER JOIN tipo_automotor ON automotor.tipo_automotor_id = tipo_automotor.id
GROUP BY
    tipo_automotor.codigo,
    tipo_automotor.descripcion,
    automotor.modelo_descripcion;

SELECT automotor.tramite_fecha, automotor.automotor_origen, COUNT(*) AS cantidad
FROM transferencia
    INNER JOIN automotor ON transferencia.automotor_id = automotor.id
GROUP BY
    automotor.tramite_fecha,
    automotor.automotor_origen
ORDER BY automotor.tramite_fecha DESC;