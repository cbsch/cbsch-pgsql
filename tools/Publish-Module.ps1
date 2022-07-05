$ROOT_FOLDER = Resolve-Path $PSScriptRoot\..
$manifestFile = Get-Item $ROOT_FOLDER\*.psd1
$manifest = Get-Content $manifestFile -Raw -Encoding utf8

if ($manifest -match "ModuleVersion = '(.*)'") {
    $version = [Version]::new($matches[1])
    $newVersion = "{0}.{1}.{2}" -f $version.Major,$version.Minor,(1 + [int]$version.Build)

    [Regex]::Replace($manifest, "ModuleVersion = '(.*)'", "ModuleVersion = '$newVersion'")
    | Set-Content -Path $manifestFile -Encoding utf8 -NoNewline

    git add $manifestFile
    git commit -m "Automatically bumped build number"
}

Publish-Module -Name $manifestFile `
    -NuGetApiKey (Get-StoredCredential PSPublishKey).GetNetworkCredential().Password
