# Manifiesto de publicación segura

## Incluido

- Conclusiones técnicas y evidencia resumida.
- Métricas de exportación y compilación.
- Referencias opacas de evidencia REA.
- Dos verificadores reproducibles que no cambian licencias ni credenciales.
- Hashes de integridad de los artefactos originales, sin copiar esos artefactos.
- Resultado sanitizado de la ejecución real en el laboratorio y hash de la variante local, sin publicar la variante.

## Excluido

- Ejecutables y DLL de SiGesCom o de terceros.
- Código C# reconstruido por descompilación.
- Respaldo, MDF, LDF o contenido fila por fila de la base.
- Archivos `.config` originales o modificados.
- Cadenas de conexión, nombres de usuario, contraseñas y claves.
- Huellas de CPU/discos, códigos de activación y URL privada del servicio de pago/activación.
- Logs de ejecución y carpetas de perfil WebView2.
- Copias de seguridad conservadas en `Diagnostico-SiGesCom/Originales`.
- Patcher, diferencias CIL, literales internos y scripts operativos del laboratorio.

La exclusión es intencional: la investigación puede compartirse sin publicar propiedad intelectual de la aplicación ni información operativa sensible.

