# Recuperación forense de fuente y solución editable

Fecha de corte: 15 de noviembre de 2026. Este documento publica únicamente resultados sanitizados; el código reconstruido y los artefactos propietarios permanecen privados.

## Resultado

Se consolidó una solución Visual Studio de 13 proyectos enlazados mediante referencias de proyecto. La solución completa y una segunda copia preparada para el futuro retiro de marca compilan en .NET Framework 4.8 con cero errores y 22 advertencias únicas atribuibles principalmente a patrones de descompilación.

La entrega privada contiene 807 archivos C#, 176,710 líneas C#, 152 recursos RESX y 48 reportes RDLC. La aplicación conserva 137 asociaciones completas de formulario, `Designer.cs` y RESX. Una prueba STA construyó correctamente los controles de dos formularios representativos sin mostrar la interfaz.

## Búsqueda de fuente original

No se localizó una solución, proyecto ni árbol C# original en las ubicaciones lógicas accesibles del disco vivo. La búsqueda abarcó perfiles de usuario, historial de IDE, repositorios locales, Papelera y 116 archivos comprimidos del árbol histórico de proyectos.

El RAR histórico de SiGesCom superó la prueba de integridad y contiene 408 entradas de despliegue, pero cero archivos `.sln`, `.csproj`, `.cs`, `.Designer.cs` o `.resx`. La copia eliminada hallada en la Papelera tiene el mismo tamaño y SHA-256, por lo que no representa otra versión.

La conclusión correcta es “no encontrado mediante búsqueda lógica accesible”, no “nunca existió”. No se talló espacio no asignado del disco vivo; una recuperación de archivos eliminados a ese nivel requiere una imagen forense o un volumen externo.

## Evidencia independiente

Se preservaron separadamente:

- binarios originales y archivo histórico;
- exportaciones prístinas de ILSpy para los 13 ensamblados;
- una exportación independiente de dnSpyEx de la aplicación;
- 13 volcados CIL completos, con aproximadamente 101.4 MB;
- un paquete de evidencia REA con 70 registros y cero registros desconocidos;
- inventarios exhaustivos de tipos, métodos, recursos y referencias.

Las evidencias canónicas están ligadas al SHA-256 y MVID de los binarios originales. La reconstrucción C# se etiqueta expresamente como reconstruida/reparada, no como fuente original ni como equivalencia binaria.

## Fidelidad estructural medida

| Métrica | Original | Recompilado | Resultado |
|---|---:|---:|---:|
| `InitializeComponent` | 172 | 172 | 100 % |
| Tipos Form/Control | 182 | 182 | 100 % |
| Suscripciones de eventos | 787 | 787 | 100 % |
| Recursos | 201 | 201 | 100 % |
| Referencias de ensamblado | 145 | 145 | 100 % |
| Eventos | 216 | 216 | 100 % |
| P/Invoke | 10 | 10 | 100 % |
| Propiedades | 4,975 | 4,974 | 99.98 % |

La única propiedad no reemitida es un indexador COM parametrizado de Excel que C# no puede representar con el mismo `DefaultMember`; su getter sí permanece. Los tipos auxiliares adicionales provienen del compilador moderno y de reparaciones documentadas.

## Identidad comercial

La auditoría no encontró `Rosameri`, `Rossmary` o `Rosmery` como literales en el código consolidado. La razón social y comercial antigua proviene de datos de empresa en SQL Server y los reportes la consumen dinámicamente. El logo fijo recuperado corresponde a la identidad técnica del producto, mientras que el campo de logo de la empresa auditada está vacío.

No se reemplazó automáticamente ningún dato: razones sociales, comprobantes y registros históricos pueden tener relevancia fiscal. Se preparó una copia de desarrollo separada, todavía sin cambios de nombre, a la espera de que el titular defina la nueva identidad.

## Límites de publicación

No se publican fuente descompilada, CIL, evidencia REA completa, binarios, DLL de terceros, configuraciones, bases, respaldos, credenciales, claves, datos comerciales, parche de compatibilidad ni material de activación. El repositorio documenta lo averiguado y ejecutado sin distribuir propiedad intelectual u operativa sensible.
