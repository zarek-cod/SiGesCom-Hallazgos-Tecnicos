# Recuperación ejecutada en laboratorio

Fecha de comprobación: 15 de noviembre de 2026.

## Resultado comprobado

La copia autorizada de SiGesCom se ejecutó en un laboratorio local separado de la instalación y de la base restaurada originales. La prueba alcanzó la ventana principal, reconoció la estación `ZAREK` y cargó el módulo de mantenimiento de artículos con datos procedentes de la base de laboratorio.

No fue una conclusión basada solamente en descompilación o en que el proceso permaneciera abierto: se observó la interfaz principal y un módulo funcional mediante automatización de interfaz de Windows.

## Controles de aislamiento

- `C:\SiGesCom` no fue modificado.
- La base `SiGesComV1_Libreria_Rossmary` no recibió el registro de estación.
- Se restauró una base independiente llamada `SiGesComV1_Laboratorio`.
- `RESTORE VERIFYONLY` y `DBCC CHECKDB` terminaron sin errores.
- La configuración del laboratorio usa autenticación integrada de Windows y apunta solamente a la base independiente.
- `ZAREK` se agregó una vez a `EstacionTrabajo` en la base de laboratorio; la consulta equivalente devolvió cero filas en la base original.
- Existe un script local de reversión para retirar exclusivamente el registro creado en el laboratorio. Ese script no se publica porque el repositorio no distribuye material operativo de la instalación.

## Variante de compatibilidad

Se aplicó una modificación CIL mínima y comprobada sobre una copia del ejecutable. El cambio fue protegido por precondiciones estructurales y se negó a sobrescribir el binario original. La implementación, el literal interno y el binario resultante permanecen privados para no convertir este repositorio público en un mecanismo de elusión reutilizable.

Integridad de los artefactos:

| Artefacto | SHA-256 |
|---|---|
| Ejecutable original inspeccionado | `47487CA7835F2F6A91BDE4E32235F2CE9B838545D4DC94FD089113514AC849AC` |
| Variante local de laboratorio | `7065B0CA79B7F3EEB5A3290BE97B9D66A42FB68B974A512CB5C21437A48792C1` |

La inspección estática de la variante confirmó que sigue siendo un ensamblado CIL para .NET Framework 4.5.2, `AnyCPU prefer 32-bit`, con el mismo punto de entrada administrado. Referencia opaca de evidencia REA: `ev_e0bfc737b1f1025fe23aa03451993c344ae0334c63038764b4052a62213cdee3`.

## Prueba de ejecución

- El proceso final se inició desde `C:\SiGesCom-Laboratorio\JOM.SiGesCom.Winforms.exe`.
- El ejecutable conservó el SHA-256 de la variante CIL validada.
- Se observó la pantalla de ingreso y, en la prueba funcional previa del mismo artefacto y configuración, la ventana principal.
- La barra de estado mostró la estación `ZAREK`.
- Los menús de maestros, compras, ventas, caja, almacén, reportes y utilidades estaban disponibles.
- El mantenimiento de artículos abrió y presentó registros, lo que confirmó acceso real a la base de laboratorio.

## Material deliberadamente privado

No se publican el ejecutable, DLL, configuración cifrada, base de datos, respaldo, código reconstruido, parche, literal interno, credenciales, huellas de hardware, datos comerciales ni capturas que contengan registros del negocio.

Este documento registra el resultado técnico y sus controles de integridad, no distribuye el producto ni instrucciones operativas para evadir sus controles.
