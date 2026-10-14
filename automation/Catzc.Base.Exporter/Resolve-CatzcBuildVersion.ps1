<#
.SYNOPSIS
    Resolves the version a Catzc build carries — the devbox placeholder, a calculated pipeline version, or an
    explicit MAJOR.MINOR.PATCH.
.DESCRIPTION
    The one place a build version is decided
    ([ADR-AUTO-BUNDLE#7](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle7)); every value comes from
    configs/exporter.yml
    (Get-Config -Config exporter):

      -Version auto, on a devbox    the fixed direct_install_version placeholder (6.6.666), announced by a yellow
                                    Write-Message notice — never Write-Warning, which terminates under the catzc
                                    session's preferences
                                    ([ADR-PWSH-ERROR#2](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error2)). A rebuild overwrites it in place.
      -Version auto, in a pipeline  <the bundle's MAJOR.MINOR (exporter.yml bundles.<name>.version)>.<first-parent
                                    commit count of HEAD>, so the same commit always gets the same version and
                                    versions rise along main. Each bundle has its own MAJOR.MINOR line. Needs the full
                                    history; a shallow clone throws instead of miscounting.
      -Version <x.y.z>              honoured as given once asserted numeric MAJOR.MINOR.PATCH (a valid module
                                    version); a pipeline build naming the placeholder throws — it never leaves a
                                    devbox.
.PARAMETER Version
    'auto' (default) or an explicit numeric MAJOR.MINOR.PATCH.
.PARAMETER Bundle
    The bundle whose version line a pipeline build follows (an exporter.yml bundles key). Defaults to
    default_bundle.
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
