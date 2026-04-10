# cspell:ignore machinebin userbin
Describe 'Sync-SessionPath' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:originalPath = $env:PATH

        # The persistent PATH is read through the Get-EnvironmentPath seam — mock it so these tests are
        # deterministic and never read the real machine registry. Each test sets $script:regUser/$regMachine.
        $script:regUser = ''
        $script:regMachine = ''
        Mock Get-EnvironmentPath -ModuleName Catzc.Base.Environment -ParameterFilter { $Scope -eq 'User' } -MockWith { $script:regUser }
        Mock Get-EnvironmentPath -ModuleName Catzc.Base.Environment -ParameterFilter { $Scope -eq 'Machine' } -MockWith { $script:regMachine }
    }

    AfterEach {
        $env:PATH = $originalPath
    }

    if ($IsWindows) {
        It 'merges User and Machine registry entries into the session PATH' {
            $script:regUser = 'C:\reg\userbin'
            $script:regMachine = 'C:\reg\machinebin'
            $env:PATH = ''

            Sync-SessionPath

            $env:PATH | Should -Match ([regex]::Escape('C:\reg\userbin'))
            $env:PATH | Should -Match ([regex]::Escape('C:\reg\machinebin'))
        }

        It 'preserves session-only entries that exist on disk' {
            $sessionOnly = [System.IO.Path]::GetTempPath().TrimEnd('\')
            $env:PATH = $sessionOnly

            Sync-SessionPath

            $env:PATH | Should -Match ([regex]::Escape($sessionOnly))
        }

        It 'drops session-only entries that no longer exist on disk' {
            $gone = 'C:\catzc-test-nonexistent-path'
            $env:PATH = $gone

            Sync-SessionPath

            $env:PATH | Should -Not -Match ([regex]::Escape($gone))
        }

        It 'does not duplicate an entry present in both the session and the registry' {
            $script:regUser = 'C:\reg\userbin'
            $env:PATH = 'C:\reg\userbin'

            Sync-SessionPath

            @($env:PATH -split ';' | Where-Object { $_.TrimEnd('\', '/') -eq 'C:\reg\userbin' }).Count | Should -Be 1
        }
    }

    if (-not $IsWindows) {
        It 'is a no-op on Unix' {
            $before = $env:PATH
            Sync-SessionPath
            $env:PATH | Should -Be $before
        }
    }
}
