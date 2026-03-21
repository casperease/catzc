# Catzc.Internal.Loader — the always-loaded entry point for .internal shared code.
#
# The .internal folder holds code that BOTH the bootstrap (which runs before any Catzc module exists) and the
# Catzc modules (which run after) must call — the single home for what would otherwise be duplicated across the
# two layers (see docs/adr/principles/one-living-version.md). This loader is the one thing the importer loads
# unconditionally; it stays in the session (it is NOT removed with Bootstrap), so a post-import Catzc cover
# function can ensure a shared module is present before delegating to it.

$script:internalRoot = $PSScriptRoot

function Import-InternalModule {
    <#
    .SYNOPSIS
        Loads a .internal shared module once into the global session (idempotent).
    .DESCRIPTION
        Trusts the importer has already cleared PSModulePath and set the error preferences, so it just imports
        the module by path into the global scope. Idempotent: a no-op when the module is already loaded, so a
        cover function on the hot path pays nothing. The importer passes -Force on its own initial load so a
        devbox re-import (the cache-ADR invalidation boundary) picks up edits — the same "re-run the importer to
        invalidate" contract the C# type cache follows.
    .PARAMETER Name
        The bare area name of the shared module — 'Types' resolves to .internal/Catzc.Internal.Types.psm1.
    .PARAMETER Force
        Reload even when the module is already loaded (the importer's initial load uses this).
    .EXAMPLE
        Import-InternalModule Types
        Ensures Catzc.Internal.Types is loaded, then the caller can use Get-CombinedTypeHash.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [switch] $Force
    )

    $moduleName = "Catzc.Internal.$Name"
    if (-not $Force -and (Get-Module $moduleName)) {
        return
    }
    Import-Module (Join-Path $script:internalRoot "$moduleName.psm1") -Scope Global -Force
}

Export-ModuleMember -Function Import-InternalModule
