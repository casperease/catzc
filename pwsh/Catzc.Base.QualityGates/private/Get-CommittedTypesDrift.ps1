<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-CommittedTypesDrift.ps1.md"
  header: "generated"
---
#>

function Get-CommittedTypesDrift {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    Import-InternalModule Types
    $modulesFolder = Get-CatzcModulesFolder
    $currentHash = (Get-CombinedTypeHash (Join-Path $RepositoryRoot $modulesFolder)).CombinedHash
    $contract = 'contracts/catzc/0.1.0/catzc.internal.types/types.sample.json'
    $reasons = [System.Collections.Generic.List[string]]::new()

    # The surface the current sources build to, read from their build in the shadow root, against the committed contract.
    $dll = Join-Path (Get-TypesShadowRoot) "Catzc.Types.$currentHash.dll"
    if (-not (Test-Path -LiteralPath $dll -PathType Leaf)) {
        $reasons.Add("no build of the current type sources ($currentHash) in the shadow root — run the importer")
        return [string[]] $reasons.ToArray()
    }
    $facts = { param($Name, $Aliases, $Display) "$Name|$(@($Aliases) -join ',')|$(@($Display) -join ',')" }
    $built = @{}
    foreach ($type in @((Get-TypesAssemblyManifest -Path $dll).Types)) {
        $built[$type.Name] = & $facts $type.Name $type.Aliases $type.Display
    }
    $contractPath = Join-Path $RepositoryRoot $contract
    if (-not (Test-Path -LiteralPath $contractPath -PathType Leaf)) {
        $reasons.Add("$contract is missing — run the importer, which writes the types surface")
    }
    else {
        $committed = @{}
        foreach ($type in @(([System.IO.File]::ReadAllText($contractPath) | ConvertFrom-Json -AsHashtable)['types'])) {
            $committed[$type['name']] = & $facts $type['name'] $type['aliases'] $type['display']
        }
        $added = @($built.Keys | Where-Object { -not $committed.ContainsKey($_) } | Sort-Object -CaseSensitive)
        $removed = @($committed.Keys | Where-Object { -not $built.ContainsKey($_) } | Sort-Object -CaseSensitive)
        $changed = @($built.Keys | Where-Object { $committed.ContainsKey($_) -and $committed[$_] -cne $built[$_] } | Sort-Object -CaseSensitive)
        if ($added.Count + $removed.Count + $changed.Count -gt 0) {
            $reasons.Add("$contract differs from the current build's surface: added [$($added -join ', ')], removed [$($removed -join ', ')], changed [$($changed -join ', ')] — run the importer and commit it")
        }
    }
    if (Test-GitPathChanged $contract) {
        $reasons.Add("$contract has pending git changes — commit the regenerated types surface")
    }

    [string[]] $reasons.ToArray()
}
