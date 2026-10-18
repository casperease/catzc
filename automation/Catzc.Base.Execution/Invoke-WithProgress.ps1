<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Execution/Invoke-WithProgress.ps1
    name: invoke-with-progress
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Execution
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-execution/Invoke-WithProgress.ps1.md
    test: automation/Catzc.Base.Execution/tests/Invoke-WithProgress.Tests.ps1
    cites:
      - ADR-PWSH-ANNOUNCE#1
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
