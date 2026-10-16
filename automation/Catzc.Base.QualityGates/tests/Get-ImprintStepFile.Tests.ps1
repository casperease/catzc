<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-ImprintStepFile.Tests.ps1
    folder: tests
    name: get-imprint-step-file-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-FORMAT#8
---
#>

Describe 'Get-ImprintStepFile' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#8' {
    BeforeAll {
        $script:root = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'step-scope-repo'))
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'docs'), (Join-Path $script:root 'elsewhere') -Force
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widget.md'), "# Widget`n")
        $script:outside = Join-Path $TestDrive 'outside-the-repository.md'
        [System.IO.File]::WriteAllText($script:outside, "# Outside`n")
        $script:meta = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'file-path' = @{ keys = @('path') } } })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'file-meta' } { $script:meta }
        Mock Get-FileMetaScope -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Path = 'docs/widget.md'; Carrier = $null }
            [pscustomobject]@{ Path = 'docs/gadget.md'; Carrier = $null }
        }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates {
            'automation/Widget/types/Gadget.cs', 'automation/Widget/types/nested/Gizmo.cs', 'automation/Widget/Get-Gadget.ps1', 'tools/Cog/types/Sprocket.cs',
            'automation/Widget/tests/types/Fixture.cs'
        }
    }

    It 'returns the absolute paths of the file-meta step''s own scope' {
        $found = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
            param($Root)
            Get-ImprintStepFile -Step file-meta -RepositoryRoot $Root
        }
        $found | Should -Be @((Join-Path $script:root 'docs/widget.md'), (Join-Path $script:root 'docs/gadget.md'))
    }

    It 'returns only the type sources under a module for the csharp-namespace step' {
        $found = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
            param($Root)
            Get-ImprintStepFile -Step csharp-namespace -RepositoryRoot $Root
        }
        $found | Should -Be @((Join-Path $script:root 'automation/Widget/types/Gadget.cs'))
    }

    It 'returns only the function files of a module, public and private, for the ps-help step' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates {
            'automation/Widget/Get-Gadget.ps1', 'automation/Widget/private/Get-Cog.ps1', 'automation/Widget/tests/Get-Gadget.Tests.ps1',
            'automation/Widget/assets/scripts/install.ps1', 'automation/Widget/types/Gadget.cs', 'tools/Cog/Get-Sprocket.ps1'
        }
        $found = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
            param($Root)
            Get-ImprintStepFile -Step ps-help -RepositoryRoot $Root
        }
        $found | Should -Be @((Join-Path $script:root 'automation/Widget/Get-Gadget.ps1'), (Join-Path $script:root 'automation/Widget/private/Get-Cog.ps1'))
    }

    It 'returns the absolute paths of the files the comment scope covers for the comments step' {
        Mock Get-CommentScope -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ File = 'automation/Widget/Get-Gadget.ps1'; Extension = '.ps1'; Language = 'powershell'; Page = 'docs/references/automation/widget/Get-Gadget.ps1.md' }
        }
        $found = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
            param($Root)
            Get-ImprintStepFile -Step comments -RepositoryRoot $Root
        }
        $found | Should -Be @((Join-Path $script:root 'automation/Widget/Get-Gadget.ps1'))
    }

    It 'leaves a path outside the repository out instead of refusing it, and asks nothing when none is left' {
        $found = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; Outside = $script:outside } {
            param($Root, $Outside)
            Get-ImprintStepFile -Step file-meta -RepositoryRoot $Root -Path $Outside
        }
        @($found).Count | Should -Be 0
        Should -Invoke Get-FileMetaScope -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'narrows a step to the paths that lie inside the repository' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; Inside = (Join-Path $script:root 'docs'); Outside = $script:outside } {
            param($Root, $Inside, $Outside)
            Get-ImprintStepFile -Step file-meta -RepositoryRoot $Root -Path $Inside, $Outside
        } | Out-Null
        Should -Invoke Get-FileMetaScope -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            @($Path).Count -eq 1 -and ($Path | Select-Object -First 1) -eq (Join-Path $script:root 'docs')
        }
    }

    It 'throws for a step it has no adapter for' {
        { InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } { param($Root) Get-ImprintStepFile -Step shine -RepositoryRoot $Root } } |
            Should -Throw "*no adapter for the imprint step 'shine'*"
    }
}
