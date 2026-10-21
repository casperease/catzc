<#
---
catzc:
  immutable:
    with_body_sha: "71a4136f217e"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-GuidScanFiles.Tests.ps1
    docs: "[Get-GuidScanFiles.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-GuidScanFiles.ps1.md)"
    cites:
      - ADR-AUTO-TRACKED-ONESEAM
      - FDR-CD-GLOBS-TRACKEDFILESONLY
---
#>

function Get-GuidScanFiles {
    [CmdletBinding()]
    param()

    Assert-SourceTree

    $tracked = Get-GitTrackedPath '.'

    $binaryExtensions = @('.dll', '.exe', '.png', '.jpg', '.jpeg', '.gif', '.ico', '.gz', '.zip', '.pdf', '.woff', '.woff2', '.ttf')
    $registryFile = ConvertTo-RepoRelativePath (Get-CatzcModuleRoot 'configs/guids.yml')
    $modulesFolder = Get-CatzcModulesFolder

    foreach ($file in $tracked) {
        if ($file.StartsWith("$modulesFolder/.vendor/")) {
            continue
        }
        if ($file.StartsWith("$modulesFolder/.compiled/")) {
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
