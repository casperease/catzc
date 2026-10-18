<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
    name: resolve-catzc-build-version
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Exporter
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Exporter/tests/Resolve-CatzcBuildVersion.Tests.ps1
    cites:
      - ADR-AUTO-BUNDLE#7
      - ADR-PWSH-ERROR#2
---
#>

function Resolve-CatzcBuildVersion {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position = 0)]
        [string] $Version = 'auto',

        [string] $Bundle = "$((Get-Config -Config exporter).default_bundle)",

        [switch] $Silent
    )

    $config = Get-Config -Config exporter
    Assert-True ($config.bundles.ContainsKey($Bundle)) -ErrorText "Unknown bundle '$Bundle': exporter.yml declares $(@($config.bundles.Keys) -join ', ')."
    $placeholder = "$($config.direct_install_version)"
    $inPipeline = Test-IsRunningInPipeline

    if ($Version -ne 'auto') {
        Assert-True ($Version -match '^\d+\.\d+\.\d+$') -ErrorText "Invalid build version '$Version': pass 'auto' or a numeric MAJOR.MINOR.PATCH (e.g. 1.2.3)."
        if ($inPipeline -and $Version -eq $placeholder) {
            throw "Build version $placeholder is the devbox placeholder (exporter.yml direct_install_version) and is rejected in a pipeline. Pass -Version auto for the calculated version, or a real MAJOR.MINOR.PATCH."
        }
        return $Version
    }

    if (-not $inPipeline) {
        if (-not $Silent) {
            Write-Message -Warning "local build — version $placeholder; real versions are assigned only by the pipeline"
        }
        return $placeholder
    }

    $shallow = (Invoke-Executable 'git rev-parse --is-shallow-repository' -PassThru -Silent).Output.Trim()
    if ($shallow -eq 'true') {
        throw 'Cannot calculate the build version: the repository is a shallow clone, so the first-parent commit count of HEAD would be wrong. Fetch the full history (GitHub checkout fetch-depth: 0, Azure Pipelines fetchDepth: 0).'
    }
    $count = (Invoke-Executable 'git rev-list --first-parent --count HEAD' -PassThru -Silent).Output.Trim()
    Assert-True ($count -match '^\d+$') -ErrorText "Cannot calculate the build version: 'git rev-list --first-parent --count HEAD' returned '$count', not a commit count."

    "$($config.bundles[$Bundle].version).$count"
}
