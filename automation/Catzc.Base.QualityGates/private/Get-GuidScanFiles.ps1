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
  config:
    synopsis: Returns the repo-relative tracked files the managed-GUID scan reads — the scan's file universe.
    description: |-
      Tracked files (Get-GitTrackedPath,
      [ADR-AUTO-TRACKED#1](/docs/adr/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked1) — the same matching universe as the globsets,
      [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)), minus what the
      scan must not read: vendored third-party code (automation/.vendor/), the committed compiled assembly
      (automation/.compiled/), known binary extensions, and the registry file itself — configs/guids.yml is
      the definition of the managed set, not a reference to it, and excluding it is what keeps the liveness
      check honest. The one place this scan reads the tracked set; a logic test mocks this seam (returning absolute
      fixture paths, which Resolve-RepoPath passes through unchanged). Throws in build mode (Assert-SourceTree).
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
