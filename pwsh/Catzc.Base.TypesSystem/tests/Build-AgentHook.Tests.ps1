<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-types-system/tests/Build-AgentHook.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Build-AgentHook' -Tag 'L0', 'logic' {
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
        $program = Build-AgentHook Assert-BashTimeout -OutputDirectory $script:outputDirectory
        $program | Should -Exist
        Join-Path $script:outputDirectory 'Assert-BashTimeout.source.sha256' | Should -Exist
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly -ParameterFilter {
            $Command -like 'dotnet publish *Assert-BashTimeout.csproj* --configuration Debug --output*'
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly -ParameterFilter { $Message -like 'Agent hook: published*' }
    }

    It 'does nothing while the published program matches its source' {
        $null = Build-AgentHook Assert-BashTimeout -OutputDirectory $script:outputDirectory
        $null = Build-AgentHook Assert-BashTimeout -OutputDirectory $script:outputDirectory
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly
    }

    It 'republishes when the recorded hash no longer matches the source' {
        $null = Build-AgentHook Assert-BashTimeout -OutputDirectory $script:outputDirectory
        Set-Content -LiteralPath (Join-Path $script:outputDirectory 'Assert-BashTimeout.source.sha256') -Value 'stale'
        $null = Build-AgentHook Assert-BashTimeout -OutputDirectory $script:outputDirectory
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -Times 2 -Exactly
    }

    It 'throws when the publish produces no runnable program' {
        Mock Invoke-Executable -ModuleName Catzc.Base.TypesSystem { }
        { Build-AgentHook Assert-BashTimeout -OutputDirectory $script:outputDirectory } | Should -Throw "*produced no runnable 'Assert-BashTimeout' program*"
        Join-Path $script:outputDirectory 'Assert-BashTimeout.source.sha256' | Should -Not -Exist
    }

    It 'records the linked module sources in the hash, so a change to them republishes' {
        $null = Build-AgentHook Assert-BashTimeout -OutputDirectory $script:outputDirectory
        $stamp = Get-Content -LiteralPath (Join-Path $script:outputDirectory 'Assert-BashTimeout.source.sha256') -Raw
        $stamp | Should -BeLike '*Catzc.Base.Timeouts/types/TimeoutsConfig.cs:*'
        $stamp | Should -BeLike '*Catzc.Base.Timeouts/types/BashSafeguard.cs:*'
    }

    It 'publishes every hook folder under .claude/hooks when none is named, each with its own stamp' {
        Mock Invoke-Executable -ModuleName Catzc.Base.TypesSystem {
            $null = New-Item -ItemType Directory -Force -Path $script:outputDirectory
            $hostExecutable = [Environment]::ProcessPath
            $assembly = [System.IO.Path]::GetFileNameWithoutExtension(($Command -split '"')[1])
            Copy-Item -LiteralPath $hostExecutable -Destination (Join-Path $script:outputDirectory ($assembly + [IO.Path]::GetExtension($hostExecutable)))
        }
        $programs = @(Build-AgentHook -OutputDirectory $script:outputDirectory)
        @($programs | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_) }) | Should -Be @('Assert-BashTimeout', 'Record-AgentWrite', 'Record-SessionMessage', 'Show-EditReminder')
        Join-Path $script:outputDirectory 'Record-AgentWrite.source.sha256' | Should -Exist
        Get-Content -LiteralPath (Join-Path $script:outputDirectory 'Record-AgentWrite.source.sha256') -Raw | Should -BeLike '*Catzc.Tooling.Listen/types/WriteLedger.cs:*'
    }

    It 'with -Test names a stale hook and builds nothing, and names none once it is current' {
        Build-AgentHook Assert-BashTimeout -ListStale -OutputDirectory $script:outputDirectory | Should -Be 'Assert-BashTimeout'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -Times 0 -Exactly

        $null = Build-AgentHook Assert-BashTimeout -OutputDirectory $script:outputDirectory
        Build-AgentHook Assert-BashTimeout -ListStale -OutputDirectory $script:outputDirectory | Should -BeNullOrEmpty
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly
    }

    It 'republishes with -Force' {
        $null = Build-AgentHook Assert-BashTimeout -OutputDirectory $script:outputDirectory
        $null = Build-AgentHook Assert-BashTimeout -OutputDirectory $script:outputDirectory -Force
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -Times 2 -Exactly
    }
}

