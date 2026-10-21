<#
---
catzc:
  immutable:
    with_body_sha: f8405000d336
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Invoke-ImprintStep.Tests.ps1
    docs: "[Invoke-ImprintStep.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Invoke-ImprintStep.ps1.md)"
    cites:
      - ADR-PRIN-CONFIG-NEWINSTANCEISCONFIGCHANGE
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
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
        'bcl-namespace' {
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
            $commentPages = Get-Config -Config comment-pages
            foreach ($path in $File) {
                # A path the index lists but the working tree has lost, a deletion not yet staged, has no help to check.
                if (-not [System.IO.File]::Exists($path)) {
                    continue
                }
                $page = Get-CommentPage -Path ([System.IO.Path]::GetRelativePath($root, $path) -replace '\\', '/') -Config $commentPages
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
