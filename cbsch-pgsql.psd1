@{
PowerShellHostVersion = '7.0.0'
RootModule = 'tools/loader.psm1'
ModuleVersion = '1.0.5'
GUID = '1dcadff2-5493-44a8-af48-e95dae9c0fa2'
Author = 'Christopher Berg Schwanstrøm'
CompanyName = 'cbsch.no'
Copyright = '(c) Christopher. All rights reserved.'
Description = 'Simple Powershell wrapper for Npgsql'

RequiredAssemblies = 'bin\Npgsql.dll'

# StartGenerated
FunctionsToExport = @(
    "Invoke-PgSql"
)

# EndGenerated

PrivateData = @{
    PSData = @{
        ProjectUri = 'https://github.com/cbsch/cbsch-pgsql'
    }
}
}

