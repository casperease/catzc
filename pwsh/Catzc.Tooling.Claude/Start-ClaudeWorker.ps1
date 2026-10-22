<#
---
catzc:
  immutable:
    with_body_sha: a803e3f3a271
  edges:
    test: pwsh/Catzc.Tooling.Claude/tests/Start-ClaudeWorker.Tests.ps1
    docs: "[Start-ClaudeWorker.ps1.md](../../docs/references/pwsh/catzc-tooling-claude/Start-ClaudeWorker.ps1.md)"
    cites:
      - ADR-PWSH-DRYRUN-EARLYRETURNBRANCH
---
#>

function Start-ClaudeWorker {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string] $Agent = (Get-Config -Config claude-worker).agent,

        [string] $Model,

        [Parameter(Position = 0)]
        [string] $Prompt,

        [ValidateRange(1, 20)]
        [int] $Count = 1,

        [ValidateSet('windows-terminal', 'pwsh')]
        [string] $Launcher = (Get-Config -Config claude-worker).launcher,

        [switch] $PassThru,

        [switch] $DryRun
    )

    $root = Get-RepositoryRoot
    for ($index = 1; $index -le $Count; $index++) {
        $launch = Get-ClaudeWorkerLaunch -Agent $Agent -Model $Model -Prompt $Prompt -Launcher $Launcher -WorkingDirectory $root -Index $index
        if ($DryRun) {
            $launch.CommandLine
            continue
        }
        Start-Process -FilePath $launch.FilePath -ArgumentList $launch.ArgumentList -WorkingDirectory $root
        if ($PassThru) {
            $launch.CommandLine
        }
    }
}
