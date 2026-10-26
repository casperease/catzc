# pwsh/Base.Execution/Invoke-WithProgress.ps1

A heartbeat for a long call: the scriptblock runs on the current thread while a background thread job writes a dot every interval.

## help

### synopsis

Runs a scriptblock while writing progress dots to the console.

### description

Wraps a long-running call with a visual heartbeat so the user knows the process is alive. The scriptblock runs on the current thread,
preserving module scope and all imported functions, so the dots come from a background ThreadJob that streams to this host (-StreamingHost).

The dots go through the writer chokepoint like every other console write
([ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT](../../../drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-informationstreamchokepoint)):
the job imports the loaded Catzc.Base.Writers module and writes Write-Message '.' -NoHeader -NoNewline — an inline information-stream
record, so the scriptblock's return value passes through uncontaminated. The job inherits this session's Pester-run guard, so a test run
stays silent there as everywhere else.

Dots stop and a trailing newline is written when the scriptblock completes — including when it throws.

### parameter `ScriptBlock`

The work to execute. Runs on the current thread (module scope preserved).

### parameter `Message`

Optional prefix written before the dots (e.g., 'Checking tools'). Appears on the same line as the dots.

### parameter `IntervalMs`

Milliseconds between dots. Defaults to 1000.

### example 1

```powershell
$status = Invoke-WithProgress { Get-ToolsStatus } -Message 'Checking tools'
# Console: Checking tools.......
# $status: the PSCustomObject[] returned by Get-ToolsStatus
```

### example 2

```powershell
Invoke-WithProgress { Install-Dotnet } -Message 'Installing .NET' -IntervalMs 2000
# Console: Installing .NET...
```

### example 3

```powershell
$result = Invoke-WithProgress { Start-Sleep 5; 'done' }
# Console: .....
# $result: 'done'
```

## The dot writer

The job has its own runspace, so it streams to this host, imports the same Writers module this session loaded and copies this session's
Pester-run guard. Its dots therefore behave exactly like a `Write-Message` on the calling thread, and the scriptblock's return value stays
clean.

## Stopping

The job is stopped and removed without `Receive-Job`, because the dots already streamed and receiving would replay them. Removal uses
`-Force`, since `Stop-Job` can return while a thread job is still stopping and a plain `Remove-Job` throws then. This happens in a
`finally`, so a throwing scriptblock still ends the dots and writes the trailing newline.
