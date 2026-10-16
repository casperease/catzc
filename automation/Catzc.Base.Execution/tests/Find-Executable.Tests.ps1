<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1
    folder: tests
    name: find-executable-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Execution
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-execution/tests/Find-Executable.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#3
---
#>

Describe 'Find-Executable' -Tag 'L1', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'executables'
        foreach ($folder in 'user', 'machine', 'wsl') {
            $file = Join-Path $script:root "$folder/widget.exe"
            [System.IO.Directory]::CreateDirectory((Split-Path $file)) | Out-Null
            [System.IO.File]::WriteAllText($file, '')
        }
        $script:savedWidgetRoot = $env:CATZC_WIDGET_ROOT
        $env:CATZC_WIDGET_ROOT = $script:root

        function Get-FixturePath {
            param([string] $Folder)
            [System.IO.Path]::GetFullPath((Join-Path $script:root "$Folder/widget.exe"))
        }

        # The probe's plain inputs; -Keys overrides any of them.
        function Invoke-WidgetProbe {
            param([hashtable] $Keys = @{})
            $probe = @{
                Name             = 'widget'
                Candidate        = @('%CATZC_WIDGET_ROOT%/missing/widget.exe', '%CATZC_WIDGET_ROOT%/user/widget.exe', '%CATZC_WIDGET_ROOT%/machine/widget.exe')
                Exclude          = @('%CATZC_WIDGET_ROOT%/wsl/widget.exe')
                VersionArguments = '--version'
                VersionPattern   = 'version (?<ver>[\d.]+)'
                RequiredVersion  = '5'
            }
            foreach ($key in $Keys.Keys) {
                $probe[$key] = $Keys[$key]
            }
            Find-Executable @probe
        }
    }
    AfterAll {
        $env:CATZC_WIDGET_ROOT = $script:savedWidgetRoot
    }
    BeforeEach {
        InModuleScope Catzc.Base.Execution { $script:executableVersionCache = $null }
        Mock Get-SessionActor { 'Person' } -ModuleName Catzc.Base.Execution
        Mock Get-ExecutableVersion { '5.2.37' } -ModuleName Catzc.Base.Execution
        Mock Get-Command { } -ModuleName Catzc.Base.Execution -ParameterFilter { $CommandType -eq 'Application' }
    }

    Context 'locating' {
        It 'takes the first existing candidate' {
            $probe = Invoke-WidgetProbe
            $probe.Name | Should -Be 'widget'
            $probe.Path | Should -Be (Get-FixturePath 'user')
            $probe.Method | Should -Be 'probe'
        }

        It 'searches PATH by -Command only when no candidate exists' {
            Mock Get-Command { [pscustomobject]@{ Source = (Get-FixturePath 'machine') } } -ModuleName Catzc.Base.Execution -ParameterFilter { $CommandType -eq 'Application' -and $Name -eq 'gadget' }
            $probe = Invoke-WidgetProbe @{ Candidate = @('%CATZC_WIDGET_ROOT%/missing/widget.exe'); Command = 'gadget' }
            $probe.Name | Should -Be 'widget'
            $probe.Path | Should -Be (Get-FixturePath 'machine')
            $probe.Method | Should -Be 'path'
        }

        It 'searches PATH by -Name when no -Command is given' {
            Mock Get-Command { [pscustomobject]@{ Source = (Get-FixturePath 'machine') } } -ModuleName Catzc.Base.Execution -ParameterFilter { $CommandType -eq 'Application' -and $Name -eq 'widget' }
            (Invoke-WidgetProbe @{ Candidate = @() }).Method | Should -Be 'path'
        }

        It 'does not search PATH when a candidate exists' {
            Invoke-WidgetProbe | Out-Null
            Should -Invoke Get-Command -ModuleName Catzc.Base.Execution -Times 0 -Exactly -ParameterFilter { $CommandType -eq 'Application' }
        }

        It 'reports none, and starts no process, when nothing is found' {
            $probe = Invoke-WidgetProbe @{ Candidate = @() }
            $probe.Found | Should -BeFalse
            $probe.Method | Should -Be 'none'
            $probe.VersionOk | Should -BeFalse
            Should -Invoke Get-ExecutableVersion -ModuleName Catzc.Base.Execution -Times 0 -Exactly
        }

        It 'carries the session actor' {
            Mock Get-SessionActor { 'Agent' } -ModuleName Catzc.Base.Execution
            (Invoke-WidgetProbe).Actor | Should -Be 'Agent'
        }
    }

    Context 'excluded executables (the WSL launcher)' {
        It 'skips an excluded candidate even when it exists' {
            $probe = Invoke-WidgetProbe @{ Candidate = @('%CATZC_WIDGET_ROOT%/wsl/widget.exe', '%CATZC_WIDGET_ROOT%/machine/widget.exe') }
            $probe.Path | Should -Be (Get-FixturePath 'machine')
        }

        It 'skips an excluded executable on PATH and takes the next one' {
            Mock Get-Command {
                [pscustomobject]@{ Source = (Get-FixturePath 'wsl') }
                [pscustomobject]@{ Source = (Get-FixturePath 'user') }
            } -ModuleName Catzc.Base.Execution -ParameterFilter { $CommandType -eq 'Application' }
            $probe = Invoke-WidgetProbe @{ Candidate = @() }
            $probe.Path | Should -Be (Get-FixturePath 'user')
            $probe.Method | Should -Be 'path'
        }

        It 'reports none when the only executable on PATH is excluded' {
            Mock Get-Command { [pscustomobject]@{ Source = (Get-FixturePath 'wsl') } } -ModuleName Catzc.Base.Execution -ParameterFilter { $CommandType -eq 'Application' }
            (Invoke-WidgetProbe @{ Candidate = @() }).Found | Should -BeFalse
        }
    }

    Context 'the version check' {
        It 'runs the located file with the version arguments and pattern' {
            Invoke-WidgetProbe | Out-Null
            Should -Invoke Get-ExecutableVersion -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
                $Path -eq (Get-FixturePath 'user') -and $Arguments -eq '--version' -and $Pattern -eq 'version (?<ver>[\d.]+)'
            }
        }

        It 'starts the version once for the located file, then answers from the session cache' {
            $first = Invoke-WidgetProbe
            $second = Invoke-WidgetProbe
            Should -Invoke Get-ExecutableVersion -ModuleName Catzc.Base.Execution -Times 1 -Exactly
            $second.Version | Should -Be $first.Version
            $second.VersionMs | Should -Be 0
        }

        It 'starts the version again when the located file changes (a reinstall)' {
            Invoke-WidgetProbe | Out-Null
            [System.IO.File]::SetLastWriteTimeUtc((Get-FixturePath 'user'), [datetime]::UtcNow.AddMinutes(1))
            Invoke-WidgetProbe | Out-Null
            Should -Invoke Get-ExecutableVersion -ModuleName Catzc.Base.Execution -Times 2 -Exactly
        }

        It 'reads <installed> against the required 5 as VersionOk <ok>' -ForEach @(
            @{ installed = '5.2.37'; ok = $true }
            @{ installed = '4.4.23'; ok = $false }
            @{ installed = '3.2.57'; ok = $false }
        ) {
            Mock Get-ExecutableVersion { $installed } -ModuleName Catzc.Base.Execution
            $probe = Invoke-WidgetProbe
            $probe.Version | Should -Be $installed
            $probe.Required | Should -Be '5'
            $probe.VersionOk | Should -Be $ok
        }

        It 'accepts a version matching one of -AcceptVersion' {
            Mock Get-ExecutableVersion { '4.4.23' } -ModuleName Catzc.Base.Execution
            (Invoke-WidgetProbe @{ AcceptVersion = @('4.4') }).VersionOk | Should -BeTrue
            (Invoke-WidgetProbe @{ AcceptVersion = @('3') }).VersionOk | Should -BeFalse
        }

        It 'accepts any parsed version when no version is required' {
            (Invoke-WidgetProbe @{ RequiredVersion = '' }).VersionOk | Should -BeTrue
        }

        It 'reads an unparseable version as not VersionOk' {
            Mock Get-ExecutableVersion { $null } -ModuleName Catzc.Base.Execution
            $probe = Invoke-WidgetProbe @{ RequiredVersion = '' }
            $probe.Found | Should -BeTrue
            $probe.VersionOk | Should -BeFalse
        }
    }

    It 'carries both timings' {
        $probe = Invoke-WidgetProbe
        $probe.ProbeMs | Should -BeOfType [long]
        $probe.VersionMs | Should -BeOfType [long]
        $probe.ProbeMs | Should -BeGreaterOrEqual 0
        $probe.VersionMs | Should -BeGreaterOrEqual 0
    }
}
