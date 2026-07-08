<#
.SYNOPSIS
    Exports catzc to a destination — build to out/, then put the bundle where it is consumed.
.DESCRIPTION
    The top-level export: it builds the bundle (Build-Catzc, into out/) and then delivers it. Two destinations:
      - disk (default): a two-part on-disk install to a destination root (Install-Catzc) — the module under
        <Root>/<ModulesSubfolder>/Catzc/<version>/ and a root importer.ps1. This is the near-term path: install
        directly from the mono repo to another folder on disk (another repo's .vendor, a work directory).
      - nuget: pack the out/ build (DLL included) into a package and publish to PSGallery / a GitHub feed. This
        is designed as a seam and disabled until the publish pipeline exists (see artifacts.yml); it reports and
        does nothing for now.

    Build defaults (profile, vendor policy, version) come from exporter.yml; pass them here to override.
.PARAMETER Root
    The destination working root for a disk export (where the root importer.ps1 goes).
.PARAMETER To
    disk (default) installs on disk to -Root; nuget is the (not-yet-enabled) package-and-publish path.
.PARAMETER ModulesSubfolder
    Where under Root the module goes on a disk export; default '.vendor'.
.PARAMETER ModuleProfile
    Override the built module set (a profiles.yml key).
.PARAMETER VendorPolicy
    Override the vendored-dependency policy (runtime | full).
.PARAMETER Version
    Override the bundle version.
.PARAMETER Force
    Re-copy the module on install even when the target is already current.
.PARAMETER Silent
    Suppress build/install summaries.
.EXAMPLE
    Export-Catzc -Root C:\work\project        # build + install into C:\work\project\.vendor, importer at the root
.EXAMPLE
    Export-Catzc -To nuget                     # (designed; disabled until the publish pipeline exists)
#>
function Export-Catzc {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Position = 0)]
        [string] $Root,

        [ValidateSet('disk', 'nuget')]
        [string] $To = 'disk',

        [string] $ModulesSubfolder = '.vendor',
        [string] $ModuleProfile,
        [ValidateSet('runtime', 'full')]
        [string] $VendorPolicy,
        [string] $Version,
        [switch] $Force,
        [switch] $Silent
    )

    if ($To -eq 'nuget') {
        Write-Message 'NuGet/PSGallery export is designed but not yet enabled — the publish targets in artifacts.yml are disabled. Build the artifact with Build-Catzc and wire the publish pipeline (Phase 2) to enable it.'
        return
    }

    Assert-NotNullOrWhitespace $Root

    $buildArgs = @{ Silent = $Silent }
    if ($ModuleProfile) {
        $buildArgs.ModuleProfile = $ModuleProfile
    }
    if ($VendorPolicy) {
        $buildArgs.VendorPolicy = $VendorPolicy
    }
    if ($Version) {
        $buildArgs.Version = $Version
    }
    $built = Build-Catzc @buildArgs

    Install-Catzc -Root $Root -Source $built.Path -Version $built.Version -ModulesSubfolder $ModulesSubfolder -Force:$Force -Silent:$Silent
}
