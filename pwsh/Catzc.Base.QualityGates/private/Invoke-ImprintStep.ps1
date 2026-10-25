<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Invoke-ImprintStep.ps1.md"
  warning: "Generated Header"
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
        'plan-counts' {
            if ($File.Count -eq 0) {
                return $outcome
            }
            # The counts are derived from the plans beside each overlay, so each folder the files sit in is rewritten once.
            $plans = Get-Config -Config plans
            $folders = @($File | ForEach-Object { [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetFullPath($_)) } | Sort-Object -Unique)
            $outcome.Changed = [string[]] @(foreach ($folder in $folders) {
                    Update-PlanStepCount $folder -Config $plans -DryRun:$DryRun
                })
            # A rewritten overlay can lie outside -Path, past the formatter's pass, so the step formats what it wrote itself.
            if (-not $DryRun -and $outcome.Changed.Count -gt 0) {
                $null = Invoke-FormatterEngine -Engine prettier -File $outcome.Changed
            }
        }
        default {
            throw "Invoke-ImprintStep: no adapter for the imprint step '$Step' (declared: $([Catzc.Base.Languages.LanguagesConfig]::ImprintSteps -join ', '))."
        }
    }
    $outcome
}
