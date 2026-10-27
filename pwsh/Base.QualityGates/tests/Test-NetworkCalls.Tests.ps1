Describe 'Test-NetworkCalls' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-QUALITYGATE' {
    BeforeEach {
        $script:repo = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:out = Join-Path $TestDrive 'network-calls'
        $script:tracked = @()
        function Set-WidgetFile {
            param([string] $Relative, [string] $Text)
            $path = Join-Path $script:repo $Relative
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path))
            [System.IO.File]::WriteAllText($path, $Text)
            $script:tracked += $Relative
        }
        function New-WidgetConfig {
            param([System.Collections.IDictionary] $Sites = [ordered]@{})
            [Catzc.Base.Execution.NetworkCallsConfig]::new([ordered]@{
                    patterns = [ordered]@{ 'widget-fetch' = '\bInvoke-WidgetFetch\b' }
                    sites    = $Sites
                })
        }
        function New-WidgetSite {
            param([string] $Trigger = 'on-request')
            [ordered]@{ class = 'package-install'; trigger = $Trigger; gated_by = 'an explicit widget command' }
        }
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { $script:tracked }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'passes when every call sits in a registered file that names its function' {
        Set-WidgetFile 'widgets/Get-Widget.ps1' "function Get-Widget {`n    Invoke-WidgetFetch -Name gadget`n}`n"
        $config = New-WidgetConfig ([ordered]@{ 'widgets/Get-Widget.ps1#Get-Widget' = (New-WidgetSite) })
        $result = Test-NetworkCalls -Config $config -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Subject | Should -Be 'network-calls'
        $result.Facts['Sites'] | Should -Be 1
        $result.Facts['Patterns'] | Should -Be 1
    }

    It 'reports a call in a file with no registered site, by file and line, and throws once' {
        Set-WidgetFile 'widgets/Get-Gadget.ps1' "function Get-Gadget {`n    Invoke-WidgetFetch -Name gadget`n}`n"
        $config = New-WidgetConfig
        $result = Test-NetworkCalls -Config $config -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -BeLike 'widgets/Get-Gadget.ps1:2: a widget-fetch call in a file with no registered site*'
        { Test-NetworkCalls -Config $config -OutputFolder $script:out } | Should -Throw '*Test-NetworkCalls failed: 1 issue(s)*'
    }

    It 'leaves a comment line, a skipped path and a binary file unread' {
        Set-WidgetFile 'widgets/Get-Gadget.ps1' "# Invoke-WidgetFetch is mocked here`n// Invoke-WidgetFetch`n"
        Set-WidgetFile 'widgets/tests/Get-Gadget.Tests.ps1' "Mock Invoke-WidgetFetch { }`n"
        Set-WidgetFile 'widgets/gadget.md' "Run Invoke-WidgetFetch by hand.`n"
        $binary = Join-Path $script:repo 'widgets/gadget.bin'
        [System.IO.File]::WriteAllBytes($binary, [byte[]] @(0, 73, 110, 118))
        $script:tracked += 'widgets/gadget.bin'
        $result = Test-NetworkCalls -Config (New-WidgetConfig) -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['Scanned'] | Should -Be 1
    }

    It 'reports a registered file that no longer matches a pattern' {
        Set-WidgetFile 'widgets/Get-Widget.ps1' "function Get-Widget {`n    'gadget'`n}`n"
        $config = New-WidgetConfig ([ordered]@{ 'widgets/Get-Widget.ps1#Get-Widget' = (New-WidgetSite) })
        $result = Test-NetworkCalls -Config $config -OutputFolder $script:out -PassThru
        $result.Issues | Should -Be @('widgets/Get-Widget.ps1#Get-Widget: the file matches no network pattern — remove the entry, or add the pattern its call needs')
    }

    It 'reports a registered file that no longer names its function or job' {
        Set-WidgetFile 'widgets/Get-Widget.ps1' "function Get-WidgetPart {`n    Invoke-WidgetFetch`n}`n"
        $config = New-WidgetConfig ([ordered]@{ 'widgets/Get-Widget.ps1#Get-Widget' = (New-WidgetSite) })
        $result = Test-NetworkCalls -Config $config -OutputFolder $script:out -PassThru
        $result.Issues | Should -Be @("widgets/Get-Widget.ps1#Get-Widget: the file no longer names 'Get-Widget' — correct the key's function or job")
    }

    It 'reports a registered file that is not tracked' {
        $config = New-WidgetConfig ([ordered]@{ 'widgets/Get-Gizmo.ps1#Get-Gizmo' = (New-WidgetSite) })
        $result = Test-NetworkCalls -Config $config -OutputFolder $script:out -PassThru
        $result.Issues | Should -Be @('widgets/Get-Gizmo.ps1#Get-Gizmo: the file is not tracked — remove the entry or correct its path')
    }

    It 'reports every default-path site as an open violation' {
        Set-WidgetFile 'widgets/Get-Widget.ps1' "function Get-Widget {`n    Invoke-WidgetFetch`n}`n"
        $config = New-WidgetConfig ([ordered]@{ 'widgets/Get-Widget.ps1#Get-Widget' = (New-WidgetSite -Trigger 'default-path') })
        $result = Test-NetworkCalls -Config $config -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -BeLike 'widgets/Get-Widget.ps1#Get-Widget: trigger default-path*'
    }
}

Describe 'Test-NetworkCalls (real tree)' -Tag 'L1', 'integrity', 'source-only' {
    It 'finds every network call registered and no default-path site' {
        $result = Test-NetworkCalls -PassThru -OutputFolder (Join-Path $TestDrive 'network-calls')
        $result.Issues | Should -BeNullOrEmpty -Because "every network call is one registry entry (ADR-AUTO-NET-REGISTRYGATE):`n$($result.Issues -join "`n")"
    }
}
