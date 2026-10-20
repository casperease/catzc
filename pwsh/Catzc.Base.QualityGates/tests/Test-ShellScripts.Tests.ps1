<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1
    folder: tests
    name: test-shell-scripts-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Test-ShellScripts.Tests.ps1.md](docs/references/pwsh/catzc-base-qualitygates/tests/Test-ShellScripts.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-AUTO-TEST-TAGBYOUTERMOSTRING
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

Describe 'Test-ShellScripts' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'repo'
        function Set-FixtureFile {
            param([string] $Relative, [string] $Text)
            $path = Join-Path $script:repo $Relative
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path))
            [System.IO.File]::WriteAllText($path, $Text)
        }
        Set-FixtureFile 'widget/run.sh' "#!/usr/bin/env bash`necho widget`n"
        Set-FixtureFile 'widget-modules/Catzc.Widget/assets/scripts/dotnet-install.sh' "#!/usr/bin/env bash`r`necho vendored`r`n"
        Set-FixtureFile 'importer.sh' "cats() { :; }`n"
    }

    BeforeEach {
        $script:checkOutput = ''
        $script:checkExit = 0
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-CatzcModulesFolder -ModuleName Catzc.Base.QualityGates { 'widget-modules' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { 'widget/run.sh'; 'widget-modules/Catzc.Widget/assets/scripts/dotnet-install.sh'; 'docs/widget.md' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $ExecutableOnly } { 'widget/run.sh'; 'widget-modules/Catzc.Widget/assets/scripts/dotnet-install.sh' }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'shellcheck' } {
            [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'C:\widget\shellcheck.exe'; Version = '0.11.0'; Required = '0.11' }
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Execution.CliResult]::new($script:checkOutput, '', $script:checkExit)
        }
        # A fixture Bash root, so the vendored runner's folder is the fixture's, never the shipped config's.
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'bash' } {
            [Catzc.Base.Languages.BashConfig]::new([ordered]@{ root = 'gadget-bash'; bats_version = '1.14.0'; bats_sha256 = ('a' * 64) })
        }
        $script:reportFolder = Join-Path $TestDrive 'shell-scripts'
    }

    It 'checks only the line endings of the vendored bats-core runner, its scripts without an extension included' {
        Set-FixtureFile 'gadget-bash/.vendor/bats-core/libexec/bats-core/bats' "#!/usr/bin/env bash`r`necho runner`r`n"
        Set-FixtureFile 'gadget-bash/.vendor/bats-core/lib/bats-core/common.bash' "#!/usr/bin/env bash`necho sourced`n"
        $runner = 'gadget-bash/.vendor/bats-core/libexec/bats-core/bats', 'gadget-bash/.vendor/bats-core/lib/bats-core/common.bash'
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { @('widget/run.sh') + $runner }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $ExecutableOnly } { 'widget/run.sh' }

        $result = Test-ShellScripts -PassThru -OutputFolder $script:reportFolder

        $result.Issues | Should -Be @('gadget-bash/.vendor/bats-core/libexec/bats-core/bats: CRLF line endings — the shell reads the carriage return as part of the command; the file must be LF (.gitattributes eol=lf)')
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -eq '"C:\widget\shellcheck.exe" --format=gcc --external-sources "importer.sh" "widget/run.sh"'
        }
    }

    It 'checks the tracked scripts and importer.sh, analysing all but the vendored ones' {
        $result = Test-ShellScripts -PassThru -OutputFolder $script:reportFolder
        $result.Facts['Scripts'] | Should -Be 3
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -eq '"C:\widget\shellcheck.exe" --format=gcc --external-sources "importer.sh" "widget/run.sh"'
        }
    }

    It 'reports CRLF line endings in any script, vendored ones included' {
        $result = Test-ShellScripts -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @('widget-modules/Catzc.Widget/assets/scripts/dotnet-install.sh: CRLF line endings — the shell reads the carriage return as part of the command; the file must be LF (.gitattributes eol=lf)')
    }

    It 'reports a tracked script with a shebang that is not executable in git, but not a sourced one' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $ExecutableOnly } { 'widget-modules/Catzc.Widget/assets/scripts/dotnet-install.sh' }
        $result = Test-ShellScripts -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Contain 'widget/run.sh: has a shebang but is not executable in git (mode 100644) — run: git update-index --chmod=+x widget/run.sh'
        @($result.Issues | Where-Object { $_ -like 'importer.sh:*executable*' }) | Should -HaveCount 0
    }

    It 'reports each ShellCheck finding as one issue' {
        $script:checkOutput = 'widget/run.sh:2:6: warning: Double quote to prevent globbing and word splitting. [SC2086]'
        $script:checkExit = 1
        $result = Test-ShellScripts -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Contain 'widget/run.sh:2:6: warning: Double quote to prevent globbing and word splitting. [SC2086]'
    }

    It 'throws when ShellCheck itself fails' {
        $script:checkOutput = 'shellcheck: unknown option'
        $script:checkExit = 3
        { Test-ShellScripts -PassThru -OutputFolder $script:reportFolder } | Should -Throw '*ShellCheck could not check the shell scripts (exit 3)*'
    }

    It 'throws with "Run Install-Shellcheck" when ShellCheck at the pin is missing' {
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'shellcheck' } {
            [pscustomobject]@{ Found = $false; VersionOk = $false; Path = $null; Version = $null; Required = '0.11' }
        }
        { Test-ShellScripts -PassThru -OutputFolder $script:reportFolder } | Should -Throw '*Run Install-Shellcheck*'
    }

    It 'never asks for zsh when there is no *.zsh file' {
        Test-ShellScripts -PassThru -OutputFolder $script:reportFolder | Out-Null
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -Times 0 -ParameterFilter { $Tool -eq 'zsh' }
    }

    Context 'a *.zsh file' {
        BeforeAll {
            Set-FixtureFile 'gadget/run.zsh' "#!/usr/bin/env zsh`necho gadget`n"
            Set-FixtureFile 'gadget/crlf.zsh' "echo gadget`r`n"
        }

        BeforeEach {
            $script:zshOutput = ''
            $script:zshExit = 0
            Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { 'widget/run.sh'; 'gadget/run.zsh'; 'gadget/crlf.zsh' }
            Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $ExecutableOnly } { 'widget/run.sh' }
            Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'zsh' } {
                [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'C:\widget\zsh.exe'; Version = '5.9'; Required = '5' }
            }
            Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Command -like '"C:\widget\zsh.exe"*' } {
                [Catzc.Base.Execution.CliResult]::new('', $script:zshOutput, $script:zshExit)
            }
        }

        It 'takes the LF and executable-bit checks' {
            $result = Test-ShellScripts -PassThru -OutputFolder $script:reportFolder
            $result.Facts['Scripts'] | Should -Be 4
            $result.Issues | Should -Contain 'gadget/crlf.zsh: CRLF line endings — the shell reads the carriage return as part of the command; the file must be LF (.gitattributes eol=lf)'
            $result.Issues | Should -Contain 'gadget/run.zsh: has a shebang but is not executable in git (mode 100644) — run: git update-index --chmod=+x gadget/run.zsh'
        }

        It 'takes zsh -n, one call per file, in place of ShellCheck' {
            Test-ShellScripts -PassThru -OutputFolder $script:reportFolder | Out-Null
            Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
                $Command -eq '"C:\widget\zsh.exe" -f -n "gadget/run.zsh"'
            }
            Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
                $Command -eq '"C:\widget\zsh.exe" -f -n "gadget/crlf.zsh"'
            }
            Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
                $Command -eq '"C:\widget\shellcheck.exe" --format=gcc --external-sources "importer.sh" "widget/run.sh"'
            }
        }

        It 'reports each line zsh -n prints as one issue, naming the file' {
            $script:zshOutput = @("gadget/run.zsh:2: parse error near ``}'", 'widget trailing detail') -join "`n"
            $script:zshExit = 1
            $result = Test-ShellScripts -PassThru -OutputFolder $script:reportFolder
            $result.Issues | Should -Contain "gadget/run.zsh:2: parse error near ``}'"
            $result.Issues | Should -Contain 'gadget/run.zsh: widget trailing detail'
        }

        It 'throws when zsh itself fails' {
            $script:zshOutput = 'zsh: no such file'
            $script:zshExit = 127
            { Test-ShellScripts -PassThru -OutputFolder $script:reportFolder } | Should -Throw "*zsh could not check 'gadget/crlf.zsh' (exit 127)*"
        }

        It 'throws with "Run Install-Zsh" when zsh at the pin is missing' {
            Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'zsh' } {
                [pscustomobject]@{ Found = $false; VersionOk = $false; Path = $null; Version = $null; Required = '5' }
            }
            { Test-ShellScripts -PassThru -OutputFolder $script:reportFolder } | Should -Throw '*Run Install-Zsh*'
        }
    }
}

Describe 'Repository shell script integrity' -Tag 'L2', 'integrity', 'source-only' {
    It 'every shell script is LF and passes ShellCheck (Test-ShellScripts)' {
        $shellcheck = Resolve-ToolExecutable -Tool shellcheck
        if (-not ($shellcheck.Found -and $shellcheck.VersionOk)) {
            Set-ItResult -Skipped -Because 'tool_shellcheck_missing'
            return
        }
        $result = Test-ShellScripts -PassThru -OutputFolder (Join-Path $TestDrive 'shell-scripts')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
