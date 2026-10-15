<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/tests/Resolve-SessionToolHost.Tests.ps1
    kind: pester-test
---
#>

Describe 'Resolve-SessionToolHost' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:origPath = $env:PATH
        $script:separator = [System.IO.Path]::PathSeparator
        $script:binaryName = if ($IsWindows) {
            'widget.exe'
        }
        else {
            'widget'
        }
        $script:root = Join-Path $TestDrive ([Guid]::NewGuid())

        # A fixture home: the widget binary (an empty file, never executed) plus the version folders asked for.
        function New-WidgetHome {
            param([string] $Name, [string[]] $Folders)
            $toolHome = Join-Path $script:root $Name
            [void][System.IO.Directory]::CreateDirectory($toolHome)
            [System.IO.File]::WriteAllText((Join-Path $toolHome $script:binaryName), '')
            foreach ($folder in $Folders) {
                [void][System.IO.Directory]::CreateDirectory((Join-Path $toolHome $folder))
            }
            $toolHome
        }
        $script:newWidgetHome = ${function:New-WidgetHome}

        $script:config = [pscustomobject]@{
            command             = 'widget'
            version             = '10.0'
            script_install      = $false
            session_host_probes = @('sdk/{version}', 'shared/Widget.Runtime/{version}')
        }

        # Resolve widget through the LIVE session PATH, so the test observes the real reordering.
        Mock Get-Command {
            foreach ($entry in ($env:PATH -split [System.IO.Path]::PathSeparator)) {
                if ($entry -and [System.IO.File]::Exists((Join-Path $entry $script:binaryName))) {
                    [pscustomobject]@{ Source = (Join-Path $entry $script:binaryName) }
                }
            }
        } -ParameterFilter { $Name -eq 'widget' } -ModuleName Catzc.Tooling.Core
        Mock Write-Message { } -ModuleName Catzc.Tooling.Core
    }
    AfterEach {
        $env:PATH = $script:origPath
    }

    It 'returns $null and leaves PATH untouched for a tool without probes' {
        $before = $env:PATH
        $config = [pscustomobject]@{ command = 'widget'; version = '10.0'; script_install = $false; session_host_probes = @() }
        InModuleScope Catzc.Tooling.Core -Parameters @{ Config = $config } {
            param($Config)
            Resolve-SessionToolHost -Config $Config
        } | Should -BeNullOrEmpty
        $env:PATH | Should -Be $before
    }

    It 'prefers a home with the SDK over an earlier, runtime-only home' {
        $runtimeOnly = & $script:newWidgetHome 'machine' @('shared/Widget.Runtime/10.0.5')
        $withSdk = & $script:newWidgetHome 'user' @('sdk/10.0.201')
        $env:PATH = @($runtimeOnly, $withSdk) -join $script:separator

        $found = InModuleScope Catzc.Tooling.Core -Parameters @{ Config = $script:config } {
            param($Config)
            Resolve-SessionToolHost -Config $Config
        }

        $found.Source | Should -Be (Join-Path $withSdk $script:binaryName)
        @($env:PATH -split $script:separator)[0] | Should -Be $withSdk
        $env:PATH -split $script:separator | Should -Contain $runtimeOnly -Because 'the other install stays on PATH — it is never removed'
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter { $Message -like '*widget now runs from*' }
    }

    It 'falls back to a runtime at the locked version when no home has the SDK' {
        $offVersion = & $script:newWidgetHome 'machine' @('shared/Widget.Runtime/6.0.36')
        $lockedRuntime = & $script:newWidgetHome 'user' @('shared/Widget.Runtime/10.0.5')
        $env:PATH = @($offVersion, $lockedRuntime) -join $script:separator

        InModuleScope Catzc.Tooling.Core -Parameters @{ Config = $script:config } {
            param($Config)
            Resolve-SessionToolHost -Config $Config
        } | Out-Null

        @($env:PATH -split $script:separator)[0] | Should -Be $lockedRuntime
    }

    It 'returns $null and leaves PATH untouched when no home satisfies any probe' {
        $offVersion = & $script:newWidgetHome 'machine' @('shared/Widget.Runtime/6.0.36')
        $env:PATH = $offVersion
        $before = $env:PATH

        InModuleScope Catzc.Tooling.Core -Parameters @{ Config = $script:config } {
            param($Config)
            Resolve-SessionToolHost -Config $Config
        } | Should -BeNullOrEmpty
        $env:PATH | Should -Be $before
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 0
    }

    It 'considers the managed home first, even when it is not on PATH' {
        $machine = & $script:newWidgetHome 'machine' @('sdk/10.0.100')
        $managed = & $script:newWidgetHome 'managed' @('sdk/10.0.201')
        $env:PATH = $machine
        Mock Get-ScriptInstallDir { $managed } -ModuleName Catzc.Tooling.Core
        $config = [pscustomobject]@{
            command             = 'widget'
            version             = '10.0'
            script_install      = $true
            session_host_probes = @('sdk/{version}')
        }

        InModuleScope Catzc.Tooling.Core -Parameters @{ Config = $config } {
            param($Config)
            Resolve-SessionToolHost -Config $Config
        } | Out-Null

        @($env:PATH -split $script:separator)[0] | Should -Be $managed
    }

    It 'does not rewrite PATH or announce when the chosen home is already first' {
        $withSdk = & $script:newWidgetHome 'user' @('sdk/10.0.201')
        $env:PATH = $withSdk
        $before = $env:PATH

        InModuleScope Catzc.Tooling.Core -Parameters @{ Config = $script:config } {
            param($Config)
            Resolve-SessionToolHost -Config $Config
        } | Out-Null

        $env:PATH | Should -Be $before
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 0
    }
}
