$ErrorActionPreference = 'Stop'

$appRoot = 'C:\SiGesCom'
$exePath = Join-Path $appRoot 'JOM.SiGesCom.Winforms.exe'
$configPath = "$exePath.config"
$databaseName = 'SiGesComV1_Libreria_Rossmary'
$expectedExeHash = '47487CA7835F2F6A91BDE4E32235F2CE9B838545D4DC94FD089113514AC849AC'

Write-Host '=== SiGesCom: verificacion local de solo lectura ==='

$exeExists = Test-Path -LiteralPath $exePath -PathType Leaf
$configExists = Test-Path -LiteralPath $configPath -PathType Leaf
$actualHash = if ($exeExists) { (Get-FileHash -Algorithm SHA256 -LiteralPath $exePath).Hash } else { $null }

[pscustomobject]@{
    Executable = $exeExists
    Configuration = $configExists
    ExecutableHashMatches = ($actualHash -eq $expectedExeHash)
    ExecutablePath = $exePath
} | Format-List

$service = Get-Service -Name 'MSSQL$SQLEXPRESS' -ErrorAction SilentlyContinue
[pscustomobject]@{
    SqlServiceFound = ($null -ne $service)
    SqlServiceStatus = if ($service) { $service.Status } else { 'Missing' }
} | Format-List

$sqlcmd = Get-Command sqlcmd -ErrorAction SilentlyContinue
if (-not $sqlcmd) {
    Write-Warning 'sqlcmd no esta disponible; se omite la verificacion de base.'
    exit 1
}

$machine = $env:COMPUTERNAME.Replace("'", "''")
$query = @"
SET NOCOUNT ON;
SELECT name,state_desc,compatibility_level FROM sys.databases WHERE name=N'$databaseName';
USE [$databaseName];
SELECT COUNT(*) AS TableCount FROM sys.tables;
SELECT COUNT(*) AS WorkstationMatches FROM dbo.EstacionTrabajo WHERE Nombre=N'$machine' AND EstadoRegistro='A';
"@

& $sqlcmd.Source -S '.\SQLEXPRESS' -E -C -W -s '|' -Q $query

Write-Host ''
Write-Host 'Este script no valida ni modifica la licencia de hardware.'

