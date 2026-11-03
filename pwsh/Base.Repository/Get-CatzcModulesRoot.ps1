function Get-CatzcModulesRoot {
    param()

    if ($env:CatzcModulesRoot) {
        return $env:CatzcModulesRoot
    }

    if (-not $env:CatzcModulesFolder) {
        throw 'Get-CatzcModulesRoot: $env:CatzcModulesFolder is not set; the importer (importer.ps1) publishes it on every import.'
    }
    Join-Path (Get-RepositoryRoot) $env:CatzcModulesFolder
}
