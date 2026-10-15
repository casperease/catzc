<#
.SYNOPSIS
    Runs one imprint step over the given files and returns what it changed and what it cannot repair
    ([ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)).
.DESCRIPTION
    A language is never named here: which language runs which step is configuration, not code.
    [ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)
.PARAMETER Step
    The step name, as languages.yml spells it.
.PARAMETER File
    Absolute paths of the files to imprint.
.PARAMETER RepositoryRoot
    The repository root.
.PARAMETER DryRun
    List the files the step would change without writing them.
.OUTPUTS
    [pscustomobject] @{ Changed; Unfixable } — absolute paths changed (or, under -DryRun, that would change), and a map of absolute path
    to the problem for the files a person must repair.
#>
function Invoke-ImprintStep {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Step,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [switch] $DryRun
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $outcome = [pscustomobject]@{ Changed = [string[]] @(); Unfixable = @{} }
    if ($File.Count -eq 0) {
        return $outcome
    }
    $absolute = { param([string] $Relative) [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $Relative)) }

    switch -CaseSensitive ($Step) {
        'file-meta' {
            $resolver = [Catzc.Base.QualityGates.FileCarrierResolver]::new((Get-Config -Config file-carriers), (Get-Config -Config languages))
            $entries = foreach ($path in $File) {
                $relative = [System.IO.Path]::GetRelativePath($root, $path) -replace '\\', '/'
                [pscustomobject]@{ Path = $relative; Carrier = $resolver.For($relative) }
            }
            $result = Invoke-FileMetaEngine -RepositoryRoot $root -Config (Get-Config -Config file-meta) -Entry @($entries)
            $saved = Save-FileMetaResult -Result $result -RepositoryRoot $root -DryRun:$DryRun
            $outcome.Changed = [string[]] @($saved.Fixed | ForEach-Object { & $absolute $_.Path })
            foreach ($finding in $saved.Unowned) {
                $outcome.Unfixable[(& $absolute $finding.Path)] = "a meta key no kind owns ($($finding.Actual)) — move it under config, or remove it, or declare a meta kind that owns it"
            }
        }
        'csharp-namespace' {
            $types = Format-Types -Path $File -DryRun:$DryRun -PassThru
            $outcome.Changed = [string[]] @($types.ChangedFiles)
            foreach ($blockScoped in @($types.BlockScopedFiles)) {
                $outcome.Unfixable[$blockScoped] = "block-scoped namespace — rewrite it as the file-scoped 'namespace <Module>;'"
            }
        }
        default {
            throw "Invoke-ImprintStep: no adapter for the imprint step '$Step' (declared: $([Catzc.Base.Languages.LanguagesConfig]::ImprintSteps -join ', '))."
        }
    }
    $outcome
}
