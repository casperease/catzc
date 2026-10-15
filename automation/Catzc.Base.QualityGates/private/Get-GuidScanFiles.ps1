<#
.SYNOPSIS
    Returns the repo-relative tracked files the managed-GUID scan reads — the scan's file universe.
.DESCRIPTION
    Tracked files (Get-GitTrackedPath, — the same matching universe as the globsets, ), minus what the scan must not...
    [ADR-AUTO-TRACKED#1](/docs/adr/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked1),
    [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md#comment1)
#>
function Get-GuidScanFiles {
    [CmdletBinding()]
    param()

    # The universe and its exclusions (automation/.vendor, automation/.compiled, the registry) are the catzc source...
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
