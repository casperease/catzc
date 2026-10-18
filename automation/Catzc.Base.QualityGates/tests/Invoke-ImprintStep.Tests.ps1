<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/tests/Invoke-ImprintStep.Tests.ps1
    folder: tests
    name: invoke-imprint-step-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/tests/Invoke-ImprintStep.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
      - ADR-REPO-FORMAT#8
---
#>

Describe 'Invoke-ImprintStep' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#8' {
    BeforeAll {
        $script:root = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'step-adapter-repo'))
        $script:carriers = [Catzc.Base.Languages.FileCarriersConfig]::new(@{ carriers = [ordered]@{ markdown = @{ carrier = 'front-matter' }; powershell = @{ carrier = 'comment-head'; block = @('<#', '#>') } } })
        $script:languages = [Catzc.Base.Languages.LanguagesConfig]::new(@{ languages = [ordered]@{ markdown = @{ extensions = @('.md'); formatter = 'prettier' } } })
        $script:meta = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ head_policy = @{ default = 'required' }; kinds = [ordered]@{ 'file-path' = @{ keys = @('path') } } })
        $script:widget = Join-Path $script:root 'docs/widget.md'
        $script:gadget = Join-Path $script:root 'docs/gadget.md'
    }

    BeforeEach {
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'docs') -Force
        [System.IO.File]::WriteAllText($script:widget, "# Widget`n")
        [System.IO.File]::WriteAllText($script:gadget, "---`ncatzc:`n  immutable:`n    colour: red`n---`n# Gadget`n")
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'file-carriers' } { $script:carriers }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'languages' } { $script:languages }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'file-meta' } { $script:meta }
    }

    Context 'the file-meta step' {
        It 'writes the meta block of a file that lacks it, and returns the absolute path it changed' {
            $outcome = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; File = $script:widget } {
                param($Root, $File)
                Invoke-ImprintStep -Step file-meta -File $File -RepositoryRoot $Root
            }
            $outcome.Changed | Should -Be @($script:widget)
            $outcome.Unfixable.Count | Should -Be 0
            [System.IO.File]::ReadAllText($script:widget) | Should -BeLike "---`ncatzc:`n  immutable:`n    path: docs/widget.md`n---*# Widget*"
        }

        It 'changes nothing under -DryRun, and still names the file it would change' {
            $outcome = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; File = $script:widget } {
                param($Root, $File)
                Invoke-ImprintStep -Step file-meta -File $File -RepositoryRoot $Root -DryRun
            }
            $outcome.Changed | Should -Be @($script:widget)
            [System.IO.File]::ReadAllText($script:widget) | Should -BeExactly "# Widget`n"
        }

        It 'returns a key no kind owns as a file a person must repair, and leaves that file alone' {
            $before = [System.IO.File]::ReadAllText($script:gadget)
            $outcome = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; File = $script:gadget } {
                param($Root, $File)
                Invoke-ImprintStep -Step file-meta -File $File -RepositoryRoot $Root
            }
            $outcome.Changed.Count | Should -Be 0
            $outcome.Unfixable[$script:gadget] | Should -BeLike '*a meta key no kind owns (catzc.immutable.colour)*'
            [System.IO.File]::ReadAllText($script:gadget) | Should -BeExactly $before
        }
    }

    Context 'the csharp-namespace step' {
        It 'hands the files to Format-Types, and returns its block-scoped files as ones a person must repair' {
            $typeFile = Join-Path $script:root 'automation/Widget/types/Gadget.cs'
            $block = Join-Path $script:root 'automation/Widget/types/Gizmo.cs'
            Mock Format-Types -ModuleName Catzc.Base.QualityGates {
                [pscustomobject]@{ ChangedCount = 1; ChangedFiles = @($script:typeFile); BlockScopedFiles = @($script:block); DryRun = $true }
            }
            $script:typeFile = $typeFile
            $script:block = $block
            $outcome = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; Files = @($typeFile, $block) } {
                param($Root, $Files)
                Invoke-ImprintStep -Step csharp-namespace -File $Files -RepositoryRoot $Root -DryRun
            }
            Should -Invoke Format-Types -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $DryRun -and $PassThru -and ($Path -join '|') -eq "$typeFile|$block" }
            $outcome.Changed | Should -Be @($typeFile)
            $outcome.Unfixable[$block] | Should -BeLike 'block-scoped namespace*'
        }
    }

    Context 'the ps-help step' {
        BeforeEach {
            $script:helpFile = Join-Path $script:root 'automation/Widget/Get-Gadget.ps1'
            $null = New-Item -ItemType Directory -Path (Split-Path $script:helpFile) -Force
            $function = @('function Get-Gadget {', '    [OutputType([string])]', '    param(', '        [string] $Widget', '    )', '}')
            $script:helpText = ($function -join "`n") + "`n"
            [System.IO.File]::WriteAllText($script:helpFile, $script:helpText)
            $script:helpPage = Join-Path $script:root ((Get-Config -Config comments).PageFor('automation/Widget/Get-Gadget.ps1'))
            $null = New-Item -ItemType Directory -Path (Split-Path $script:helpPage) -Force
            $script:pageText = "# automation/Widget/Get-Gadget.ps1`n`n## help`n`n### synopsis`n`nGets a gadget.`n`n### parameter Widget`n`nThe widget.`n`n### outputs`n`n``[string]`` The gadget.`n"
            [System.IO.File]::WriteAllText($script:helpPage, $script:pageText)
        }

        It 'finds nothing in help that is in order, and writes no file' {
            $outcome = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; File = $script:helpFile } {
                param($Root, $File)
                Invoke-ImprintStep -Step ps-help -File $File -RepositoryRoot $Root
            }
            $outcome.Changed.Count | Should -Be 0
            $outcome.Unfixable.Count | Should -Be 0
            [System.IO.File]::ReadAllText($script:helpFile) | Should -BeExactly $script:helpText
        }

        It 'returns a finding only a person can settle as a file to repair, and still writes no file' -Tag 'ADR-REPO-HELP#4' {
            $broken = $script:pageText.Replace("### parameter Widget`n`nThe widget.`n`n", '')
            [System.IO.File]::WriteAllText($script:helpPage, $broken)
            $outcome = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; File = $script:helpFile } {
                param($Root, $File)
                Invoke-ImprintStep -Step ps-help -File $File -RepositoryRoot $Root
            }
            $outcome.Changed.Count | Should -Be 0
            $outcome.Unfixable[$script:helpFile] | Should -BeLike '*the parameter Widget is declared but has no ### parameter subsection*'
            [System.IO.File]::ReadAllText($script:helpPage) | Should -BeExactly $broken
        }

        It 'reports a function file that has no comment page' -Tag 'ADR-REPO-HELP#4' {
            Remove-Item -LiteralPath $script:helpPage
            $outcome = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; File = $script:helpFile } {
                param($Root, $File)
                Invoke-ImprintStep -Step ps-help -File $File -RepositoryRoot $Root
            }
            $outcome.Unfixable[$script:helpFile] | Should -BeLike '*the file has no comment page*'
        }

        It 'reports a comment-based help block as a file to repair' {
            [System.IO.File]::WriteAllText($script:helpFile, ($script:helpText.Replace('function Get-Gadget', "<#`n.SYNOPSIS`n    Old.`n#>`n" + 'function Get-Gadget')))
            $outcome = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; File = $script:helpFile } {
                param($Root, $File)
                Invoke-ImprintStep -Step ps-help -File $File -RepositoryRoot $Root
            }
            $outcome.Unfixable[$script:helpFile] | Should -BeLike '*comment-based help is not used*'
        }
    }

    Context 'the comments step' {
        It 'hands the files to Export-Comments as absolute paths, and returns what it moved as absolute paths' {
            $gadget = Join-Path $script:root 'automation/Widget/Get-Gadget.ps1'
            $script:gadgetFile = $gadget
            Mock Export-Comments -ModuleName Catzc.Base.QualityGates { [string[]] @('automation/Widget/Get-Gadget.ps1') }
            $outcome = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; File = $gadget } {
                param($Root, $File)
                Invoke-ImprintStep -Step comments -File $File -RepositoryRoot $Root -DryRun
            }
            Should -Invoke Export-Comments -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
                $DryRun -and ($Path -join '|') -eq $script:gadgetFile
            }
            $outcome.Changed | Should -Be @($gadget)
            $outcome.Unfixable.Count | Should -Be 0
        }
    }

    Context 'every step' {
        It 'returns an empty outcome for no files, without running anything, for every step the registry may list: <_>' -ForEach @([Catzc.Base.Languages.LanguagesConfig]::ImprintSteps) {
            Mock Format-Types -ModuleName Catzc.Base.QualityGates { }
            $outcome = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; Step = $_ } {
                param($Root, $Step)
                Invoke-ImprintStep -Step $Step -File @() -RepositoryRoot $Root
            }
            $outcome.Changed.Count | Should -Be 0
            $outcome.Unfixable.Count | Should -Be 0
            Should -Invoke Format-Types -ModuleName Catzc.Base.QualityGates -Times 0
        }

        It 'throws for a step it has no adapter for' {
            { InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } { param($Root) Invoke-ImprintStep -Step shine -File @() -RepositoryRoot $Root } } |
                Should -Throw "*no adapter for the imprint step 'shine'*"
        }
    }
}
