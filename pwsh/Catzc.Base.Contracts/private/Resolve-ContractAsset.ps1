<#
---
catzc:
  immutable:
    with_body_sha: e65c85d4fe5e
  edges:
    docs: "[Resolve-ContractAsset.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Resolve-ContractAsset.ps1.md)"
    cites:
      - ADR-AUTO-ZERO
      - ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS
      - ADR-REPO-CONTRACT-LAYOUT
      - ADR-REPO-CONTRACT-CONTRACTASSET
      - ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION
---
#>

function Resolve-ContractAsset {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset])]
    param(
        [Parameter(Mandatory)]
        [string] $Unit,

        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [string] $Module,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $File,

        [AllowEmptyString()]
        [string] $TargetRoot = [Catzc.Base.Contracts.ContractsConfig]::DefaultTargetRoot,

        [System.Collections.IDictionary] $Override = @{},

        [string] $CommandRoot
    )

    $name = [System.IO.Path]::GetFileName($File)
    $isEmpty = [string]::IsNullOrWhiteSpace([System.IO.File]::ReadAllText($File))
    $kind = Get-ContractAssetKind -Name $name -IsEmpty:$isEmpty

    $prefix = if ($TargetRoot) {
        "$TargetRoot/"
    }
    else {
        ''
    }
    $target = "$prefix$Path"
    $direction = [Catzc.Base.Contracts.ContractDirection]::DependedOn
    if ($kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Sample) {
        $target = $null
        $direction = [Catzc.Base.Contracts.ContractDirection]::Provided
    }
    elseif ($kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Command) {
        if ($Path.Contains('/')) {
            throw "contract asset 'contracts/$Unit/$Version/$Module/$Path': a command contract sits directly in its module folder, since the folder names the owner and the file names the command (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
        }
        if (-not $CommandRoot) {
            throw "contract asset 'contracts/$Unit/$Version/$Module/$Path': a command contract needs its module's root to name the command's file; pass -CommandRoot (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
        }
        # The asset names the command in the normal form; its file is named in PowerShell's function case.
        $languages = Get-Config -Config languages
        $commandLanguage = $languages.languages | Where-Object name -ceq 'powershell' | Select-Object -First 1
        $stem = $name.Substring(0, $name.Length - '.command.yml'.Length)
        try {
            $command = [Catzc.Base.Objects.NameCase]::FromNormal($stem, $commandLanguage.naming.function[0], $languages.naming_normal_form)
        }
        catch {
            throw "contract asset 'contracts/$Unit/$Version/$Module/$Path': the command '$stem' is not in the repository normal form, $($languages.naming_normal_form) (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
        }
        $target = "$CommandRoot/$command.ps1"
        $direction = [Catzc.Base.Contracts.ContractDirection]::Provided
    }
    elseif ($kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Schema) {
        $stem = $name.Substring(0, $name.Length - '.schema.json'.Length)
        $samplePattern = '^' + [regex]::Escape($stem) + '\.sample\.[^.]+$'
        $folder = [System.IO.Path]::GetDirectoryName($File)
        $samples = @([System.IO.Directory]::GetFiles($folder) |
                ForEach-Object { [System.IO.Path]::GetFileName($_) } |
                Where-Object { $_ -cmatch $samplePattern } |
                Sort-Object)
        $target = $prefix + $Path.Substring(0, $Path.Length - '.schema.json'.Length)
        if ($samples.Count -gt 1) {
            throw "contract asset 'contracts/$Unit/$Version/$Module/$Path': the schema sits beside $($samples.Count) sample payloads named '$stem' ($($samples -join ', ')); keep one sample per schema name (ADR-REPO-CONTRACT-CONTRACTASSET)."
        }
        if ($samples.Count -eq 1) {
            $slash = $Path.LastIndexOf('/')
            $relative = if ($slash -ge 0) {
                $Path.Substring(0, $slash + 1) + $samples[0]
            }
            else {
                $samples[0]
            }
            $target = "contracts/$Unit/$Version/$Module/$relative"
            $direction = [Catzc.Base.Contracts.ContractDirection]::Provided
        }
    }

    $key = "$Module/$Path"
    $isOverridden = $Override.ContainsKey($key)
    if ($isOverridden) {
        $direction = $Override[$key]
    }

    [Catzc.Base.Contracts.ContractAsset]::new($Unit, $Version, $Module, $Path, $kind, $target, $direction, $isOverridden)
}