Describe 'Build-AgentHook — Assert-BashTimeout parity with Get-TimeoutSeconds' -Tag 'L2', 'integrity' {
    BeforeAll {
        $script:dotnetMissing = -not (Test-Command 'dotnet')
        if ($script:dotnetMissing) {
            return
        }
        # The hook as published for this repository, reading the shipped timeouts.yml through its own YAML loader.
        $script:program = Build-AgentHook Assert-BashTimeout
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
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        Invoke-Hook @{ command = 'ls'; timeout = $foregroundMs } | Should -BeNullOrEmpty
        Invoke-Hook @{ command = 'ls'; timeout = $foregroundMs + 1 } | Should -BeLike "*timeout <= $foregroundMs ms*"
    }

    It 'allows exactly the background limit Get-TimeoutSeconds resolves, and denies one second more' {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        Invoke-Hook @{ command = "timeout $backgroundSeconds ls"; run_in_background = $true } | Should -BeNullOrEmpty
        Invoke-Hook @{ command = "timeout $($backgroundSeconds + 1) ls"; run_in_background = $true } |
            Should -BeLike "*background limit is $backgroundSeconds s*"
    }
}

Describe 'Build-AgentHook — the published Assert-BashTimeout' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:dotnetMissing = -not (Test-Command 'dotnet')
        if ($script:dotnetMissing) {
            return
        }
        # Publish the real program into the test drive, with a copy of the repository layout it locates its config by.
        $script:root = Join-Path $TestDrive 'repo'
        $configDirectory = Join-Path $script:root "$(Get-CatzcModulesFolder)/Catzc.Base.Timeouts/configs"
        $null = New-Item -ItemType Directory -Force -Path $configDirectory
        Set-Content -LiteralPath (Join-Path $configDirectory 'timeouts.yml') -Value @'
limits:
  devbox:
    bash: { foreground: 7, background: 70 } # widget limits
executables:
  widget: 90
'@
        $script:program = Build-AgentHook Assert-BashTimeout -OutputDirectory (Join-Path $script:root '.claude/hooks/bin') -Force

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
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        $result = Invoke-Hook '{"tool_input":{"command":"ls","timeout":7000}}'
        $result.ExitCode | Should -Be 0
        $result.Output | Should -BeNullOrEmpty
    }

    It 'lets a background call through behind a timeout prefix within the background limit' {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        $result = Invoke-Hook '{"tool_input":{"command":"timeout 70 ls","run_in_background":true}}'
        $result.ExitCode | Should -Be 0
        $result.Output | Should -BeNullOrEmpty
    }

    It 'denies a background call without a timeout prefix and logs it' {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        $result = Invoke-Hook '{"tool_input":{"command":"ls","run_in_background":true}}'
        ($result.Output | ConvertFrom-Json).hookSpecificOutput.permissionDecisionReason | Should -BeLike '*has no*timeout <duration>*prefix*'
        Get-Content -LiteralPath (Join-Path $script:root 'out/time-safeguard.log') -Raw | Should -BeLike "*background`tno timeout prefix`t70 s`tls*"
    }

    It 'denies a foreground call without a timeout, naming the limit' -ForEach @(
        @{ Payload = '{"tool_input":{"command":"ls"}}'; Asked = 'no timeout' }
        @{ Payload = '{"tool_input":{"command":"ls","timeout":7001}}'; Asked = 'timeout 7001 ms' }
    ) {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        $result = Invoke-Hook $Payload
        $result.ExitCode | Should -Be 0
        $decision = ($result.Output | ConvertFrom-Json).hookSpecificOutput
        $decision.hookEventName | Should -Be 'PreToolUse'
        $decision.permissionDecision | Should -Be 'deny'
        $decision.permissionDecisionReason | Should -BeLike "*has $Asked;*timeout <= 7000 ms*"
    }

    It 'denies the call, naming the failure, on a payload it cannot read' {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        $result = Invoke-Hook 'not json'
        $result.ExitCode | Should -Be 0
        $decision = ($result.Output | ConvertFrom-Json).hookSpecificOutput
        $decision.permissionDecision | Should -Be 'deny'
        $decision.permissionDecisionReason | Should -BeLike 'Bash time safeguard hook failed, so the call is denied: *'
    }
}

