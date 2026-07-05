Describe 'Sync-SessionTools' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:origPath = $env:PATH
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Tooling.Core
        Mock Sync-SessionPath { } -ModuleName Catzc.Tooling.Core
        Mock Write-Message { } -ModuleName Catzc.Tooling.Core
        Mock Get-Config { [ordered]@{ alpha = @{}; beta = @{} } } -ParameterFilter { $Config -eq 'tools' } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolConfig { [pscustomobject]@{ command = $Tool; session_path_hints = @() } } -ModuleName Catzc.Tooling.Core
        Mock Resolve-SessionToolHint { $null } -ModuleName Catzc.Tooling.Core
        # Scope the Get-Command mock to our synthetic tool names so Pester's own Get-Command calls fall through.
        Mock Get-Command { [pscustomobject]@{ Source = "C:\managed\$Name.exe" } } -ParameterFilter { $Name -in 'alpha', 'beta' } -ModuleName Catzc.Tooling.Core
    }
    AfterEach {
        $env:PATH = $script:origPath
    }

    It 'is a no-op in CI (no PATH sync, no report)' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Tooling.Core
        Sync-SessionTools
        Should -Invoke Sync-SessionPath -ModuleName Catzc.Tooling.Core -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 0
    }

    It 'stays silent when every present tool is installer-managed' {
        Mock Test-ToolLocationManaged { $true } -ModuleName Catzc.Tooling.Core
        Sync-SessionTools
        Should -Invoke Sync-SessionPath -ModuleName Catzc.Tooling.Core -Times 1
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 0
    }

    It 'names the foreign tools on the always-on information stream' {
        Mock Test-ToolLocationManaged { $false } -ModuleName Catzc.Tooling.Core
        Sync-SessionTools
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter {
            $Message -like 'Session tools not managed by the installer layer:*' -and
            $Message -like '*alpha*' -and $Message -like '*beta*' -and
            -not $Verbose   # the names line is a plain info-stream message, never verbose-routed
        }
    }

    It 'routes each tool location to the verbose stream, hidden on a plain run' {
        Mock Test-ToolLocationManaged { $false } -ModuleName Catzc.Tooling.Core
        Sync-SessionTools
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter {
            $Message -like 'Locations:*' -and
            $Message -like '*alpha*' -and $Message -like '*beta*' -and
            -not $Verbose   # forwarded -Verbose:$false keeps the paths off a plain import
        }
    }

    It 'surfaces the tool locations when -Verbose is passed' {
        Mock Test-ToolLocationManaged { $false } -ModuleName Catzc.Tooling.Core
        Sync-SessionTools -Verbose
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter {
            $Message -like 'Locations:*' -and $Verbose
        }
    }

    It 'skips genuinely missing tools without reporting' {
        Mock Get-Command { $null } -ParameterFilter { $Name -in 'alpha', 'beta' } -ModuleName Catzc.Tooling.Core
        Mock Test-ToolLocationManaged { $false } -ModuleName Catzc.Tooling.Core
        Sync-SessionTools
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 0
    }

    It 'recovers an unresolvable tool via its session hint, then reports it as foreign' {
        Mock Get-Command { $null } -ParameterFilter { $Name -in 'alpha', 'beta' } -ModuleName Catzc.Tooling.Core
        Mock Resolve-SessionToolHint { [pscustomobject]@{ Source = 'C:\nvm\hinted.exe' } } -ModuleName Catzc.Tooling.Core
        Mock Test-ToolLocationManaged { $false } -ModuleName Catzc.Tooling.Core
        Sync-SessionTools
        Should -Invoke Resolve-SessionToolHint -ModuleName Catzc.Tooling.Core -Times 2
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter {
            $Message -like 'Session tools not managed by the installer layer:*'
        }
    }

    It 'suppresses the report under -Silent' {
        Mock Test-ToolLocationManaged { $false } -ModuleName Catzc.Tooling.Core
        Sync-SessionTools -Silent
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 0
    }
}
