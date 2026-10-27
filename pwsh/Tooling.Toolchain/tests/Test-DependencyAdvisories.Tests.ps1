Describe 'Test-DependencyAdvisories' -Tag 'L0', 'logic' {
    BeforeAll {
        # A lock with a planted vulnerable pin (urllib3 1.26.4); the scanner is mocked with the JSON osv-scanner writes for it.
        $script:lock = Join-Path (Get-CatzcModuleRoot -Module Catzc.Tooling.Toolchain) 'tests/assets/vulnerable-uv.lock'
        $script:advisory = [ordered]@{
            results = @(
                [ordered]@{
                    source   = [ordered]@{ path = $script:lock; type = 'lockfile' }
                    packages = @(
                        [ordered]@{
                            package         = [ordered]@{ name = 'urllib3'; version = '1.26.4'; ecosystem = 'PyPI' }
                            vulnerabilities = @([ordered]@{ id = 'GHSA-q2q7-5pp4-w6pg'; summary = 'Catastrophic backtracking in URL authority parser' })
                        }
                    )
                }
            )
        } | ConvertTo-Json -Depth 8
    }

    BeforeEach {
        Mock Resolve-ToolExecutable -ModuleName Catzc.Tooling.Toolchain {
            [pscustomobject]@{ Found = $true; VersionOk = $true; Path = $Tool; Version = '2.0.0'; Required = '2.0' }
        }
        Mock Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Command -like '*scan source*' } -MockWith {
            [pscustomobject]@{ ExitCode = 1; Output = $script:advisory; Full = $script:advisory }
        }
        Mock Write-Message { } -ModuleName Catzc.Base.Reports
    }

    It 'reports the planted vulnerable pin of the lock it scans, naming the package, version and advisory' {
        $result = Test-DependencyAdvisories -LockFile $script:lock -PassThru -OutputFolder (Join-Path $TestDrive 'advisories')
        $result.Issues | Should -Be @('urllib3 1.26.4 (PyPI): GHSA-q2q7-5pp4-w6pg Catastrophic backtracking in URL authority parser — raise the pin past the fixed version')
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Command -like "*scan source --lockfile `"$script:lock`" --format json"
        }
        { Test-DependencyAdvisories -LockFile $script:lock -OutputFolder (Join-Path $TestDrive 'advisories') } |
            Should -Throw '*Test-DependencyAdvisories failed: 1 issue(s)*'
    }

    It 'passes a lock the scanner finds nothing in' {
        Mock Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Command -like '*scan source*' } -MockWith {
            [pscustomobject]@{ ExitCode = 0; Output = '{"results":[]}'; Full = '' }
        }
        (Test-DependencyAdvisories -LockFile $script:lock -PassThru -OutputFolder (Join-Path $TestDrive 'advisories')).IssueCount | Should -Be 0
    }

    It 'throws on a scanner failure rather than reading it as a clean scan' {
        Mock Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Command -like '*scan source*' } -MockWith {
            [pscustomobject]@{ ExitCode = 127; Output = ''; Full = 'osv-scanner: database unreachable' }
        }
        { Test-DependencyAdvisories -LockFile $script:lock -OutputFolder (Join-Path $TestDrive 'advisories') } | Should -Throw '*osv-scanner failed (exit 127)*'
    }

    It 'asks for Install-OsvScanner when the scanner is missing or off its pin' {
        Mock Resolve-ToolExecutable -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Tool -eq 'osv_scanner' } -MockWith {
            [pscustomobject]@{ Found = $false; VersionOk = $false; Path = $null; Version = $null; Required = '2.0' }
        }
        { Test-DependencyAdvisories -LockFile $script:lock } | Should -Throw '*Run Install-OsvScanner*'
    }

    It 'produces the workspace uv.lock with the managed uv before it scans, when no lock is named' {
        $python = Join-Path $TestDrive 'python'
        [System.IO.Directory]::CreateDirectory($python) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $python 'pyproject.toml'), "[project]`nname = 'widget'`n")
        [System.IO.File]::WriteAllText((Join-Path $python 'uv.lock'), "version = 1`n")
        Mock Get-RepositoryRoot -ModuleName Catzc.Tooling.Toolchain { $TestDrive }
        Mock Get-Config -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Config -eq 'python' } -MockWith {
            [pscustomobject]@{} | Add-Member -MemberType ScriptMethod -Name ResolveRoot -Value { 'python' } -PassThru
        }
        Mock ConvertTo-RepoRelativePath -ModuleName Catzc.Tooling.Toolchain { 'python/uv.lock' }
        Mock Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Command -like '* lock --quiet' } -MockWith {
            [pscustomobject]@{ ExitCode = 0; Output = ''; Full = '' }
        }
        $null = Test-DependencyAdvisories -PassThru -OutputFolder (Join-Path $TestDrive 'advisories')
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Command -like '* lock --quiet' -and $WorkingDirectory -eq $python
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Command -like "*--lockfile `"$(Join-Path $python 'uv.lock')`"*"
        }
    }
}
