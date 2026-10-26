<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractVersionAsset.ps1.md"
  header: "generated"
---
#>

function Get-ContractVersionAsset {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Root,

        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [string] $Folder,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $layout = [Catzc.Base.Contracts.ContractLayout]::new((Get-Config -Config folder-walk))
    $isCurrent = $Version -ceq [Catzc.Base.Contracts.ContractLayout]::CurrentVersion
    $versionFiles = @($layout.FileNames($Folder) | Where-Object { $_ -cne 'contract.yml' })
    if ($isCurrent -and $versionFiles -ccontains '.frozen') {
        throw "contracts/$Root/${Version}: '.frozen' sits in the current version, which is edited in place and never frozen (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE)."
    }
    $versionFiles = @($versionFiles | Where-Object { $_ -cne '.frozen' })

    $appliesTo = (Read-ContractManifest -Folder $Folder).applies_to
    $tracked = @{ Paths = $null }
    $used = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)

    # An asset sits directly in the version folder or in one group folder, and no group folder holds a folder.
    $places = [System.Collections.Generic.List[object]]::new()
    $places.Add([pscustomobject]@{ Group = ''; Folder = $Folder; Files = [string[]] $versionFiles })
    foreach ($groupFolder in $layout.Folders($Folder)) {
        $group = [System.IO.Path]::GetFileName($groupFolder)
        $deeper = @($layout.Folders($groupFolder) | ForEach-Object { [System.IO.Path]::GetFileName($_) })
        if ($deeper.Count -gt 0) {
            throw "contracts/$Root/$Version/${group}: '$($deeper -join "', '")' is a folder below a group; a group holds only assets, so the tree is contracts/<root>/<version>/[<group>/]<asset> (ADR-REPO-CONTRACT-LAYOUT)."
        }
        $places.Add([pscustomobject]@{ Group = $group; Folder = $groupFolder; Files = [string[]] @($layout.FileNames($groupFolder)) })
    }

    foreach ($place in $places) {
        $commandRoot = $null
        foreach ($name in $place.Files) {
            $key = if ($place.Group) {
                "$($place.Group)/$name"
            }
            else {
                $name
            }
            $null = $used.Add($key)
            if (-not $commandRoot -and $place.Group -and
                (Get-ContractAssetKind -Name $name) -eq [Catzc.Base.Contracts.ContractAssetKind]::Command) {
                $commandRoot = Get-ContractCommandRoot -Module $place.Group -RepositoryRoot $RepositoryRoot
            }
            Resolve-ContractAsset -Root $Root -Version $Version -Group $place.Group -Path $name -File (Join-Path $place.Folder $name) `
                -CommandRoot $commandRoot -AppliesTo $appliesTo -Tracked $tracked
        }
    }

    $unaddressed = @($appliesTo.Keys | Where-Object { -not $used.Contains($_) } | Sort-Object)
    if ($unaddressed.Count -gt 0) {
        throw "contracts/$Root/$Version/contract.yml: applies_to names '$($unaddressed -join "', '")', but no such asset exists under the version folder (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
    }
}
