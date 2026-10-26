<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-contracts/Test-AccostedCommand.ps1.md"
  header: "generated"
---
#>

function Test-AccostedCommand {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Call,

        [Parameter(Mandatory)]
        [string] $Where,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $command = [Catzc.Base.Contracts.AccostedCommand]::new((ConvertFrom-Yaml -Yaml $Call -Ordered), $Where)
    $contract = (Get-CommandContractMap -RepositoryRoot $RepositoryRoot)[$command.name]
    if ($null -eq $contract) {
        return "${Where}: '$($command.name)' is no contracted command."
    }

    # Each fault is one finding: the check is what Assert-AccostedArgument already is, caught so a gate can list them
    # all.
    foreach ($argument in $command.arguments.Keys) {
        $parameter = @($contract.parameters | Where-Object { $_.Name -ceq $argument })
        if ($parameter.Count -ne 1) {
            "${Where}: '$($command.name)' has no parameter '$argument' ($($contract.Signature))."
            continue
        }
        try {
            Assert-AccostedArgument -Parameter $parameter[0] -Value $command.arguments[$argument] -Where $Where -Signature $contract.Signature
        }
        catch {
            $_.Exception.Message
        }
    }
    foreach ($parameter in @($contract.parameters | Where-Object { $_.Mandatory -and $_.Sets.Count -eq 0 })) {
        if (-not $command.arguments.ContainsKey($parameter.Name)) {
            "${Where}: '$($command.name)' misses its mandatory parameter '$($parameter.Name)' ($($contract.Signature))."
        }
    }
}
