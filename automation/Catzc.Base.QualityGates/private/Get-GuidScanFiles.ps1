<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
---
#>

<#
.SYNOPSIS
    Returns the repo-relative tracked files the managed-GUID scan reads — the scan's file universe.
.DESCRIPTION
    The registry file is excluded: it defines the managed set, and scanning it would defeat the liveness check.
    [ADR-AUTO-TRACKED#1](/docs/adr/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked1),
    [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md#comment1)
#>
function Get-GuidScanFiles {
    [CmdletBinding()]
    param()

    # The exclusions are the source repository's layout, so the scan means something only over the source tree.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md#comment2)
    Assert-SourceTree

    $tracked = Get-GitTrackedPath '.'

    $binaryExtensions = @('.dll', '.exe', '.png', '.jpg', '.jpeg', '.gif', '.ico', '.gz', '.zip', '.pdf', '.woff', '.woff2', '.ttf')
    $registryFile = 'automation/Catzc.Base.QualityGates/configs/guids.yml'

    foreach ($file in $tracked) {
        if ($file.StartsWith('automation/.vendor/')) {
            continue
        }
        if ($file.StartsWith('automation/.compiled/')) {
            continue
        }
        if ($file -eq $registryFile) {
            continue
        }
        $extension = [System.IO.Path]::GetExtension($file).ToLowerInvariant()
        if ($extension -in $binaryExtensions) {
            continue
        }
        $file
    }
}
