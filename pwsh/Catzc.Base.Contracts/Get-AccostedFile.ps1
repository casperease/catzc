<#
---
catzc:
  immutable:
    with_body_sha: "37a19766885e"
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/Get-AccostedFile.Tests.ps1
    docs: "[Get-AccostedFile.ps1.md](../../docs/references/pwsh/catzc-base-contracts/Get-AccostedFile.ps1.md)"
    cites:
      - ADR-AUTO-ACCOSTED
---
#>

function Get-AccostedFile {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.AccostedFile])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $full = [System.IO.Path]::IsPathRooted($Path) ? $Path : (Join-Path $RepositoryRoot $Path)
    Assert-PathExist $full -PathType Leaf
    $file = [Catzc.Base.Contracts.AccostedFile]::new(([System.IO.File]::ReadAllText($full) | ConvertFrom-Yaml -Ordered))

    $config = Get-Config -Config accosted
    $contracts = @{}
    foreach ($contract in @(Get-CommandContract -RepositoryRoot $RepositoryRoot)) {
        $contracts[$contract.Name] = $contract
    }

    $runIndex = 0
    foreach ($run in $file.runs) {
        $runIndex++
        $commandIndex = 0
        foreach ($command in $run.commands) {
            $commandIndex++
            $where = "${Path}: run $runIndex, command $commandIndex"
            $contract = $contracts[$command.name]
            Assert-True ($null -ne $contract) -ErrorText "${where}: '$($command.name)' is no contracted command."
            Assert-True $config.IsHarmlessVerb($command.name) `
                -ErrorText "${where}: '$($command.name)' is not harmless: its verb is not on the list ($($config.harmless_verbs -join ', '))."
            foreach ($argument in $command.arguments.Keys) {
                $parameter = @($contract.parameters | Where-Object { $_.Name -ceq $argument })
                Assert-True ($parameter.Count -eq 1) -ErrorText "${where}: '$($command.name)' has no parameter '$argument' ($($contract.Signature))."
                Assert-AccostedArgument -Parameter $parameter[0] -Value $command.arguments[$argument] -Where $where -Signature $contract.Signature
            }
            foreach ($parameter in @($contract.parameters | Where-Object { $_.Mandatory -and $_.Sets.Count -eq 0 })) {
                Assert-True $command.arguments.ContainsKey($parameter.Name) `
                    -ErrorText "${where}: '$($command.name)' misses its mandatory parameter '$($parameter.Name)' ($($contract.Signature))."
            }
        }
    }
    $file
}
