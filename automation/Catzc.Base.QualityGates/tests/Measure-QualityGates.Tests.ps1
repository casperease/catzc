[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The fixture gates declare the parameters a real quality gate takes; what they return does not depend on them')]
param()

Describe 'Measure-QualityGates' -Tag 'L1', 'logic' {
    BeforeAll {
        function global:Test-WidgetSlow {
            param([string] $OutputFolder, [switch] $PassThru)
            Start-Sleep -Milliseconds 300
            [pscustomobject]@{ Issues = @('widget/a.wdg: one', 'widget/b.wdg: two') }
        }
        function global:Test-GadgetFast {
            param([switch] $PassThru)
            [pscustomobject]@{ Issues = @() }
        }
        function global:Test-GizmoBroken {
            param([switch] $PassThru)
            throw 'gizmo tool missing'
        }
    }

    AfterAll {
        Remove-Item Function:\Test-WidgetSlow, Function:\Test-GadgetFast, Function:\Test-GizmoBroken -ErrorAction Ignore
    }

    It 'times each named gate once and returns its issue count, slowest first' {
        $rows = @(Measure-QualityGates Test-GadgetFast, Test-WidgetSlow)
        $rows.Name | Should -Be @('Test-WidgetSlow', 'Test-GadgetFast')
        $rows[0].IssueCount | Should -Be 2
        $rows[0].Seconds | Should -BeGreaterThan 0.2
        $rows[1].IssueCount | Should -Be 0
    }

    It 'records a gate that throws, and a name that is no command, as a row with its error' {
        $rows = @(Measure-QualityGates Test-GizmoBroken, Test-NoSuchGizmo)
        ($rows | Where-Object Name -EQ 'Test-GizmoBroken').Error | Should -Be 'gizmo tool missing'
        ($rows | Where-Object Name -EQ 'Test-NoSuchGizmo').Error | Should -Be 'no such command'
    }

    It 'times every gate languages.yml names in a check by default' {
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Languages.FileLanguage]::new('widget', @('.wdg'), $null, 'fixture', $null, $null, @('Test-GadgetFast', 'Test-WidgetSlow'))
            [Catzc.Base.Languages.FileLanguage]::new('gadget', @('.gdg'), $null, 'fixture', $null, $null, @('Test-GadgetFast'))
        }
        @(Measure-QualityGates).Name | Sort-Object | Should -Be @('Test-GadgetFast', 'Test-WidgetSlow')
    }
}
