Describe 'Build-BashTimeoutHook' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Invoke-Executable -ModuleName Catzc.Base.TypesSystem {
            # Stand in for `dotnet publish`: copy this host's own executable to where the real publish puts the
            # program, so it carries the platform's real executable extension and resolves as an application.
            $null = New-Item -ItemType Directory -Force -Path $script:outputDirectory
            $hostExecutable = [Environment]::ProcessPath
            Copy-Item -LiteralPath $hostExecutable -Destination (Join-Path $script:outputDirectory ('Assert-BashTimeout' + [IO.Path]::GetExtension($hostExecutable)))
        }
        Mock Write-Message -ModuleName Catzc.Base.TypesSystem { }
        $script:outputDirectory = Join-Path $TestDrive "bin-$([guid]::NewGuid().ToString('n'))"
    }

    It 'publishes with dotnet, records the source hash and announces it' {
        $program = Build-BashTimeoutHook -OutputDirectory $script:outputDirectory
        $program | Should -Exist
        Join-Path $script:outputDirectory 'source.sha256' | Should -Exist
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly -ParameterFilter {
            $Command -like 'dotnet publish *Assert-BashTimeout.csproj*--output*'
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly -ParameterFilter { $Message -like 'Agent hook: published*' }
    }

    It 'does nothing while the published program matches its source' {
        $null = Build-BashTimeoutHook -OutputDirectory $script:outputDirectory
        $null = Build-BashTimeoutHook -OutputDirectory $script:outputDirectory
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly
    }

    It 'republishes when the recorded hash no longer matches the source' {
        $null = Build-BashTimeoutHook -OutputDirectory $script:outputDirectory
        Set-Content -LiteralPath (Join-Path $script:outputDirectory 'source.sha256') -Value 'stale'
        $null = Build-BashTimeoutHook -OutputDirectory $script:outputDirectory
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -Times 2 -Exactly
    }

    It 'throws when the publish produces no runnable program' {
        Mock Invoke-Executable -ModuleName Catzc.Base.TypesSystem { }
        { Build-BashTimeoutHook -OutputDirectory $script:outputDirectory } | Should -Throw "*produced no runnable 'Assert-BashTimeout' program*"
        Join-Path $script:outputDirectory 'source.sha256' | Should -Not -Exist
    }

    It 'republishes with -Force' {
        $null = Build-BashTimeoutHook -OutputDirectory $script:outputDirectory
        $null = Build-BashTimeoutHook -OutputDirectory $script:outputDirectory -Force
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -Times 2 -Exactly
    }
}

Describe 'Build-BashTimeoutHook — the published hook' -Tag 'L2', 'logic' {
    BeforeAll {
        # Publish the real program into the test drive, with a copy of the repository layout it locates its config by.
        $script:root = Join-Path $TestDrive 'repo'
        $configDirectory = Join-Path $script:root 'automation/Catzc.Base.Timeouts/configs'
        $null = New-Item -ItemType Directory -Force -Path $configDirectory
        Set-Content -LiteralPath (Join-Path $configDirectory 'timeouts.yml') -Value @'
default_seconds: 7 # widget limit
executables:
  widget: 90
'@
        $script:program = Build-BashTimeoutHook -OutputDirectory (Join-Path $script:root '.claude/hooks/bin') -Force

        function Invoke-Hook {
            param([string] $Payload)
            $output = $Payload | & $script:program
            [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = ($output -join '') }
        }
    }

    It 'lets a call through whose timeout is within default_seconds' {
        $result = Invoke-Hook '{"tool_input":{"command":"ls","timeout":7000}}'
        $result.ExitCode | Should -Be 0
        $result.Output | Should -BeNullOrEmpty
    }

    It 'lets a background call through without a timeout' {
        $result = Invoke-Hook '{"tool_input":{"command":"ls","run_in_background":true}}'
        $result.ExitCode | Should -Be 0
        $result.Output | Should -BeNullOrEmpty
    }

    It 'denies a foreground call without a timeout, naming the limit' -ForEach @(
        @{ Payload = '{"tool_input":{"command":"ls"}}'; Asked = 'no timeout' }
        @{ Payload = '{"tool_input":{"command":"ls","timeout":7001}}'; Asked = 'timeout 7001 ms' }
    ) {
        $result = Invoke-Hook $Payload
        $result.ExitCode | Should -Be 0
        $decision = ($result.Output | ConvertFrom-Json).hookSpecificOutput
        $decision.hookEventName | Should -Be 'PreToolUse'
        $decision.permissionDecision | Should -Be 'deny'
        $decision.permissionDecisionReason | Should -BeLike "*has $Asked;*timeout <= 7000 ms*"
    }

    It 'fails as a non-blocking hook error on a payload it cannot read' {
        $result = Invoke-Hook 'not json'
        $result.ExitCode | Should -Be 1
    }
}
