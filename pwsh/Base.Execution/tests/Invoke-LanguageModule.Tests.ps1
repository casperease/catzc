Describe 'Invoke-LanguageModule' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:hostOs = $IsWindows ? 'windows' : ($IsMacOS ? 'darwin' : 'linux')
        $script:hostArch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -eq [System.Runtime.InteropServices.Architecture]::Arm64 ? 'arm64' : 'amd64'
        $script:hostLeaf = $IsWindows ? 'widget.exe' : 'widget'
    }

    BeforeEach {
        $script:folder = Join-Path $TestDrive 'widget'
        if (Test-Path -LiteralPath $script:folder) {
            Remove-Item -LiteralPath $script:folder -Recurse -Force
        }
        $null = New-Item -ItemType Directory -Path $script:folder -Force
        $script:calls = [System.Collections.Generic.List[object]]::new()

        Mock Get-CatzcModuleRoot -ModuleName Catzc.Base.Execution { $script:folder }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Execution { 'C:\gadget-root' }
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.Execution { 'C:\gadget\bin\bash.exe' }
        Mock Invoke-Executable -ModuleName Catzc.Base.Execution {
            $script:calls.Add([pscustomobject]@{ Command = $Command; WorkingDirectory = Get-Variable -Name WorkingDirectory -ValueOnly -ErrorAction Ignore; PassThru = [bool]$PassThru; PythonPath = $env:PYTHONPATH })
            [pscustomobject]@{ ExitCode = 0; Full = '' }
        }
        $script:uvProbe = [Catzc.Base.Execution.ExecutableProbe]::new('uv', 'C:\gadget\uv\uv.exe', 'probe', '0.11.2', '0.11', $true, 1, 0, 'Agent')
        $script:pythonProbe = [Catzc.Base.Execution.ExecutableProbe]::new('python', 'C:\gadget\py\python.exe', 'probe', '3.13.1', '3.13', $true, 1, 0, 'Agent')
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Execution -ParameterFilter { $Tool -eq 'uv' } { $script:uvProbe }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Execution -ParameterFilter { $Tool -eq 'python' } { $script:pythonProbe }
        $script:goProbe = [Catzc.Base.Execution.ExecutableProbe]::new('go', 'C:\gadget\go\go.exe', 'probe', '1.24', '1.24', $true, 1, 0, 'Agent')
        $script:nodeProbe = [Catzc.Base.Execution.ExecutableProbe]::new('node_js', 'C:\gadget\node\node.exe', 'probe', '24.1.0', '24', $true, 1, 0, 'Agent')
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Execution -ParameterFilter { $Tool -eq 'go' } { $script:goProbe }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Execution -ParameterFilter { $Tool -eq 'node_js' } { $script:nodeProbe }
    }

    It 'finds the folder by place and name' {
        Set-Content -LiteralPath (Join-Path $script:folder 'index.js') -Value ''
        Invoke-LanguageModule -Module 'gadget/place/widget' -Silent
        Should -Invoke Get-CatzcModuleRoot -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter { $Place -eq 'gadget/place' -and $Module -eq 'widget' }
    }

    It 'runs the go binary that matches this platform' {
        $other = $script:hostOs -eq 'linux' ? 'darwin-arm64/widget' : 'linux-amd64/widget'
        $json = ConvertTo-Json -InputObject @(
            @{ path = $other; sha256 = 'aa' }
            @{ path = "$($script:hostOs)-$($script:hostArch)/$($script:hostLeaf)"; sha256 = 'bb' }
        )
        Set-Content -LiteralPath (Join-Path $script:folder 'binaries.json') -Value $json
        Invoke-LanguageModule -Module 'gadget/widget' -Arguments 'one', 'two words' -Silent
        @($script:calls).Count | Should -Be 1
        $script:calls[0].Command | Should -BeLike "*$($script:hostOs)-$($script:hostArch)*$($script:hostLeaf)`" one `"two words`""
        $script:calls[0].Command | Should -Not -BeLike "*$other*"
    }

    It 'throws, naming the module and platform, when no binary fits' {
        Set-Content -LiteralPath (Join-Path $script:folder 'binaries.json') -Value '[{"path":"plan9-mips/widget","sha256":"aa"}]'
        { Invoke-LanguageModule -Module 'gadget/widget' -Silent } | Should -Throw "*go module gadget/widget has no binary for this platform ($($script:hostOs)/$($script:hostArch))*"
        @($script:calls).Count | Should -Be 0
    }

    It 'runs the listed bash entry through the bash engine in the module folder' {
        Set-Content -LiteralPath (Join-Path $script:folder 'executables.json') -Value '["run.sh"]'
        Invoke-LanguageModule -Module 'gadget/widget' -Arguments 'go' -Silent
        Should -Invoke Resolve-EngineExecutable -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter { $Engine -eq 'bash' }
        $script:calls[0].Command | Should -Be '"C:\gadget\bin\bash.exe" run.sh go'
        $script:calls[0].WorkingDirectory | Should -Be $script:folder
    }

    It 'runs a javascript entry through the managed node' {
        Set-Content -LiteralPath (Join-Path $script:folder 'index.js') -Value ''
        Invoke-LanguageModule -Module 'gadget/widget' -Silent -PassThru
        $script:calls[0].Command | Should -Be '"C:\gadget\node\node.exe" index.js'
        $script:calls[0].PassThru | Should -BeTrue
    }

    It 'throws, naming Install-NodeJs and the pin, when node is missing' {
        Set-Content -LiteralPath (Join-Path $script:folder 'extension.js') -Value ''
        $script:nodeProbe = [Catzc.Base.Execution.ExecutableProbe]::new('node_js', $null, 'none', $null, '24', $false, 1, 0, 'Agent')
        { Invoke-LanguageModule -Module 'gadget/widget' -Silent } | Should -Throw "*pin '24'*Install-NodeJs*"
    }

    Context 'a python module' {
        BeforeEach {
            $script:root = Join-Path $TestDrive 'gadget-root'
            Mock Get-OutputRoot -ModuleName Catzc.Base.Execution { $script:root }
            Set-Content -LiteralPath (Join-Path $script:folder 'wheels.json') -Value '[{"name":"gizmo-1.0-py3-none-any.whl","sha256":"aa"}]'
            $script:venv = Join-Path $script:root 'language-modules/gadget-widget/venv'
        }

        It 'creates the environment offline, installs the listed wheels, then runs the module' {
            Invoke-LanguageModule -Module 'gadget/widget' -Arguments 'one', 'two words' -Silent
            @($script:calls).Count | Should -Be 3
            $script:calls[0].Command | Should -Be "`"C:\gadget\uv\uv.exe`" venv --offline --python 3.13 `"$($script:venv)`""
            $script:calls[1].Command | Should -BeLike '"C:\gadget\uv\uv.exe" pip install --offline --no-index --find-links *wheels" --python "*python*" "*gizmo-1.0-py3-none-any.whl"'
            $script:calls[2].Command | Should -BeLike '*python*" -m widget one "two words"'
            $script:calls[2].WorkingDirectory | Should -Be $script:folder
            Get-Content -LiteralPath (Join-Path $script:venv 'catzc-wheels.sha256') -Raw | Should -Match '^[0-9a-f]{64}'
            Test-Path -LiteralPath Env:UV_PYTHON_DOWNLOADS |
                Should -BeFalse -Because 'the variable is set for the environment''s creation only, and an empty value would still reach uv'
        }

        It 'skips the creation when wheels.json is unchanged' {
            Invoke-LanguageModule -Module 'gadget/widget' -Silent
            $script:calls.Clear()
            Invoke-LanguageModule -Module 'gadget/widget' -Silent
            @($script:calls).Count | Should -Be 1
            $script:calls[0].Command | Should -BeLike '*python*" -m widget'
        }

        It 'recreates the environment when wheels.json changed' {
            Invoke-LanguageModule -Module 'gadget/widget' -Silent
            $script:calls.Clear()
            Set-Content -LiteralPath (Join-Path $script:folder 'wheels.json') -Value '[{"name":"gizmo-2.0-py3-none-any.whl","sha256":"bb"}]'
            Invoke-LanguageModule -Module 'gadget/widget' -Silent
            @($script:calls).Count | Should -Be 3
            $script:calls[1].Command | Should -BeLike '*gizmo-2.0-py3-none-any.whl"'
        }

        It 'skips the install when no wheel is listed' {
            Set-Content -LiteralPath (Join-Path $script:folder 'wheels.json') -Value '[]'
            Invoke-LanguageModule -Module 'gadget/widget' -Silent
            @($script:calls).Count | Should -Be 2
        }

        It 'throws, naming Install-Uv and the pin, when uv is missing' {
            $script:uvProbe = [Catzc.Base.Execution.ExecutableProbe]::new('uv', $null, 'none', $null, '0.11', $false, 1, 0, 'Agent')
            { Invoke-LanguageModule -Module 'gadget/widget' -Silent } | Should -Throw "*pin '0.11'*Install-Uv*"
            @($script:calls).Count | Should -Be 0
        }

        It 'sets PYTHONPATH to the place folder for the call only' {
            $before = $env:PYTHONPATH
            Invoke-LanguageModule -Module 'gadget/widget' -Silent
            $script:calls[2].PythonPath | Should -Be $TestDrive
            $script:calls[0].PythonPath | Should -Be $before
            $env:PYTHONPATH | Should -Be $before
        }
    }

    It 'runs go run in the module folder when a go source has no manifest' {
        Set-Content -LiteralPath (Join-Path $script:folder 'go.mod') -Value 'module widget'
        Invoke-LanguageModule -Module 'gadget/widget' -Silent
        $script:calls[0].Command | Should -Be '"C:\gadget\go\go.exe" run .'
        $script:calls[0].WorkingDirectory | Should -Be $script:folder
    }

    It 'runs the one shell script of a bash source folder' {
        Set-Content -LiteralPath (Join-Path $script:folder 'tool.sh') -Value ''
        Invoke-LanguageModule -Module 'gadget/widget' -Silent
        $script:calls[0].Command | Should -Be '"C:\gadget\bin\bash.exe" tool.sh'
    }

    It 'honours a given working directory' {
        Set-Content -LiteralPath (Join-Path $script:folder 'index.js') -Value ''
        Invoke-LanguageModule -Module 'gadget/widget' -WorkingDirectory 'C:\gadget-work' -Silent
        $script:calls[0].WorkingDirectory | Should -Be 'C:\gadget-work'
    }

    It 'throws when the folder holds nothing to run' {
        { Invoke-LanguageModule -Module 'gadget/widget' -Silent } | Should -Throw '*found nothing to run in gadget/widget*'
    }
}
