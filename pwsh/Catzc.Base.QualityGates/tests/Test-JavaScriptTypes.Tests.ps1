Describe 'Test-JavaScriptTypes' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $null = New-Item -ItemType Directory -Path $script:root -Force
        Set-Content -LiteralPath (Join-Path $script:root 'jsconfig.json') -Value '{}'
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:root }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Found = $true; Path = 'C:/tools/tsc.cmd' } }
    }

    BeforeEach {
        $script:output = ''
        $script:exit = 0
        $script:strict = @()
        $script:commands = [System.Collections.Generic.List[string]]::new()
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'javascript' } {
            [Catzc.Base.Languages.JavaScriptConfig]::new([ordered]@{ strict = @($script:strict) })
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {
            $script:command = $Command
            $script:commands.Add($Command)
            [pscustomobject]@{ ExitCode = $script:exit; Output = $script:output; Full = $script:output }
        }
    }

    It 'checks the generated jsconfig.json with tsc and passes when it reports nothing' {
        $result = Test-JavaScriptTypes -OutputFolder (Join-Path $TestDrive 'clean') -PassThru
        $result.Issues | Should -HaveCount 0
        $script:command | Should -BeLike '"C:/tools/tsc.cmd" --noEmit --pretty false -p "*jsconfig.json"'
    }

    It 'reports every tsc error as one issue at its repository path, line and column' {
        $script:exit = 2
        $script:output = "js/catzc-widget/extension.js(4,7): error TS2339: Property 'spin' does not exist on type 'Widget'.`nFound 1 error."
        { Test-JavaScriptTypes -OutputFolder (Join-Path $TestDrive 'errors') } | Should -Throw 'Test-JavaScriptTypes failed: 1 issue(s)*'
        $result = Test-JavaScriptTypes -OutputFolder (Join-Path $TestDrive 'errors-pass') -PassThru
        $result.Issues | Should -Be @("js/catzc-widget/extension.js:4:7: error TS2339 Property 'spin' does not exist on type 'Widget'.")
    }

    It 'checks the strict project too, once a module is raised, and asks for it when it is missing' {
        $script:strict = @('catzc-widget')
        { Test-JavaScriptTypes -OutputFolder (Join-Path $TestDrive 'no-strict') } | Should -Throw '*jsconfig.strict.json is missing*'
        Set-Content -LiteralPath (Join-Path $script:root 'jsconfig.strict.json') -Value '{}'
        $script:commands.Clear()
        $result = Test-JavaScriptTypes -OutputFolder (Join-Path $TestDrive 'strict') -PassThru
        $result.Issues | Should -HaveCount 0
        $script:commands | Should -HaveCount 2
        $script:commands[1] | Should -BeLike '*-p "*jsconfig.strict.json"'
    }

    It 'refuses a tsc that fails without an error line, and a missing jsconfig.json' {
        $script:exit = 1
        $script:output = 'error TS5058: The specified path does not exist.'
        { Test-JavaScriptTypes -OutputFolder (Join-Path $TestDrive 'broken') } | Should -Throw '*could not check*'
        Remove-Item -LiteralPath (Join-Path $script:root 'jsconfig.json')
        { Test-JavaScriptTypes } | Should -Throw '*jsconfig.json is missing*'
    }
}
