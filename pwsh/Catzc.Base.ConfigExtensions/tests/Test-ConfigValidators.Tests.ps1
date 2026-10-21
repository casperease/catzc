<#
---
catzc:
  immutable:
    with_body_sha: a5cf839c5f2a
  edges:
    docs: "[Test-ConfigValidators.Tests.ps1.md](docs/references/pwsh/catzc-base-configextensions/tests/Test-ConfigValidators.Tests.ps1.md)"
    code: pwsh/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
---
#>

Describe 'Test-ConfigValidators' -Tag 'L0', 'logic' {
    BeforeAll {
        $root = Join-Path $TestDrive 'widget-modules'
        foreach ($path in 'TstWidget/configs/widget-parts.yml', 'TstGadget/configs/gadget.yml', '.internal/x.txt') {
            $full = Join-Path $root $path
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
            [System.IO.File]::WriteAllText($full, '')
        }
        New-Module -Name TstWidget -ScriptBlock {
            function Assert-WidgetPartsConfig {
            }
            Export-ModuleMember
        } | Import-Module
        New-Module -Name TstGadget -ScriptBlock {
            function Assert-GadgetConfig {
            }
            function Assert-SprocketConfig {
            }
            Export-ModuleMember
        } | Import-Module
        $script:out = Join-Path $TestDrive 'out'
    }

    AfterAll {
        Remove-Module TstWidget, TstGadget -ErrorAction Ignore
    }

    BeforeEach {
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.ConfigExtensions { Join-Path $TestDrive 'widget-modules' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'throws once naming the validator with no matching config' {
        $thrown = { Test-ConfigValidators -OutputFolder $out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-ConfigValidators failed: 1 issue(s)*'
        $thrown.Exception.Message | Should -Match 'Assert-SprocketConfig in TstGadget has no matching configs/\*\.yml'
    }

    It 'returns the result and counts every validator under -PassThru' {
        $result = Test-ConfigValidators -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'config-validators'
        $result.Facts['Validators'] | Should -Be 3
        $result.Issues | Should -HaveCount 1
    }

    It 'passes when every validator maps to a kebab-case config of its module' {
        [System.IO.File]::WriteAllText((Join-Path $TestDrive 'widget-modules/TstGadget/configs/sprocket.yml'), '')
        try {
            { Test-ConfigValidators -OutputFolder $out } | Should -Not -Throw
        }
        finally {
            Remove-Item (Join-Path $TestDrive 'widget-modules/TstGadget/configs/sprocket.yml')
        }
    }
}

Describe 'Config validator coverage' -Tag 'L0', 'integrity' {
    It 'every Assert-*Config validator maps to a configs/*.yml in its module (no orphans)' {
        $result = Test-ConfigValidators -PassThru -OutputFolder (Join-Path $TestDrive 'config-validators')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
