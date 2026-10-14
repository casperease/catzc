# Test-ShellScripts is a quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)):
# the L0 cases run over a fixture repository in $TestDrive with the index, the tool probe, and ShellCheck mocked, and
# read the collected issues; the report goes to $TestDrive. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
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
        Set-FixtureFile 'automation/Catzc.Widget/assets/scripts/dotnet-install.sh' "#!/usr/bin/env bash`r`necho vendored`r`n"
        Set-FixtureFile 'importer.sh' "cats() { :; }`n"
    }

    BeforeEach {
        $script:checkOutput = ''
        $script:checkExit = 0
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { 'widget/run.sh'; 'automation/Catzc.Widget/assets/scripts/dotnet-install.sh'; 'docs/widget.md' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Executable } { 'widget/run.sh'; 'automation/Catzc.Widget/assets/scripts/dotnet-install.sh' }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'shellcheck' } {
            [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'C:\widget\shellcheck.exe'; Version = '0.11.0'; Required = '0.11' }
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Execution.CliResult]::new($script:checkOutput, '', $script:checkExit)
        }
        $script:reportFolder = Join-Path $TestDrive 'shell-scripts'
    }

    It 'checks the tracked scripts and importer.sh, analysing all but the vendored ones' {
        $result = Test-ShellScripts -PassThru -OutputFolder $script:reportFolder
        $result.Scripts | Should -Be 3
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -eq '"C:\widget\shellcheck.exe" --format=gcc --external-sources "importer.sh" "widget/run.sh"'
        }
    }

    It 'reports CRLF line endings in any script, vendored ones included' {
        $result = Test-ShellScripts -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @('automation/Catzc.Widget/assets/scripts/dotnet-install.sh: CRLF line endings — bash reads the carriage return as part of the command; the file must be LF (.gitattributes *.sh eol=lf)')
    }

    It 'reports a tracked script with a shebang that is not executable in git, but not a sourced one' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Executable } { 'automation/Catzc.Widget/assets/scripts/dotnet-install.sh' }
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
}

# Integrity: every shell script the repository holds is LF and passes the pinned ShellCheck. L2 because it drives the
# ShellCheck CLI; self-skips without it ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)).
# source-only: it reads the repository's own files.
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
