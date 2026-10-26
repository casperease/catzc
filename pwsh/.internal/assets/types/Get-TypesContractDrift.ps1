function Get-TypesContractDrift {
    # .SYNOPSIS
    #     Names how a built types assembly's surface differs from the committed per-group types contracts.
    # .DESCRIPTION
    #     The surface is each public type's name, aliases, display and public members, read from the assembly's metadata;
    #     the contracts are the types.json files in the module groups under the repository root (Get-TypesContractPath, by
    #     namespace). One reason per contract that is missing, left over or differs, naming every added, removed and changed
    #     type; nothing when they agree. It reads git nothing, so a bundle build and the Types facet share it, and the facet
    #     adds its own git reason beside it.
    # .PARAMETER Path
    #     The built assembly (Catzc.Types.<hash>.dll).
    # .PARAMETER RepositoryRoot
    #     The repository root the contracts sit under.
    # .OUTPUTS
    #     [string[]] The reasons; nothing when the committed contracts are the assembly's surface.
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

    $facts = { param($Name, $Aliases, $Display, $Members)
        "$Name|$(@($Aliases) -join ',')|$(@($Display) -join ',')|$(@($Members | ForEach-Object { "$($_.name):$($_.kind)" }) -join ',')"
    }
    $built = [ordered]@{}
    foreach ($type in @((Get-TypesAssemblyManifest -Path $Path).Types)) {
        $contract = Get-TypesContractPath -RepositoryRoot $RepositoryRoot -Namespace $type.Name.Substring(0, $type.Name.LastIndexOf('.'))
        if (-not $built.Contains($contract)) {
            $built[$contract] = @{}
        }
        $members = @($type.Members | ForEach-Object { @{ name = $_.Name; kind = $_.Kind } })
        $built[$contract][$type.Name] = & $facts $type.Name $type.Aliases $type.Display $members
    }

    $reasons = [System.Collections.Generic.List[string]]::new()
    $version = [System.IO.Path]::Combine($RepositoryRoot, 'contracts', 'catzc', '0.1.0')
    if ([System.IO.Directory]::Exists($version)) {
        foreach ($group in [System.IO.Directory]::GetDirectories($version)) {
            $contract = "contracts/catzc/0.1.0/$([System.IO.Path]::GetFileName($group))/types.json"
            if ([System.IO.File]::Exists([System.IO.Path]::Combine($group, 'types.json')) -and -not $built.Contains($contract)) {
                $reasons.Add("$contract names a module that builds no type — run the importer, which deletes it")
            }
        }
    }
    foreach ($contract in $built.Keys) {
        $contractPath = [System.IO.Path]::Combine($RepositoryRoot, $contract)
        if (-not [System.IO.File]::Exists($contractPath)) {
            $reasons.Add("$contract is missing — run the importer, which writes the types surface")
            continue
        }
        $committed = @{}
        foreach ($type in @(([System.IO.File]::ReadAllText($contractPath) | ConvertFrom-Json -AsHashtable)['types'])) {
            $committed[$type['name']] = & $facts $type['name'] $type['aliases'] $type['display'] $type['members']
        }
        $surface = $built[$contract]
        $added = @($surface.Keys | Where-Object { -not $committed.ContainsKey($_) } | Sort-Object -CaseSensitive)
        $removed = @($committed.Keys | Where-Object { -not $surface.ContainsKey($_) } | Sort-Object -CaseSensitive)
        $changed = @($surface.Keys | Where-Object { $committed.ContainsKey($_) -and $committed[$_] -cne $surface[$_] } | Sort-Object -CaseSensitive)
        if ($added.Count + $removed.Count + $changed.Count -gt 0) {
            $reasons.Add("$contract differs from the build's surface: added [$($added -join ', ')], removed [$($removed -join ', ')], changed [$($changed -join ', ')] — run the importer and commit it")
        }
    }
    [string[]] $reasons.ToArray()
}
