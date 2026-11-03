[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '',
    Justification = 'The fixture gates declare the parameter a real quality gate takes; what they return does not depend on it')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
    Justification = 'The fixture gates are global functions, so they report their calls and read their scripted outcome through one global table')]
param()

Describe 'Test-QualityGates' -Tag 'L0', 'logic' {
    BeforeAll {
        function global:Test-WidgetGate {
            param([switch] $PassThru)
            $global:qualityGatesFixture.Calls.Add(@('Test-WidgetGate', $PassThru.IsPresent))
            $outcome = $global:qualityGatesFixture.Outcome['Test-WidgetGate']
            if ($outcome -is [string] -and $outcome.StartsWith('throw:')) {
                throw $outcome.Substring(6)
            }
            [pscustomobject]@{ Issues = @($outcome) }
        }
        function global:Test-GadgetGate {
            param([switch] $PassThru)
            $global:qualityGatesFixture.Calls.Add(@('Test-GadgetGate', $PassThru.IsPresent))
            $outcome = $global:qualityGatesFixture.Outcome['Test-GadgetGate']
            if ($outcome -is [string] -and $outcome.StartsWith('throw:')) {
                throw $outcome.Substring(6)
            }
            [pscustomobject]@{ Issues = @($outcome) }
        }
        function global:Test-GizmoGate {
            param([switch] $PassThru)
            $global:qualityGatesFixture.Calls.Add(@('Test-GizmoGate', $PassThru.IsPresent))
            $outcome = $global:qualityGatesFixture.Outcome['Test-GizmoGate']
            if ($outcome -is [string] -and $outcome.StartsWith('throw:')) {
                throw $outcome.Substring(6)
            }
            [pscustomobject]@{ Issues = @($outcome) }
        }
    }

    AfterAll {
        Remove-Item Function:\Test-WidgetGate, Function:\Test-GadgetGate, Function:\Test-GizmoGate -ErrorAction Ignore
        Remove-Variable qualityGatesFixture -Scope Global -ErrorAction Ignore
    }

    BeforeEach {
        $global:qualityGatesFixture = @{
            Calls   = [System.Collections.Generic.List[object]]::new()
            Outcome = @{ 'Test-WidgetGate' = @(); 'Test-GadgetGate' = @(); 'Test-GizmoGate' = @() }
        }
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-PresentLanguageName -ModuleName Catzc.Base.QualityGates { 'widget', 'gadget', 'sprocket' }
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ name = 'widget'; checks = @('Test-WidgetGate', 'Test-GadgetGate'); check_scopes = @{} }
            [pscustomobject]@{ name = 'gadget'; checks = @('Test-GadgetGate', 'Test-GizmoGate'); check_scopes = @{} }
            [pscustomobject]@{ name = 'sprocket'; checks = $null; check_scopes = @{} }
        }
        $script:reportFolder = Join-Path $TestDrive 'quality-gates'
    }

    It 'runs the union of the registry checks, each gate once with -PassThru, and asserts a tree with tracks' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES', 'ADR-AUTO-TEST-QUALITYGATE' {
        $result = Test-QualityGates -PassThru -OutputFolder $script:reportFolder
        $result.Facts['Gates'] | Should -Be 3
        @($global:qualityGatesFixture.Calls | ForEach-Object { $_[0] }) | Should -Be @('Test-WidgetGate', 'Test-GadgetGate', 'Test-GizmoGate')
        @($global:qualityGatesFixture.Calls | ForEach-Object { $_[1] }) | Should -Not -Contain $false
        Should -Invoke Assert-SourceTree -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
    }

    It 'writes one report and passes when no gate has an issue' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        { Test-QualityGates -OutputFolder $script:reportFolder } | Should -Not -Throw
        $result = Test-QualityGates -PassThru -OutputFolder $script:reportFolder
        $result.Subject | Should -Be 'quality-gates'
        $result.IssueCount | Should -Be 0
        $result.ReportPath | Should -BeLike "$script:reportFolder*"
        [System.IO.Directory]::Exists($result.ReportPath) | Should -BeTrue
    }

    It 'throws once listing every issue, each named with its gate, and still runs the gates after a red one' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $global:qualityGatesFixture.Outcome['Test-WidgetGate'] = 'docs/widget.wdg: untidy'
        $global:qualityGatesFixture.Outcome['Test-GizmoGate'] = @('a.gdg: one', 'b.gdg: two')
        $thrown = { Test-QualityGates -OutputFolder $script:reportFolder } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-QualityGates failed: 3 issue(s)*'
        $result = Test-QualityGates -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @(
            'Test-WidgetGate: docs/widget.wdg: untidy'
            'Test-GizmoGate: a.gdg: one'
            'Test-GizmoGate: b.gdg: two'
        )
        @($global:qualityGatesFixture.Calls | Where-Object { $_[0] -eq 'Test-GadgetGate' }).Count | Should -Be 2
    }

    It 'reports a gate that throws, such as one whose tool is missing, as an issue and goes on' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $global:qualityGatesFixture.Outcome['Test-GadgetGate'] = 'throw:gadget tool missing — run Install-Gadget'
        $result = Test-QualityGates -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @('Test-GadgetGate: gadget tool missing — run Install-Gadget')
        @($global:qualityGatesFixture.Calls | Where-Object { $_[0] -eq 'Test-GizmoGate' }).Count | Should -Be 1
    }

    It 'reports a check the registry names but no command defines as an issue' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ name = 'widget'; checks = @('Test-WidgetGate', 'Test-NoSuchGate'); check_scopes = @{} }
        }
        $result = Test-QualityGates -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @('Test-NoSuchGate: no such command — languages.yml names it as a check')
    }

    It 'runs in a consumer root too: it asserts a tree with tracks, never the catzc source mode' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES' {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { throw 'no tracks declared' }
        { Test-QualityGates -OutputFolder $script:reportFolder } | Should -Throw '*no tracks declared*'
        $global:qualityGatesFixture.Calls.Count | Should -Be 0
    }
}
