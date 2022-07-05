$ROOT_FOLDER = Resolve-Path $PSScriptRoot\..

$functions = (Get-ChildItem $ROOT_FOLDER\script\*.ps1
| Select-Object -ExpandProperty BaseName
| % {
    "$(" " * 4)`"$_`""
}) -join ",`n"

$manifestFile = Get-Item $ROOT_FOLDER\*.psd1
$manifest = Get-Content $manifestFile -Raw -Encoding utf8

$exportText = @"
# StartGenerated
FunctionsToExport = @(
$functions
)

# EndGenerated
"@

[Regex]::Replace($manifest,
    "# StartGenerated.*# EndGenerated",
    "$exportText",
    [System.Text.RegularExpressions.RegexOptions]::Singleline)
| Set-Content -Path $manifestFile -Encoding utf8 -NoNewline
