# Investigación avanzada de SiGesCom

Fecha de corte: 15 de noviembre de 2026. Entorno: Windows 11, Visual Studio Community 2026 18.11, SQL Server 2025 Express 17.0.1155.3. Investigación efectuada sobre copias locales autorizadas.

## Respuesta ejecutiva: hasta dónde se puede llegar

Se puede llegar bastante lejos: el código administrado no presenta una ofuscación relevante, conserva nombres semánticos y permite reconstruir proyectos editables. La aplicación principal y las 12 bibliotecas propias analizadas llegaron a compilar en copias aisladas redestinadas a .NET Framework 4.8. Esto permite estudiar, mantener y modernizar el sistema si se cuenta con los derechos necesarios.

Lo que no se obtiene es el proyecto original exacto. Se pierden comentarios, historial, pruebas, nombres locales que no sobreviven a la compilación, estructura original de la solución, configuraciones de compilación y parte de la intención de diseño. Compilar tampoco prueba equivalencia binaria ni funcional: hace falta una campaña de pruebas por módulo.

El obstáculo para ejecutar la instalación original en `ZAREK` no es SQL Server. Hay tres controles distintos:

1. Una huella de hardware incorporada en `Program.Main`, evaluada antes de inicializar la conexión de datos.
2. Una búsqueda posterior de `Environment.MachineName` en `EstacionTrabajo`, limitada a registros activos.
3. Una verificación de vigencia/pago al cargar la pantalla inicial, con actualización remota de una fecha cifrada y validación local en la tabla `Configuracion`.

Por tanto, agregar `ZAREK` a SQL es técnicamente posible, pero por sí solo no hace arrancar el ejecutable actual. La ruta legítima requiere autorización del proveedor o del titular del código para emitir una autorización de hardware nueva o recompilar una versión autorizada, además de registrar la estación y conservar la vigencia comercial.

## 1. Validación de hardware y relación con SQL Server

### Flujo observado

- `Program.Main` llama a `Funciones.ObtenerKeyPC()` y compara el resultado contra un literal cifrado incorporado en el ejecutable.
- Si no coincide, muestra el aviso de equipo no autorizado y ejecuta `return`.
- Solo después configura la aplicación y la conexión predeterminada.
- A continuación crea `EstacionesTrabajo`, filtra por `Nombre = Environment.MachineName` y únicamente inicia `frmInicio` si encuentra al menos una fila activa.
- Al cargar `frmInicio`, el programa consulta un servicio configurado de verificación de pago/vigencia, actualiza el valor cifrado local y valida la fecha contra la hora del servidor SQL.

### Datos de la huella

`ObtenerKeyPC()` concatena:

- `Win32_Processor.ProcessorId` de los procesadores informados por WMI.
- `Win32_DiskDrive.SerialNumber` de discos cuya interfaz no es USB.

Luego cifra la cadena con la rutina `Criptografia.Encriptar`. En la prueba controlada la huella de `ZAREK` fue distinta de la incorporada. El valor identificador no se publica.

### Papel de `EstacionTrabajo`

- La tabla contiene varias filas, lo que demuestra soporte para más de una estación.
- Su clave primaria es `IdEstacionTrabajo`; `Nombre` no tiene restricción única.
- Tiene una clave foránea hacia `Local` mediante `IdLocal`.
- La clase `EstacionesTrabajo.Buscar` filtra por `EstadoRegistro = 'A'` y, cuando se indica, por `Nombre`.
- La entidad `EstacionTrabajo.Guardar` implementa inserción y actualización. Por ello el registro local de una estación es técnicamente viable.
- No se encontró un formulario dedicado de mantenimiento de estaciones entre las clases de la interfaz. El registro parece quedar para instalación, soporte o mantenimiento de datos.
- La tabla no participa en el cálculo de la huella ni reemplaza el literal del ejecutable. Es una segunda autorización, no la licencia primaria.

### Activación y migración autorizada

Existe una pantalla `frmActivacionLocal` que acepta un código cifrado con documento de empresa y fecha, y actualiza la configuración de vigencia. Esa activación comercial no modifica la huella de CPU/discos.

No se encontró una función local que sustituya el valor de hardware incorporado ni un procedimiento automático de migración. En consecuencia, una migración legítima depende de una de estas rutas:

- proveedor/titular emite un ejecutable autorizado para la huella nueva;
- proveedor/titular entrega una herramienta o procedimiento de migración no incluido en esta copia;
- titular del código autoriza una recompilación controlada y documentada.

No se cambió ningún valor de licencia ni se insertó `ZAREK`.

## 2. Recuperación real de código y recursos

### Evidencia de exportación

