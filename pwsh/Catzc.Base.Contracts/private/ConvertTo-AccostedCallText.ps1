<#
---
catzc:
  immutable:
    with_body_sha: "09433ad02c93"
  edges:
    docs: "[ConvertTo-AccostedCallText.ps1.md](docs/references/pwsh/catzc-base-contracts/private/ConvertTo-AccostedCallText.ps1.md)"
    cites:
      - ADR-AUTO-ACCOSTED
---
#>

function ConvertTo-AccostedCallText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Contracts.AccostedCommand] $Command,

        [Parameter(Mandatory)]
        [object] $Contract,

        [Parameter(Mandatory)]
        [Catzc.Base.Engines.ExecutionEngine] $Engine
    )

    # pwsh takes the command as PowerShell names it; every other engine takes it through cats, in the shell's kebab case.
    $normalForm = (Get-Config -Config languages).naming_normal_form
    $isPwsh = $Engine.Name -ceq [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name
    $parts = [System.Collections.Generic.List[string]]::new()
    $parts.Add([Catzc.Base.Objects.NameCase]::FromNormal($Command.name, ($isPwsh ? 'verb-noun' : 'kebab'), $normalForm))
    foreach ($argument in $Command.arguments.Keys) {
        $value = $Command.arguments[$argument]
        $type = ($Contract.parameters | Where-Object { $_.Name -ceq $argument } | Select-Object -First 1)?.Type
        $flag = $isPwsh ? "-$([Catzc.Base.Objects.NameCase]::FromNormal($argument, 'pascal', $normalForm))" : "--$([Catzc.Base.Objects.NameCase]::FromNormal($argument, 'kebab', $normalForm))"
        if ($type -ceq 'switch') {
            if ($value) {
                $parts.Add($flag)
            }
            continue
        }
        $parts.Add($flag)
        $parts.Add($(if ($value -is [bool]) {
                    $isPwsh ? "`$$("$value".ToLowerInvariant())" : "$value".ToLowerInvariant()
                }
                elseif ($value -is [int] -or $value -is [long]) {
                    "$value"
                }
                else {
                    $Engine.Quote("$value")
                }))
    }
    $parts -join ' '
}
