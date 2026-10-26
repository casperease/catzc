<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Resolve-ContractAsset.ps1.md"
  header: "generated"
---
#>

function Resolve-ContractAsset {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Root,

        [Parameter(Mandatory)]
        [string] $Version,

        [AllowEmptyString()]
        [string] $Group = '',

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $File,

        [string] $CommandRoot,

        [object] $AppliesTo = @{},

        # A holder the first glob match fills with the tracked files, so nothing is listed until an entry asks.
        [hashtable] $Tracked = @{}
    )

    $name = $Path
    $key = if ($Group) {
        "$Group/$Path"
    }
    else {
        $Path
    }
    $assetName = "contracts/$Root/$Version/$key"
    $manifest = "contracts/$Root/$Version/contract.yml"
    $isEmpty = [string]::IsNullOrWhiteSpace([System.IO.File]::ReadAllText($File))
    $kind = Get-ContractAssetKind -Name $name -IsEmpty:$isEmpty
    $direction = [Catzc.Base.Contracts.ContractDirection]::DependedOn
    if ($Root -ceq [Catzc.Base.Contracts.ContractLayout]::ProvidedRoot) {
        $direction = [Catzc.Base.Contracts.ContractDirection]::Provided
    }
    $isNamed = $AppliesTo.ContainsKey($key)

    if ($kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Sample) {
        if ($isNamed) {
            throw "${manifest}: applies_to names '$key', a $kind asset; only a schema, fragment or presence asset constrains files (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
        }
        return [Catzc.Base.Contracts.ContractAsset]::new($Root, $Version, $Group, $Path, $kind, $null, $direction)
    }

    if ($kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Command) {
        if ($isNamed) {
            throw "${manifest}: applies_to names '$key', a $kind asset; only a schema, fragment or presence asset constrains files (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
        }
        if (-not $Group) {
            throw "contract asset '$assetName': a command contract sits in its module's group folder, since the folder names the owner and the file names the command (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
        }
        if (-not $CommandRoot) {
            throw "contract asset '$assetName': a command contract needs its module's root to name the command's file; pass -CommandRoot (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
        }
        # The asset names the command in the normal form; its file is named in PowerShell's function case.
        $languages = Get-Config -Config languages
        $commandLanguage = $languages.languages | Where-Object name -ceq 'powershell' | Select-Object -First 1
        $stem = $name.Substring(0, $name.Length - '.command.yml'.Length)
        try {
            $command = [Catzc.Base.Objects.NameCase]::FromNormal($stem, $commandLanguage.naming.function[0],
                $languages.naming_normal_form)
        }
        catch {
            throw "contract asset '$assetName': the command '$stem' is not in the repository normal form, $($languages.naming_normal_form) (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
        }
        return [Catzc.Base.Contracts.ContractAsset]::new($Root, $Version, $Group, $Path, $kind,
            "$CommandRoot/$command.ps1", $direction)
    }

    if ($kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Schema) {
        $stem = $name.Substring(0, $name.Length - '.schema.json'.Length)
        $samplePattern = '^' + [regex]::Escape($stem) + '\.sample\.[^.]+$'
        $samples = @([Catzc.Base.Contracts.ContractLayout]::new((Get-Config -Config folder-walk)).FileNames([System.IO.Path]::GetDirectoryName($File)) |
                Where-Object { $_ -cmatch $samplePattern })
        if ($samples.Count -gt 1) {
            throw "contract asset '$assetName': the schema sits beside $($samples.Count) sample payloads named '$stem' ($($samples -join ', ')); keep one sample per schema name (ADR-REPO-CONTRACT-CONTRACTASSET)."
        }
        if ($samples.Count -eq 1) {
            if ($isNamed) {
                throw "${manifest}: applies_to names '$key', a schema that applies to the sample payload beside it; only a schema with no sample beside it takes files (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
            }
            $folder = if ($Group) {
                "contracts/$Root/$Version/$Group/"
            }
            else {
                "contracts/$Root/$Version/"
            }
            return [Catzc.Base.Contracts.ContractAsset]::new($Root, $Version, $Group, $Path, $kind,
                "$folder$($samples[0])", $direction)
        }
    }

    if (-not $isNamed) {
        throw "${manifest}: '$key', a $kind asset, is not named in applies_to, so it binds no file (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
    }
    if ($null -eq $Tracked.Paths) {
        $Tracked.Paths = [string[]] @(Get-GitTrackedPath '.')
    }
    $globs = [string[]] @($AppliesTo[$key])
    $targets = [Catzc.Base.Globs.GlobPattern]::MatchingPaths($globs, $Tracked.Paths)
    if ($targets.Count -eq 0) {
        throw "${manifest}: applies_to of '$key' matches no tracked file ($($globs -join ', ')) (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
    }
    foreach ($target in $targets) {
        [Catzc.Base.Contracts.ContractAsset]::new($Root, $Version, $Group, $Path, $kind, $target, $direction)
    }
}
