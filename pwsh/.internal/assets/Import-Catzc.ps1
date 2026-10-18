[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Invoke-Importer announces RepositoryRoot and CatzcModulesRoot on its Roots line, the first point a writer is loaded')]
param(
    [string] $RepositoryRoot,

    [switch] $AllowWarnings
)

Set-StrictMode -Version Latest

# The working root: the caller's choice, else what the session already has, else where the caller stands.
if ($RepositoryRoot) {
    $env:RepositoryRoot = [System.IO.Path]::GetFullPath($RepositoryRoot)
}
elseif (-not $env:RepositoryRoot) {
    $env:RepositoryRoot = (Get-Location).ProviderPath
}

# The code root: this build. Invoke-Importer -Bundle honours it instead of deriving <RepositoryRoot>/automation.
$env:CatzcModulesRoot = $PSScriptRoot

# Load the .internal shared-code loader of this build, then the importer overlay, and delegate. The importer
# overlay is import-time orchestration — remove it once the load returns.
Import-Module (Join-Path $PSScriptRoot '.internal/Catzc.Internal.Loader.psm1') -Scope Global -Force
Import-InternalModule Importer -Force
try {
    Invoke-Importer -Bundle -AllowWarnings:$AllowWarnings
}
finally {
    Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
}
