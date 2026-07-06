<#
.SYNOPSIS
    Answers "which areas-of-control do these changes touch?" — one row per matched globset.
.DESCRIPTION
    The blast-radius query (the third marker role, ADR-GLOBS:1): maps changed files onto every globset
    whose effective membership matches at least one of them — the declared registry (tracks,
    deployable-units, scopes; compose-aware) AND the derived module sets (ADR-PROTGLOB), so the answer
    covers both "which pipelines/units this fires" (Pipeline) and "which tests verify it" (the derived
    module rows name the modules for Test-Automation -Modules; a declared row's VerifyModules/VerifyLevel
    carry its configured verify scope, consumable via Test-Automation -Marker).
.PARAMETER ChangedFile
    The changed files, repo-relative and '/'-separated (backslashes are normalized).
.PARAMETER Ref
    A git ref to diff the working tree against (`git diff --name-only <ref>`) instead of naming files —
    e.g. 'main' answers "what does my branch touch".
.OUTPUTS
    [pscustomobject] per matched set: Name, Layer, Pipeline, VerifyModules, VerifyLevel — declared sets
    first (registry order), then the derived module sets, each set at most once.
.EXAMPLE
    Get-MarkerBlastRadius -ChangedFile 'infrastructure/modules/vnet.bicep'
.EXAMPLE
    Get-MarkerBlastRadius -Ref main
#>
function Get-MarkerBlastRadius {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Files')]
        [string[]] $ChangedFile,

        [Parameter(Mandatory, ParameterSetName = 'Ref')]
        [string] $Ref
    )

    if ($PSCmdlet.ParameterSetName -eq 'Ref') {
        $diff = Invoke-Executable "git diff --name-only `"$Ref`"" -PassThru -Silent
        $ChangedFile = @($diff.Output -split "`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    }
    $files = @($ChangedFile | ForEach-Object { $_.Trim().Replace('\', '/') })
    if ($files.Count -eq 0) {
        return
    }

    # Declared sets first (registry order), then the derived module sets — the same one-answer-per-set
    # shape either way.
    foreach ($set in @(Get-GlobSet) + @(Get-ModuleGlobSet)) {
        foreach ($file in $files) {
            if ($set.Matches($file)) {
                [pscustomobject]@{
                    Name          = $set.Name
                    Layer         = $set.Layer
                    Pipeline      = $set.Pipeline
                    VerifyModules = @($set.VerifyModules)
                    VerifyLevel   = $set.VerifyLevel
                }
                break
            }
        }
    }
}
