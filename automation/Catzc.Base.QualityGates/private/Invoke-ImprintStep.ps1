<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Invoke-ImprintStep.ps1
    folder: private
    name: invoke-imprint-step
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
    page: docs/references/automation/catzc-base-qualitygates/private/Invoke-ImprintStep.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Invoke-ImprintStep.Tests.ps1
    cites:
      - ADR-PRIN-CONFIG#2
      - ADR-REPO-FORMAT#8
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
            # The help is the ## help section of the file's comment page, so the step only reports what a person must settle and changes no file.
            $comments = Get-Config -Config comments
            foreach ($path in $File) {
                $page = $comments.PageFor(([System.IO.Path]::GetRelativePath($root, $path) -replace '\\', '/'))
                $pageText = if ($page -and [System.IO.File]::Exists((& $absolute $page))) {
                    [System.IO.File]::ReadAllText((& $absolute $page))
                }
                else {
                    $null
                }
                $findings = @(Get-HelpPageFinding -Text ([System.IO.File]::ReadAllText($path)) -PageText $pageText)
                if ($findings.Count -gt 0) {
                    $outcome.Unfixable[$path] = "function help needs a hand edit: $($findings -join '; ')"
                }
            }
        }
        'comments' {
            if ($File.Count -eq 0) {
                return $outcome
            }
            $moved = @(Export-Comments -Path $File -RepositoryRoot $root -DryRun:$DryRun)
            $outcome.Changed = [string[]] @($moved | ForEach-Object { & $absolute $_ })
        }
        default {
            throw "Invoke-ImprintStep: no adapter for the imprint step '$Step' (declared: $([Catzc.Base.Languages.LanguagesConfig]::ImprintSteps -join ', '))."
        }
    }
    $outcome
}
