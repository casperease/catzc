# pwsh/Catzc.Base.Execution/Invoke-WithProgress.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs a scriptblock while writing progress dots to the console.

### description

Wraps a long-running call with a visual heartbeat so the user knows the process is alive. The scriptblock runs on the current thread,
preserving module scope and all imported functions, so the dots come from a background ThreadJob that streams to this host (-StreamingHost).

The dots go through the writer chokepoint like every other console write
([ADR-PWSH-ANNOUNCE#1](../../../adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)): the job imports the loaded Catzc.Base.Writers
module and writes Write-Message '.' -NoHeader -NoNewline — an inline information-stream record, so the scriptblock's return value passes
through uncontaminated. The job inherits this session's Pester-run guard, so a test run stays silent there as everywhere else.

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

## comment:1

Above `$writersPath = (Get-Module Catzc.Base.Writers).Path`, written with `#`.

```text
The dot writer runs in a thread job with its own runspace: it streams to this host, imports the same
Writers module this session loaded, and copies this session's Pester-run guard, so its dots behave
exactly like a Write-Message on this thread.
```

## comment:2

Above `$dotJob | Remove-Job -Force`, written with `#`.

```text
Stop and remove without Receive-Job: the dots already streamed, and receiving would replay them.
-Force: Stop-Job can return while a thread job is still Stopping, and a plain Remove-Job throws then.
```