- REA clasificó el ejecutable como PE administrado con CIL, .NET Framework, `AnyCPU prefer 32-bit` y punto de entrada administrado.
- ILSpy 11.2 exportó la aplicación principal a 175 archivos C#, 135 `.resx`, 489 entradas de recursos y aproximadamente 75,271 líneas.
- dnSpyEx 6.6.0 produjo una solución con 312 archivos C#, 139 archivos `Designer.cs`, 138 `.resx` y aproximadamente 89,176 líneas. Su separación de diseñador es útil, aunque esa exportación presentó 32 errores sintácticos en cuatro archivos.
- ILSpy exportó 12 bibliotecas propias adicionales a 494 archivos C# y aproximadamente 87,519 líneas.
- En total, la reconstrucción ILSpy abarcó 13 ensamblados propios, 669 archivos C# y aproximadamente 162,793 líneas después de tres correcciones de metadatos COM.
- No había PDB junto a los binarios, por lo que no se recuperaron nombres y rutas de depuración originales.

### Compilación comprobada

La exportación ILSpy de la aplicación principal se compiló con MSBuild de Visual Studio 2026:

- Primer intento: falló porque la instalación solo conservaba XML de documentación de .NET 4.5.2, no sus ensamblados de referencia.
- Segundo intento: se redestinó la copia aislada a .NET Framework 4.8; aparecía una referencia indirecta no declarada a `DevExpress.Drawing.v22.2`.
- Tercer intento: tras agregar esa referencia directa, compiló con 0 errores y 11 advertencias.

Las 12 bibliotecas propias también compilaron en .NET 4.8:

- 9 compilaron sin reparación adicional.
- `JOM.FE.Api` y `JOM.SiGesCom.Reportes` requirieron activar la referencia de Windows Forms.
- `JOM.Control.Winforms` requirió restaurar tres GUID de interfaces de eventos COM de Excel que no fueron emitidos correctamente por el descompilador.
- Resultado final: 12 de 12 bibliotecas con 0 errores de compilación.

La prueba demuestra viabilidad de reconstrucción. Todavía no demuestra paridad funcional, funcionamiento del diseñador visual para cada formulario ni equivalencia de reportes, impresión, facturación electrónica y llamadas remotas.

### Qué se recupera y qué no

| Elemento | Resultado real |
|---|---|
| C# de formularios | Alto: código legible, nombres y métodos preservados. |
| Clases, métodos y propiedades | Alto: metadatos CIL completos y nombres semánticos. |
| Eventos de controles | Alto: 137 `InitializeComponent` y cientos de enlaces de eventos recuperados. |
| SQL y acceso a datos | Alto: consultas y operaciones CRUD visibles; también hay lógica SQL en las entidades. |
| Lógica de negocio | Alto para lo compilado en CIL; necesita pruebas para confirmar intención y casos límite. |
| Reportes | 41 RDLC en `JOM.SiGesCom.Reportes` y 7 RDLC en `JOM.FE.Api` fueron inventariados. |
| Recursos e iconos | Alto: 489 entradas del ejecutable y recursos visuales exportados. |
| Diseño WinForms | Medio-alto: 137 formularios/controles marcados para diseñador, 139 `Designer.cs` y 138 `.resx` en la exportación dnSpyEx. |
| Configuración | Estructura recuperable, pero no debe publicarse porque contiene datos sensibles. |
| Solución compilable | Sí, reconstruida; no es la solución original exacta. |

### Herramientas

- REA 6.8.0: identidad, CIL, miembros, llamadas, cadenas y límites administrado/nativo.
- ILSpy 11.2.0.10050: exportación que produjo el proyecto compilable.
- dnSpyEx 6.6.0 oficial: segunda exportación y separación de archivos de diseñador.
- Visual Studio 2026 / MSBuild: compilaciones reales.
- SQL Server y `sqlcmd`: verificación de esquema y controles de estación, solo lectura.
- Ghidra 12.1.4: se verificó su disponibilidad. El proveedor REA de Ghidra en Windows declara los objetivos administrados como no admitidos; por eso no se usó para convertir el CIL a C#. Ghidra es adecuado para los cargadores y DLL nativas, pero no mejora la reconstrucción de este ejecutable administrado.

Referencias REA reutilizables:

- Instalación de escritorio: `ev_898ebbc24696d81ee6b272244b2109ab4bcddf76ba0d045f29314525b40a8155`.
- Identidad administrada: `ev_f0e65b1eff9b8d2cd3c04998f53bfacc955f02ed79ed699fd0dd65b2821965e8`.
- Flujo de arranque seleccionado: `ev_5794634ee5fb0a4ade46bd65cc596c40bb76faf2ea554d3b049c2bbfaebbe28b`.

## 3. Opciones de modernización

### Opción A: reconstruir el .NET existente

