# Hallazgos técnicos de SiGesCom

> **Actualización:** la recuperación ya fue ejecutada y validada en un laboratorio aislado. SiGesCom alcanzó la ventana principal, reconoció `ZAREK` y cargó un módulo con datos de la base de laboratorio. Además, se consolidó una solución privada de 13 proyectos que compila completa. Consulte [RECUPERACION-EJECUTADA.md](RECUPERACION-EJECUTADA.md) y [RECUPERACION-DE-FUENTE.md](RECUPERACION-DE-FUENTE.md).

Investigación estática y pruebas locales no destructivas realizadas el 15 de noviembre de 2026 sobre una copia autorizada de SiGesCom.

## Resultado principal

- La base restaurada está íntegra y operativa en SQL Server Express.
- El bloqueo actual ocurre antes de que el programa consulte SQL Server: el ejecutable compara una huella cifrada del procesador y de discos no USB con un valor incorporado en el propio binario.
- `EstacionTrabajo` es un control adicional. Registrar `ZAREK` es técnicamente posible, pero no elimina el primer bloqueo.
- Se reconstruyó y compiló experimentalmente la aplicación principal con Visual Studio 2026 y .NET Framework 4.8.
- Se exportaron 12 bibliotecas propias adicionales y las 12 llegaron a compilar en copias aisladas tras ajustes menores documentados.
- No se modificaron el licenciamiento, las credenciales, el ejecutable productivo ni los datos de la base.

El informe completo está en [INVESTIGACION-AVANZADA.md](INVESTIGACION-AVANZADA.md). Los resultados mecánicos de las pruebas están en [evidencia/resultado-compilacion.json](evidencia/resultado-compilacion.json).

## Contenido deliberadamente excluido

Este repositorio no contiene binarios, respaldos SQL, archivos de configuración, cadenas de conexión, credenciales, huellas de hardware, claves de activación, código descompilado ni componentes de terceros. Consulte [MANIFIESTO-DE-PUBLICACION.md](MANIFIESTO-DE-PUBLICACION.md).

