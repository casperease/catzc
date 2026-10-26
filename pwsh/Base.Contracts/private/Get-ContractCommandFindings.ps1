<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractCommandFindings.ps1.md"
  header: "generated"
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

    $toNormal = [Func[string, string]] {
        param([string] $text)
        [Catzc.Base.Objects.NameCase]::IsNormal($text,
            $normalForm) ? $text : [Catzc.Base.Objects.NameCase]::ToNormal('pascal', $text, $normalForm)
    }.GetNewClosure()
    try {
        $command = (Read-CommandSignature -Path (Join-Path $RepositoryRoot $Asset.Target) -Name $name).Renamed($toNormal)
    }
    catch {
        $reason = $_.Exception.InnerException ? $_.Exception.InnerException.Message : $_.Exception.Message
        return $reason
    }

    [Catzc.Base.Contracts.ContractCommand]::Compare($contract, $command)

    # The description is the command's help synopsis as plain text; the synopsis on the comment page is its one source.
    $page = Get-CommentPage -Path $Asset.Target -Config (Get-Config -Config comment-pages)
    $pageFile = if ($page) {
        Join-Path $RepositoryRoot $page
    }
    $synopsis = if ($pageFile -and [System.IO.File]::Exists($pageFile)) {
        [Catzc.Base.CodeMeta.PlainText]::Synopsis([System.IO.File]::ReadAllText($pageFile))
    }
    else {
        ''
    }
    if (-not $synopsis) {
        "'$($Asset.AssetPath)': '$name' has no help synopsis on its comment page to describe it"
    }
    else {
        Get-ContractDescriptionFindings -AssetPath $Asset.AssetPath -Key description -Description "$($contract.description)" -Synopsis $synopsis
    }
}