Es la ruta más rápida para recuperar mantenimiento y cambiar tema, login, botones, tablas y formularios. Conserva la lógica y reduce el riesgo funcional inicial. Sus desventajas son la deuda de WinForms/.NET Framework, SQL embebido, acoplamiento global y dependencia de componentes comerciales antiguos.

Recomendación: usarla como base de rescate y estabilización, no como arquitectura final.

### Opción B: conservar componentes reutilizables y crear interfaz nueva

Es la mejor relación entre riesgo y modernización. Se pueden aislar primero acceso a datos y reglas, definir servicios internos y sustituir pantallas por módulos. WPF es el destino de menor fricción para reutilizar .NET/Windows; WinUI 3 exige más adaptación, especialmente para reportes, impresión, controles de terceros y componentes de .NET Framework.

Recomendación: opción preferida si se necesita continuidad operativa y migración gradual.

### Opción C: aplicación nueva compatible con el esquema SQL

Ofrece la mejor arquitectura a largo plazo y evita perpetuar código reconstruido. Requiere documentar el esquema, procedimientos, reglas, transacciones, correlativos, facturación, reportes e integraciones. Debe evitar depender directamente de detalles accidentales del esquema mediante una API o capa de compatibilidad.

Recomendación: destino estratégico si se dispone de presupuesto para validación funcional completa. Puede iniciarse por módulos de menor riesgo y convivir temporalmente con SiGesCom.

## 4. Tabla de viabilidad solicitada

Las probabilidades son estimaciones técnicas, no garantías. Se basan en las pruebas locales descritas, no en una revisión contractual ni en una prueba exhaustiva de producción.

| Objetivo | ¿Técnicamente posible? | Probabilidad estimada | Evidencia encontrada | Herramientas necesarias | Dificultad | Limitaciones | Próximo paso recomendado |
|---|---:|---:|---|---|---|---|---|
| 1. Registrar `ZAREK` como estación adicional | Sí | 95% para el registro | Varias filas admitidas; `Nombre` no es único; `Guardar` implementa INSERT/UPDATE | SQL Server o procedimiento autorizado de la aplicación | Baja-media | No autoriza la huella y debe conservar empresa/local/auditoría coherentes | Obtener autorización y registrar mediante procedimiento controlado; no hacerlo como sustituto de licencia |
| 2. Migrar legalmente la licencia del otro equipo | Condicional | 60% si el proveedor/titular coopera; indeterminada sin él | Huella embebida, activación comercial separada y sin migrador local hallado | Proveedor, prueba de titularidad, código/compilación autorizada | Media-alta | Depende de contrato, proveedor y licencias de terceros | Solicitar reemisión para la nueva huella y confirmar transferencia/licencias |
| 3. Hacer funcionar la instalación en esta computadora | Sí, con autorización completa | 80% con autorización; 0% mediante estación sola | SQL y dependencias funcionan; el arranque se detiene antes de SQL por la huella | Proveedor o recompilación autorizada, alta de estación, pruebas | Media | Después quedan vigencia, reportes, impresoras e integraciones | Resolver autorización de hardware, luego alta de estación y prueba por módulos |
| 4. Recuperar C# mediante descompilación | Sí | 95% para una reconstrucción legible | 13 ensamblados, 669 archivos, ~162.8 mil líneas | REA, ILSpy, dnSpyEx | Media | No recupera fuente exacta, comentarios, historial ni PDB | Consolidar solución privada y documentar diferencias |
| 5. Reconstruir formularios Windows Forms | Sí | 90% | 137 formularios/controles de diseñador, 139 Designer y 138 RESX | dnSpyEx/ILSpy, Visual Studio, librerías de UI | Media-alta | Algunos formularios pueden no abrir en diseñador por bases personalizadas/licencias | Probar diseñador y ejecución en una muestra representativa por módulo |
| 6. Recuperar recursos y diseños | Sí | 92% | 489 entradas del EXE; 48 RDLC en dos bibliotecas | ILSpy/dnSpyEx, editor RDLC | Media | Recursos embebidos pueden perder nombres/organización original | Crear inventario visual y validar cada reporte con datos de prueba |
| 7. Volver a compilar una versión funcional | Sí, demostrado a nivel de compilación | 85% para compilar; 65-80% para paridad inicial | Aplicación principal y 12/12 bibliotecas compilaron en copias net48 | VS 2026, .NET 4.8, DLL autorizadas, pruebas | Alta | Compilar no prueba comportamiento; existen integraciones y licencias comerciales | Crear solución privada enlazada por proyectos y ejecutar pruebas de regresión |
| 8. Modificar apariencia e interfaz | Sí | 90% para cambios visuales; 75% para rediseño amplio | Formularios, recursos y eventos recuperados | WinForms, Krypton/DevExpress autorizados o sustitutos | Media | Riesgo de romper layouts, impresión y flujos acoplados | Empezar por tema/login en rama experimental y comparar capturas |
| 9. Migrar interfaz a WPF o WinUI 3 | Sí, progresivamente | 70% WPF; 55% WinUI 3 para migración gradual | Lógica recuperable, pero UI y controles están acoplados a WinForms | Arquitectura por capas, adaptadores, pruebas UI | Muy alta | No hay conversión automática; reportes y controles requieren sustitución | Extraer servicios y migrar un módulo piloto; preferir WPF como primer salto |
| 10. Crear versión propia compatible con SQL Server | Sí | 85% para núcleo; 60-70% para paridad total | Esquema sano, 75 tablas, 95 vistas, 37 procedimientos y lógica recuperada | API/capa de datos nueva, pruebas de contrato y migraciones | Muy alta | Reglas implícitas, facturación, auditoría e integraciones deben reproducirse | Documentar contratos de datos y construir vertical piloto de solo lectura/escritura controlada |

