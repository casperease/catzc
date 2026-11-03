function Get-RepositoryRoot {
    param()

    if ([string]::IsNullOrEmpty($env:RepositoryRoot)) {
        throw 'The repository root is not set: $env:RepositoryRoot is empty. importer.ps1 sets it; dot-source the importer first.'
    }

    $env:RepositoryRoot
}
