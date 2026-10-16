<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/Invoke-WithProgress.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Execution
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-execution/Invoke-WithProgress.ps1.md
      test: automation/Catzc.Base.Execution/tests/Invoke-WithProgress.Tests.ps1
    adrs:
      - ADR-PWSH-ANNOUNCE#1
  config:
    synopsis: Runs a scriptblock while writing progress dots to the console.
    description: |-
      Wraps a long-running call with a visual heartbeat so the user knows
      the process is alive. The scriptblock runs on the current thread,
      preserving module scope and all imported functions, so the dots come
      from a background ThreadJob that streams to this host (-StreamingHost).

      The dots go through the writer chokepoint like every other console
      write ([ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)):
      the job imports the loaded Catzc.Base.Writers
      module and writes Write-Message '.' -NoHeader -NoNewline — an inline
      information-stream record, so the scriptblock's return value passes
      through uncontaminated. The job inherits this session's Pester-run
      guard, so a test run stays silent there as everywhere else.

      Dots stop and a trailing newline is written when the scriptblock
      completes — including when it throws.
    parameters:
      ScriptBlock: The work to execute. Runs on the current thread (module scope preserved).
      Message: |-
        Optional prefix written before the dots (e.g., 'Checking tools').
        Appears on the same line as the dots.
      IntervalMs: Milliseconds between dots. Defaults to 1000.
    examples:
      - |-
        $status = Invoke-WithProgress { Get-ToolsStatus } -Message 'Checking tools'
        # Console: Checking tools.......
        # $status: the PSCustomObject[] returned by Get-ToolsStatus
      - |-
        Invoke-WithProgress { Install-Dotnet } -Message 'Installing .NET' -IntervalMs 2000
        # Console: Installing .NET...
      - |-
        $result = Invoke-WithProgress { Start-Sleep 5; 'done' }
        # Console: .....
        # $result: 'done'
---
#>

function Invoke-WithProgress {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'IntervalMs is consumed inside the dot-writer thread job as $using:IntervalMs, which this rule does not trace as a use')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__PesterRunning (set by Test-Automation) is read here and set in the dot job''s own runspace, so the chokepoint guard there matches this session''s; the job''s $global:InformationPreference makes its writes render. Global is required to reach the chokepoint''s module scope')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $ScriptBlock,

        [string] $Message,

        [int] $IntervalMs = 1000
    )

    if ($Message) {
        Write-Message $Message -NoHeader -NoNewline
    }

    $writersPath = (Get-Module Catzc.Base.Writers).Path
    $silenced = [bool](Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly -ErrorAction Ignore)   # unset outside a test run
    $dotJob = Start-ThreadJob -StreamingHost $Host -ScriptBlock {
        $global:__PesterRunning = $using:silenced
        $global:InformationPreference = 'Continue'
        Import-Module $using:writersPath
        while ($true) {
            Start-Sleep -Milliseconds $using:IntervalMs
            Write-Message '.' -NoHeader -NoNewline
        }
    }

    try {
        # Work runs on the current thread — module scope preserved
        & $ScriptBlock
    }
    finally {
        $dotJob | Remove-Job -Force
        Write-Message '' -NoHeader
    }
}
