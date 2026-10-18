<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
    folder: private
    name: get-guid-scan-files
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
    cites:
      - ADR-AUTO-TRACKED#1
      - ADR-FLOW-CD-GLOBS#4
---
#>

function Get-GuidScanFiles {
    [CmdletBinding()]
    param()

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
