<#
---
catzc:
  immutable:
    with_body_sha: "73f973365b9e"
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/Invoke-Accosted.Tests.ps1
    docs: "[Invoke-Accosted.ps1.md](../../docs/references/pwsh/catzc-base-contracts/Invoke-Accosted.ps1.md)"
    cites:
      - ADR-AUTO-ACCOSTED
---
#>

function Invoke-Accosted {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.AccostedRunResult[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string[]] $Engine = [Catzc.Base.Engines.ExecutionEngines]::Names,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $file = Get-AccostedFile -Path $Path -RepositoryRoot $RepositoryRoot
    $contracts = @{}
    foreach ($contract in @(Get-CommandContract -RepositoryRoot $RepositoryRoot)) {
        $contracts[$contract.Name] = $contract
    }
    $seconds = (Get-Config -Config timeouts).tests[(Get-Config -Config accosted).run_timeout]

    foreach ($engineName in $Engine) {
        $model = [Catzc.Base.Engines.ExecutionEngines]::Get($engineName)
        $executable = $null
        $missing = $null
        try {
            $executable = Resolve-EngineExecutable -Engine $model.Name
        }
        catch {
            $missing = $_.Exception.Message
        }
        $entry = Join-Path $RepositoryRoot $model.ImporterEntry
        if ($model.Name -cne [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name) {
            $entry = $entry.Replace('\', '/')
        }

        $runIndex = 0
        foreach ($run in $file.runs) {
            $runIndex++
            # The engine prefixes the first command; each later one in the run takes the prefix itself, and && stops at a failure.
            $calls = @(foreach ($command in $run.commands) {
                    ConvertTo-AccostedCallText -Command $command -Contract $contracts[$command.name] -Engine $model
                })
            $text = $calls -join " && $($model.CommandPrefix)"
            if ($missing) {
                [Catzc.Base.Contracts.AccostedRunResult]::new($runIndex, $model.Name, $null, $text, $missing)
                continue
            }
            $line = ConvertTo-CommandLineText -Executable $executable -Argument $model.StartArguments($entry, $text)
            $result = Invoke-Executable $line -PassThru -NoAssert -Silent -TimeoutSeconds $seconds -WorkingDirectory $RepositoryRoot
            [Catzc.Base.Contracts.AccostedRunResult]::new($runIndex, $model.Name, $result.ExitCode, $text, "$($result.Full)")
        }
    }
}
