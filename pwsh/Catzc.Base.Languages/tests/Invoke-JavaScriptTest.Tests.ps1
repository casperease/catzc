Describe 'Invoke-JavaScriptTest' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        # A js module is its kebab folder with its own tests/; a module without one is looked for under the root's test
        # holder.
        $script:own = Join-Path $script:root 'js/catzc-widget/tests'
        $null = New-Item -ItemType Directory -Path $script:own -Force
        Set-Content -LiteralPath (Join-Path $script:own 'spin.test.js') -Value 'test("spins", () => {});'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'js/catzc-gadget') -Force
        $script:nodePath = Join-Path $TestDrive 'node/node.exe'
        $null = New-Item -ItemType File -Path $script:nodePath -Force

        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:root }
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'javascript' } {
            [Catzc.Base.Languages.JavaScriptConfig]::new([ordered]@{})
        }
        # The run writes its junit report where the command names it; the case's file is absolute, as node writes it.
        $script:junit = {
            param([string] $Folder, [string] $Body)
            "<testsuites><testsuite name=`"widget`">$($Body.Replace('{file}', (Join-Path $Folder 'spin.test.js')))</testsuite></testsuites>"
        }
    }

    BeforeEach {
        $script:body = '<testcase name="spins" time="0.01" file="{file}"/>'
        $script:exit = 0
        $script:seen = [System.Collections.Generic.List[object]]::new()
        Mock Invoke-Executable -ModuleName Catzc.Base.Languages {
            $script:seen.Add([pscustomobject]@{ Command = $Command; Directory = $WorkingDirectory })
            if ($Command -match '--test-reporter-destination="(?<report>[^"]+)"') {
                [System.IO.File]::WriteAllText($Matches['report'], (& $script:junit $WorkingDirectory $script:body))
            }
            [pscustomobject]@{ ExitCode = $script:exit; Full = 'node output' }
        }
    }

    It 'runs a hyphenated js module''s own tests/ folder, with no pascal-dotted name needed' {
        $results = @(Invoke-JavaScriptTest catzc-widget -NodeExecutable $script:nodePath)
        $results | Should -HaveCount 1
        $results[0].Package | Should -Be 'spin.test.js'
        $results[0].Outcome | Should -Be 'pass'
        $script:seen[0].Directory | Should -Be (Join-Path $script:root 'js/catzc-widget/tests')
        $script:seen[0].Command | Should -BeLike '*--test --test-reporter=junit*spin.test.js*'
    }

    It 'runs the folder it is named, wherever the module''s own tests sit' {
        $null = @(Invoke-JavaScriptTest catzc-gadget -Folder 'js/catzc-widget/tests' -NodeExecutable $script:nodePath)
        $script:seen[0].Directory | Should -Be (Join-Path $script:root 'js/catzc-widget/tests')
    }

    It 'refuses a module that has no tests' {
        { Invoke-JavaScriptTest catzc-gadget -Folder 'js/catzc-gadget' -NodeExecutable $script:nodePath } |
            Should -Throw '*holds no *.test.js*'
    }

    It 'returns a failing case as fail, and refuses a non-zero exit with no failing case' {
        $script:body = '<testcase name="spins" time="0.01" file="{file}"><failure message="widget stuck"/></testcase>'
        $script:exit = 1
        (@(Invoke-JavaScriptTest catzc-widget -NodeExecutable $script:nodePath))[0].Outcome | Should -Be 'fail'
        $script:body = '<testcase name="spins" time="0.01" file="{file}"/>'
        { Invoke-JavaScriptTest catzc-widget -NodeExecutable $script:nodePath } | Should -Throw '*with no failing test*'
    }
}
