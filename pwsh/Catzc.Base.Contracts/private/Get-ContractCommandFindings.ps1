<#
---
catzc:
  immutable:
    with_body_sha: "7e6bebc47be6"
  edges:
    docs: "[Get-ContractCommandFindings.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Get-ContractCommandFindings.ps1.md)"
    cites:
      - ADR-REPO-CMDCONTRACT-COMMANDCONTRACT
      - ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE
      - ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE
---
#>

function Get-ContractCommandFindings {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [Catzc.Base.Contracts.ContractAsset] $Asset
    )

    $name = [System.IO.Path]::GetFileNameWithoutExtension($Asset.Target)
    $missing = @(Get-ContractPresenceFindings -RepositoryRoot $RepositoryRoot -Path $Asset.Target)
    if ($missing.Count -gt 0) {
        $folder = $Asset.Target.Substring(0, $Asset.Target.LastIndexOf('/') + 1)
        $private = "${folder}private/$name.ps1"
        if ([System.IO.File]::Exists((Join-Path $RepositoryRoot $private))) {
            return "$($missing[0]) '$private' exists, so '$name' is a private function, not a command (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT)."
        }
        return $missing
    }

    try {
        $raw = Read-ContractData -RepositoryRoot $RepositoryRoot -Path $Asset.AssetPath
        $contract = [Catzc.Base.Contracts.ContractCommand]::new($raw)
    }
    catch {
        $reason = $_.Exception.InnerException ? $_.Exception.InnerException.Message : $_.Exception.Message
        return "'$($Asset.AssetPath)': $reason"
    }

    $normalForm = (Get-Config -Config languages).naming_normal_form
    $findings = @(Get-ContractNormalFormFindings -Contract $contract -NormalForm $normalForm)
    if ($findings.Count -gt 0) {
        return $findings | ForEach-Object { "'$($Asset.AssetPath)': $_" }
    }

    # The command's file spells its names in PowerShell's idiom; rendered to the normal form, they compare with the contract's.
    $toNormal = [Func[string, string]] {
        param([string] $text)
        [Catzc.Base.Objects.NameCase]::IsNormal($text, $normalForm) ? $text : [Catzc.Base.Objects.NameCase]::ToNormal('pascal', $text, $normalForm)
    }.GetNewClosure()
    try {
        $command = (Read-CommandSignature -Path (Join-Path $RepositoryRoot $Asset.Target) -Name $name).Renamed($toNormal)
    }
    catch {
        $reason = $_.Exception.InnerException ? $_.Exception.InnerException.Message : $_.Exception.Message
        return $reason
    }

    [Catzc.Base.Contracts.ContractCommand]::Compare($contract, $command)
}
