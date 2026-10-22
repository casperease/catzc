<#
---
catzc:
  immutable:
    with_body_sha: "17e7aad76e2e"
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Get-ImprintStepFile.ps1
    cites:
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
      - ADR-REPO-PLANS-THREEPARTS
---
#>

Describe 'Get-ImprintStepFile' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT-CONFIGUREDFORMATTERS' {
    BeforeAll {
        $script:root = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'step-scope-repo'))
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'docs'), (Join-Path $script:root 'elsewhere') -Force
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widget.md'), "# Widget`n")
        $script:outside = Join-Path $TestDrive 'outside-the-repository.md'
        [System.IO.File]::WriteAllText($script:outside, "# Outside`n")
        $script:meta = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'file-path' = @{ keys = @('path') } } })
    }

    BeforeEach {
        Mock Get-CatzcModulesFolder -ModuleName Catzc.Base.QualityGates { 'widget-modules' }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'file-meta' } { $script:meta }
        Mock Get-FileMetaScope -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Path = 'docs/widget.md'; Carrier = $null }
            [pscustomobject]@{ Path = 'docs/gadget.md'; Carrier = $null }
        }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates {
            'widget-modules/Widget/types/Gadget.cs', 'widget-modules/Widget/types/nested/Gizmo.cs', 'widget-modules/Widget/Get-Gadget.ps1', 'tools/Cog/types/Sprocket.cs',
            'widget-modules/Widget/tests/types/Fixture.cs'
        }
    }

    It 'returns the absolute paths of the file-meta step''s own scope' {
        $found = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
            param($Root)
            Get-ImprintStepFile -Step file-meta -RepositoryRoot $Root
        }
        $found | Should -Be @((Join-Path $script:root 'docs/widget.md'), (Join-Path $script:root 'docs/gadget.md'))
    }

    It 'returns only the type sources under a module for the bcl-namespace step' {
        $found = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
            param($Root)
            Get-ImprintStepFile -Step bcl-namespace -RepositoryRoot $Root
        }
        $found | Should -Be @((Join-Path $script:root 'widget-modules/Widget/types/Gadget.cs'))
    }

    It 'returns only the function files of a module, public and private, for the ps-help step' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates {
            'widget-modules/Widget/Get-Gadget.ps1', 'widget-modules/Widget/private/Get-Cog.ps1', 'widget-modules/Widget/tests/Get-Gadget.Tests.ps1',
            'widget-modules/Widget/assets/scripts/install.ps1', 'widget-modules/Widget/types/Gadget.cs', 'tools/Cog/Get-Sprocket.ps1'
        }
        $found = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
            param($Root)
            Get-ImprintStepFile -Step ps-help -RepositoryRoot $Root
        }
        $found | Should -Be @((Join-Path $script:root 'widget-modules/Widget/Get-Gadget.ps1'), (Join-Path $script:root 'widget-modules/Widget/private/Get-Cog.ps1'))
    }

    It 'returns the absolute paths of the files the comment scope covers for the comments step' {
        Mock Get-CommentScope -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ File = 'widget-modules/Widget/Get-Gadget.ps1'; Extension = '.ps1'; Language = 'powershell'; Page = 'docs/references/pwsh/widget/Get-Gadget.ps1.md' }
        }
        $found = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
            param($Root)
            Get-ImprintStepFile -Step comments -RepositoryRoot $Root
        }
        $found | Should -Be @((Join-Path $script:root 'widget-modules/Widget/Get-Gadget.ps1'))
    }

    Context 'the plan-counts step' {
        BeforeEach {
            $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'plans') -Force
            [System.IO.File]::WriteAllText((Join-Path $script:root 'plans/plan-master.md'), "# Master`n")
            [System.IO.File]::WriteAllText((Join-Path $script:root 'plans/plan-widget.md'), "# Widget`n")
            Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'plans' } { [Catzc.Base.QualityGates.PlansConfig]::new(@{ folder = 'plans' }) }
            $script:scope = {
                param([string[]] $Path)
                InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; Path = $Path } {
                    param($Root, $Path)
                    Get-ImprintStepFile -Step plan-counts -RepositoryRoot $Root -Path $Path
                }
            }
        }

        It 'returns the overlays of the plans folder that exist, with no -Path or one inside the folder' -Tag 'ADR-REPO-PLANS-THREEPARTS' {
            & $script:scope | Should -Be @((Join-Path $script:root 'plans/plan-master.md'))
            & $script:scope @((Join-Path $script:root 'plans/plan-widget.md')) | Should -Be @((Join-Path $script:root 'plans/plan-master.md'))
            & $script:scope @($script:root) | Should -Be @((Join-Path $script:root 'plans/plan-master.md'))
        }

        It 'returns nothing for a -Path outside the plans folder' -Tag 'ADR-REPO-PLANS-THREEPARTS' {
            $found = & $script:scope @((Join-Path $script:root 'docs/widget.md'))
            @($found).Count | Should -Be 0
        }
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
