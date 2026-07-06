# SEED importer.ps1 — the first-check-in form of the repository entry point (see rootconfig.yml, the
# importer.ps1 entry). All it does is perform one full import; the importer tail's Build-RootConfig then
# rewrites this very file from whatever the registry names as importer.ps1's source of truth — with the
# default `generator: New-Importer`, the seed replaces itself with the full generated shim on first load.
# No parameters: the seed exists to bootstrap a fresh tree once, not to be the daily entry point.
$env:RepositoryRoot = $PSScriptRoot

Import-Module (Join-Path $PSScriptRoot 'automation/.internal/Catzc.Internal.Loader.psm1') -Scope Global -Force
Import-InternalModule Importer -Force
try {
    Invoke-Importer
}
finally {
    Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
}
