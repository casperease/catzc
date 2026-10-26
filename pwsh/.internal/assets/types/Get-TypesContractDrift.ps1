function Get-TypesContractDrift {
    # .SYNOPSIS
    #     Names how a built types assembly's surface differs from the committed types contract.
    # .DESCRIPTION
    #     The surface is each public type's name, aliases and display, read from the assembly's metadata; the contract is
    #     contracts/catzc/0.1.0/catzc.internal.types/types.sample.json under the repository root. One reason for a missing
    #     contract, else one naming every added, removed and changed type; nothing when they agree. It reads git nothing, so a
    #     bundle build and the Types facet share it, and the facet adds its own git reason beside it.
    # .PARAMETER Path
    #     The built assembly (Catzc.Types.<hash>.dll).
    # .PARAMETER RepositoryRoot
    #     The repository root the contract sits under.
    # .OUTPUTS
    #     [string[]] The reasons; nothing when the committed contract is the assembly's surface.
    # .EXAMPLE
    #     Get-TypesContractDrift -Path $dll -RepositoryRoot $root
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $contract = 'contracts/catzc/0.1.0/catzc.internal.types/types.sample.json'
    $contractPath = [System.IO.Path]::Combine($RepositoryRoot, $contract)
    if (-not [System.IO.File]::Exists($contractPath)) {
        return [string[]] @("$contract is missing — run the importer, which writes the types surface")
    }
    $facts = { param($Name, $Aliases, $Display) "$Name|$(@($Aliases) -join ',')|$(@($Display) -join ',')" }
    $built = @{}
    foreach ($type in @((Get-TypesAssemblyManifest -Path $Path).Types)) {
        $built[$type.Name] = & $facts $type.Name $type.Aliases $type.Display
    }
    $committed = @{}
    foreach ($type in @(([System.IO.File]::ReadAllText($contractPath) | ConvertFrom-Json -AsHashtable)['types'])) {
        $committed[$type['name']] = & $facts $type['name'] $type['aliases'] $type['display']
    }
    $added = @($built.Keys | Where-Object { -not $committed.ContainsKey($_) } | Sort-Object -CaseSensitive)
    $removed = @($committed.Keys | Where-Object { -not $built.ContainsKey($_) } | Sort-Object -CaseSensitive)
    $changed = @($built.Keys | Where-Object { $committed.ContainsKey($_) -and $committed[$_] -cne $built[$_] } | Sort-Object -CaseSensitive)
    if ($added.Count + $removed.Count + $changed.Count -eq 0) {
        return [string[]] @()
    }
    [string[]] @("$contract differs from the build's surface: added [$($added -join ', ')], removed [$($removed -join ', ')], changed [$($changed -join ', ')] — run the importer and commit it")
}
