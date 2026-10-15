<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
    kind: function
    module: Catzc.Base.Exporter
    visibility: public
    adrs:
      - ADR-AUTO-BUNDLE#7
      - ADR-PWSH-ERROR#2
---
#>

<#
.SYNOPSIS
    Resolves the version a Catzc build carries — the devbox placeholder, a calculated pipeline version, or an
    explicit MAJOR.MINOR.PATCH.
.DESCRIPTION
    A pipeline version derives from the commit count, so one commit always yields one version.
    [ADR-AUTO-BUNDLE#7](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle7),
    [ADR-PWSH-ERROR#2](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error2)
    [comment:1](/docs/references/automation/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md#comment1)
.PARAMETER Version
    'auto' (default) or an explicit numeric MAJOR.MINOR.PATCH.
.PARAMETER Bundle
    Only a pipeline build reads it; a devbox build takes the placeholder version whatever the bundle.
    [comment:2](/docs/references/automation/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md#comment2)
.PARAMETER Silent
    Suppress the local-build notice.
.EXAMPLE
    Resolve-CatzcBuildVersion                  # devbox -> 6.6.666 (with the notice); pipeline -> e.g. 0.1.427
.EXAMPLE
    Resolve-CatzcBuildVersion -Bundle azure    # pipeline -> azure's MAJOR.MINOR plus the commit count
.EXAMPLE
    Resolve-CatzcBuildVersion -Version 1.2.3   # -> 1.2.3
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