Describe 'Build-AgentHook — the published Record-AgentWrite' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:dotnetMissing = -not (Test-Command 'dotnet')
        if ($script:dotnetMissing) {
            return
        }
        # Publish the real program into the test drive; it finds the repository three folders above itself.
        $script:root = Join-Path $TestDrive 'repo'
        $null = New-Item -ItemType Directory -Force -Path (Join-Path $script:root 'docs')
        Set-Content -LiteralPath (Join-Path $script:root 'docs/widget.md') -Value "widget`r`n" -NoNewline
        $script:program = Build-AgentHook Record-AgentWrite -OutputDirectory (Join-Path $script:root '.claude/hooks/bin') -Force
        $script:ledger = Join-Path $script:root 'out/agent-writes.jsonl'

        function Invoke-Hook {
            param([string] $Payload)
            $output = $Payload | & $script:program
            [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = ($output -join '') }
        }

        function Get-LedgerLine {
            @(if (Test-Path -LiteralPath $script:ledger) {
                    Get-Content -LiteralPath $script:ledger | ForEach-Object { $_ | ConvertFrom-Json }
                })
        }
    }

    BeforeEach {
        Remove-Item -LiteralPath $script:ledger -ErrorAction Ignore
    }

    It 'records a tool write with its repository-relative path, the listener''s content hash and the session' {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        $file = (Join-Path $script:root 'docs/widget.md').Replace('\', '/')
        $result = Invoke-Hook ('{"hook_event_name":"PostToolUse","tool_name":"Edit","session_id":"gadget","tool_use_id":"call-1","tool_input":{"file_path":"' + $file + '"}}')
        $result.ExitCode | Should -Be 0
        $result.Output | Should -BeNullOrEmpty
        $line = @(Get-LedgerLine)
        $line.Count | Should -Be 1
        $line[0].event | Should -BeExactly 'write'
        $line[0].path | Should -BeExactly 'docs/widget.md'
        $line[0].hash | Should -BeExactly ([Catzc.Base.Globs.DurableHash]::HashFile((Join-Path $script:root 'docs/widget.md')))
        $line[0].session | Should -BeExactly 'gadget'
        $line[0].id | Should -BeExactly 'call-1'
    }

    It 'records the start and the end of a Bash call' {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        Invoke-Hook '{"hook_event_name":"PreToolUse","tool_name":"Bash","session_id":"gadget","tool_use_id":"call-2","tool_input":{"command":"ls"}}' | Out-Null
        Invoke-Hook '{"hook_event_name":"PostToolUse","tool_name":"Bash","session_id":"gadget","tool_use_id":"call-2","tool_input":{"command":"ls"}}' | Out-Null
        @((Get-LedgerLine).event) | Should -Be @('bash-start', 'bash-end')
        @((Get-LedgerLine).id) | Should -Be @('call-2', 'call-2')
    }

    It 'records nothing for a file outside the repository, and never fails or blocks on input it cannot read' {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        $outside = (Join-Path $TestDrive 'gizmo/widget.md').Replace('\', '/')
        Invoke-Hook ('{"hook_event_name":"PostToolUse","tool_name":"Write","session_id":"gadget","tool_input":{"file_path":"' + $outside + '"}}') | Out-Null
        $result = Invoke-Hook 'not json'
        $result.ExitCode | Should -Be 0
        $result.Output | Should -BeNullOrEmpty
        @(Get-LedgerLine).Count | Should -Be 0
    }
}

Describe 'Build-AgentHook — the published Record-SessionMessage' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:dotnetMissing = -not (Test-Command 'dotnet')
        if ($script:dotnetMissing) {
            return
        }
        # Publish the real program into the test drive; it finds the repository three folders above itself.
        $script:root = Join-Path $TestDrive 'repo'
        $script:program = Build-AgentHook Record-SessionMessage -OutputDirectory (Join-Path $script:root '.claude/hooks/bin') -Force
        $script:log = Join-Path $script:root "out/orchestrator-$([DateTime]::Now.ToString('yyyy-MM-dd', [cultureinfo]::InvariantCulture)).log"

        function Invoke-Hook {
            param([string] $Payload)
            $output = $Payload | & $script:program
            [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = ($output -join '') }
        }

        function Get-LogLine {
            @(if (Test-Path -LiteralPath $script:log) {
                    Get-Content -LiteralPath $script:log
                })
        }
    }

    BeforeEach {
        Remove-Item -LiteralPath $script:log -ErrorAction Ignore
    }

    It 'logs a message the session sends, with its short session id, the peer and the first line' {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        $result = Invoke-Hook '{"hook_event_name":"PostToolUse","tool_name":"SendMessage","session_id":"gadget-1234-5678","tool_input":{"to":"widget","message":"\n spin the widget \nsecond line"}}'
        $result.ExitCode | Should -Be 0
        $result.Output | Should -BeNullOrEmpty
        Get-LogLine | Should -HaveCount 1
        Get-LogLine | Select-Object -First 1 | Should -Match '^\d{2}:\d{2} gadget-1 -> widget: spin the widget$'
    }

    It 'logs each cross-session message a prompt carries, with its sender' {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        $prompt = '<cross-session-message from=\"uds:pipe\" from-name=\"widget\" from-mode=\"prompting\">\nhold; oil the gadget\n</cross-session-message>'
        Invoke-Hook ('{"hook_event_name":"UserPromptSubmit","session_id":"gadget","prompt":"' + $prompt + '"}') | Out-Null
        Get-LogLine | Should -HaveCount 1
        Get-LogLine | Select-Object -First 1 | Should -Match '^\d{2}:\d{2} widget -> gadget: hold; oil the gadget$'
    }

    It 'logs nothing for a prompt a person typed or another tool, and never fails or blocks on input it cannot read' {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        Invoke-Hook '{"hook_event_name":"UserPromptSubmit","session_id":"gadget","prompt":"spin the widget"}' | Out-Null
        Invoke-Hook '{"hook_event_name":"PostToolUse","tool_name":"Edit","session_id":"gadget","tool_input":{"file_path":"widget.md"}}' | Out-Null
        $result = Invoke-Hook 'not json'
        $result.ExitCode | Should -Be 0
        $result.Output | Should -BeNullOrEmpty
        @(Get-LogLine).Count | Should -Be 0
    }
}

Describe 'Build-AgentHook — no package feed reaches a hook build' -Tag 'L2', 'integrity' {
    BeforeAll {
        $script:dotnetMissing = -not (Test-Command 'dotnet')
        if ($script:dotnetMissing) {
            return
        }
    }

    # NuGet reads its config from the project's folder up, so each hook folder must see the generated root config's cleared feeds alone.
    It 'lists no package feed from the hook folder <name>' -ForEach @(
        foreach ($folder in [System.IO.Directory]::GetDirectories((Join-Path (Get-RepositoryRoot) '.claude/hooks'))) {
            if ([System.IO.Directory]::GetFiles($folder, '*.csproj').Count -gt 0) {
                @{ name = [System.IO.Path]::GetFileName($folder); folder = $folder }
            }
        }
    ) {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        $listed = Invoke-Executable 'dotnet nuget list source' -WorkingDirectory $folder -PassThru -Silent
        $listed.ExitCode | Should -Be 0
        $listed.Full | Should -Not -Match '\[(Enabled|Disabled)\]' -Because 'a listed feed is one a restore would contact'
        $listed.Full | Should -Match 'No sources found'
    }
}
