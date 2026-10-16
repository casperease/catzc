<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/tests/Build-BashTimeoutHook.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.TypesSystem
    relatives:
      page: docs/references/automation/catzc-base-typessystem/tests/Build-BashTimeoutHook.Tests.ps1.md
      source: automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
---
#>

Describe 'Build-BashTimeoutHook' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Invoke-Executable -ModuleName Catzc.Base.TypesSystem {
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

    It 'records the linked module sources in the hash, so a change to them republishes' {
        $null = Build-BashTimeoutHook -OutputDirectory $script:outputDirectory
        $stamp = Get-Content -LiteralPath (Join-Path $script:outputDirectory 'source.sha256') -Raw
        $stamp | Should -BeLike '*Catzc.Base.Timeouts/types/TimeoutsConfig.cs:*'
        $stamp | Should -BeLike '*Catzc.Base.Timeouts/types/BashSafeguard.cs:*'
    }

    It 'republishes with -Force' {
        $null = Build-BashTimeoutHook -OutputDirectory $script:outputDirectory
        $null = Build-BashTimeoutHook -OutputDirectory $script:outputDirectory -Force
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -Times 2 -Exactly
    }
}

Describe 'Build-BashTimeoutHook — parity with Get-TimeoutSeconds' -Tag 'L1', 'integrity' {
    BeforeAll {
        # The hook as published for this repository, reading the shipped timeouts.yml through its own YAML loader.
        $script:program = Build-BashTimeoutHook
        $script:foregroundMs = (Get-TimeoutSeconds -Shell Bash) * 1000
        $script:backgroundSeconds = Get-TimeoutSeconds -Shell Bash -Background

        # The denial reason, or nothing when the hook lets the call through.
        function Invoke-Hook {
            param([hashtable] $ToolInput)
            $output = (@{ tool_input = $ToolInput } | ConvertTo-Json -Compress) | & $script:program
            $json = $output -join ''
            if ($json) {
                ($json | ConvertFrom-Json).hookSpecificOutput.permissionDecisionReason
            }
        }
    }

    It 'allows exactly the foreground limit Get-TimeoutSeconds resolves, and denies one millisecond more' {
        Invoke-Hook @{ command = 'ls'; timeout = $foregroundMs } | Should -BeNullOrEmpty
        Invoke-Hook @{ command = 'ls'; timeout = $foregroundMs + 1 } | Should -BeLike "*timeout <= $foregroundMs ms*"
    }

    It 'allows exactly the background limit Get-TimeoutSeconds resolves, and denies one second more' {
        Invoke-Hook @{ command = "timeout $backgroundSeconds ls"; run_in_background = $true } | Should -BeNullOrEmpty
        Invoke-Hook @{ command = "timeout $($backgroundSeconds + 1) ls"; run_in_background = $true } |
            Should -BeLike "*background limit is $backgroundSeconds s*"
    }
}

Describe 'Build-BashTimeoutHook — the published hook' -Tag 'L2', 'logic' {
    BeforeAll {
        # Publish the real program into the test drive, with a copy of the repository layout it locates its config by.
        $script:root = Join-Path $TestDrive 'repo'
        $configDirectory = Join-Path $script:root 'automation/Catzc.Base.Timeouts/configs'
        $null = New-Item -ItemType Directory -Force -Path $configDirectory
        Set-Content -LiteralPath (Join-Path $configDirectory 'timeouts.yml') -Value @'
limits:
  devbox:
    bash: { foreground: 7, background: 70 } # widget limits
executables:
  widget: 90
'@
        $script:program = Build-BashTimeoutHook -OutputDirectory (Join-Path $script:root '.claude/hooks/bin') -Force

        function Invoke-Hook {
            param([string] $Payload)
            # The published program reads the run environment itself; pin it to the devbox for these fixtures.
            $saved = $env:TF_BUILD, $env:GITHUB_ACTIONS
            $env:TF_BUILD = $null
            $env:GITHUB_ACTIONS = $null
            try {
                $output = $Payload | & $script:program
            }
            finally {
                $env:TF_BUILD, $env:GITHUB_ACTIONS = $saved
            }
            [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = ($output -join '') }
        }
    }

    It 'lets a call through whose timeout is within the devbox foreground limit' {
        $result = Invoke-Hook '{"tool_input":{"command":"ls","timeout":7000}}'
        $result.ExitCode | Should -Be 0
        $result.Output | Should -BeNullOrEmpty
    }

    It 'lets a background call through behind a timeout prefix within the background limit' {
        $result = Invoke-Hook '{"tool_input":{"command":"timeout 70 ls","run_in_background":true}}'
        $result.ExitCode | Should -Be 0
        $result.Output | Should -BeNullOrEmpty
    }

    It 'denies a background call without a timeout prefix and logs it' {
        $result = Invoke-Hook '{"tool_input":{"command":"ls","run_in_background":true}}'
        ($result.Output | ConvertFrom-Json).hookSpecificOutput.permissionDecisionReason | Should -BeLike '*has no*timeout <duration>*prefix*'
        Get-Content -LiteralPath (Join-Path $script:root 'out/time-safeguard.log') -Raw | Should -BeLike "*background`tno timeout prefix`t70 s`tls*"
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