## 5. Terceros y límites legales

Este apartado no es asesoría legal. Deben revisarse las facturas, EULA y derechos históricos de las versiones realmente adquiridas.

- DevExpress 22.2 es comercial. DevExpress indica que cada desarrollador necesita licencia y que solo pueden redistribuirse archivos expresamente designados; su código fuente no debe publicarse. Consulte la [página oficial de EULA](https://www.devexpress.com/Support/EULAs/) y el acuerdo aplicable a la versión adquirida.
- Syncfusion es comercial salvo que se cumplan y documenten las condiciones de otra licencia. Sus términos distinguen desarrollo, compilación y redistribución. Las claves no deben publicarse en GitHub. Consulte el [centro legal de Syncfusion](https://www.syncfusion.com/legal/eula/) y su [guía para GitHub](https://help.syncfusion.com/common/essential-studio/licensing/licensing-faq/requirement-to-use-syncfusion-with-github).
- `itextsharp.dll` corresponde a una familia con licenciamiento AGPL/comercial. Una distribución cerrada requiere revisar la licencia aplicable: [explicación oficial de iText](https://kb.itextpdf.com/itext/what-is-the-difference-between-agpl-and-commercial).
- ReportViewer, WebView2, PDFium, Krypton, ClosedXML, Newtonsoft.Json y los demás componentes requieren un inventario de versiones y avisos. No debe asumirse que estar junto al ejecutable concede derechos de desarrollo o redistribución.
- La investigación evitó descompilar o publicar bibliotecas de terceros. El código reconstruido y los binarios permanecen fuera de Git.

## 6. Cambios y acciones efectuadas

- Restauración segura del respaldo en una base nueva; la base preexistente no fue sobrescrita.
- `RESTORE VERIFYONLY` y `DBCC CHECKDB` sin errores.
- Configuración local de conexión en copias, con respaldo de originales fuera de Git.
- Prueba controlada del ejecutable; se detuvo antes de SQL por huella distinta.
- Exportaciones aisladas con ILSpy y dnSpyEx.
- Compilaciones experimentales en carpetas temporales; no sustituyeron binarios productivos.
- Consultas SQL de esquema y conteo únicamente; no se insertó `ZAREK`.
- Preparación de verificadores y de este paquete publicable sin secretos.

## 7. Conclusión

La recuperación técnica es viable y ya se probó más allá de una simple inspección: hay proyectos reconstruidos que compilan. La barrera actual de ejecución sigue siendo la autorización de hardware incorporada, seguida por el registro de estación y la vigencia comercial. La base SQL por sí sola no puede resolver la primera barrera.

La ruta sensata es: regularizar la autorización con el proveedor/titular, conservar una reconstrucción privada para contingencia y comenzar una modernización gradual con la opción B. Si el objetivo es independencia a largo plazo, la opción C debe construirse sobre contratos de datos documentados, no sobre una copia pública del código descompilado.

## 8. Actualización de ejecución en laboratorio

La sección anterior conserva la fotografía de la investigación estática inicial. Posteriormente, con autorización del titular y sin modificar la instalación ni la base originales, se ejecutó un vector local de compatibilidad en un laboratorio separado.

El resultado actual reemplaza la conclusión histórica de que el programa seguía detenido antes de SQL: la variante privada alcanzó la interfaz principal, reconoció la estación `ZAREK` y abrió el mantenimiento de artículos con datos de `SiGesComV1_Laboratorio`. La base original continuó sin una estación `ZAREK`.

Los detalles verificables y los límites de publicación están en [RECUPERACION-EJECUTADA.md](RECUPERACION-EJECUTADA.md). La implementación del cambio CIL, los binarios y la configuración no forman parte de este repositorio público.

