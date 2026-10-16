<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Invoke-ImprintStep.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Invoke-ImprintStep.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Invoke-ImprintStep.Tests.ps1
    adrs:
      - ADR-PRIN-CONFIG#2
      - ADR-REPO-FORMAT#8
  config:
    synopsis: Runs one imprint step over the given files and returns what it changed and what it cannot repair.
    description: 'A language is never named here: which language runs which step is configuration, not code.'
    parameters:
      Step: The step name, as languages.yml spells it.
      File: Absolute paths of the files to imprint.
      RepositoryRoot: The repository root.
      DryRun: List the files the step would change without writing them.
    outputs: |-
      [pscustomobject] @{ Changed; Unfixable } — absolute paths changed (or, under -DryRun, that would change), and a map of absolute path
      to the problem for the files a person must repair.
---
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
    $outcome = [pscustomobject]@{ Changed = [string[]] @(); Unfixable = [System.Collections.Generic.Dictionary[string, string]]::new() }
    $absolute = { param([string] $Relative) [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $Relative)) }

    switch -CaseSensitive ($Step) {
        'file-meta' {
            if ($File.Count -eq 0) {
                return $outcome
            }
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
            if ($File.Count -eq 0) {
                return $outcome
            }
            $types = Format-Types -Path $File -DryRun:$DryRun -PassThru
            $outcome.Changed = [string[]] @($types.ChangedFiles)
            foreach ($blockScoped in @($types.BlockScopedFiles)) {
                $outcome.Unfixable[$blockScoped] = "block-scoped namespace — rewrite it as the file-scoped 'namespace <Module>;'"
            }
        }
        'ps-help' {
            if ($File.Count -eq 0) {
                return $outcome
            }
            # The help is data in the head, so the step only reports what a person must settle and changes no file.
            $form = (Get-Config -Config file-carriers).Find('powershell').Form()
            foreach ($path in $File) {
                $findings = @(Get-HelpHeadFinding -Text ([System.IO.File]::ReadAllText($path)) -Form $form)
                if ($findings.Count -gt 0) {
                    $outcome.Unfixable[$path] = "function help needs a hand edit: $($findings -join '; ')"
                }
            }
        }
        'comments' {
            if ($File.Count -eq 0) {
                return $outcome
            }
            # The step writes a file and its comment page, so the page is a companion of the file, not a second subject of the step.
            $relative = [string[]] @($File | ForEach-Object { [System.IO.Path]::GetRelativePath($root, $_) -replace '\\', '/' })
            $moved = @(Export-Comments -Path $relative -RepositoryRoot $root -DryRun:$DryRun)
            $outcome.Changed = [string[]] @($moved | ForEach-Object { & $absolute $_ })
        }
        default {
            throw "Invoke-ImprintStep: no adapter for the imprint step '$Step' (declared: $([Catzc.Base.Languages.LanguagesConfig]::ImprintSteps -join ', '))."
        }
    }
    $outcome
}
