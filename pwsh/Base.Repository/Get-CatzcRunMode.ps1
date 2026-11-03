function Get-CatzcRunMode {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if (-not $env:CatzcModulesFolder) {
        throw 'Get-CatzcRunMode: $env:CatzcModulesFolder is not set; the importer (importer.ps1) publishes it on every import.'
    }
    $modulesRoot = [System.IO.Path]::GetFullPath((Get-CatzcModulesRoot)).TrimEnd('\', '/')
    $sourceRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) $env:CatzcModulesFolder)).TrimEnd('\', '/')

    if ($modulesRoot -ieq $sourceRoot) {
        return 'source'
    }
    'build'
}
