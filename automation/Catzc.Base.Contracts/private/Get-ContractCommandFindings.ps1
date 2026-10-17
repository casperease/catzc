<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/private/Get-ContractCommandFindings.ps1
    folder: private
    name: get-contract-command-findings
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-REPO-CMDCONTRACT#{2,4}
  config:
    synopsis: Checks a command contract against the command's file and returns the findings.
    description: |-
      The PowerShell checker of
      [ADR-REPO-CMDCONTRACT#4](/docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract4). The command's file,
      the asset's target, must first be present with the exact case of its path (Get-ContractPresenceFindings); a missing
      file is the only finding, and when the same name sits in the module's private folder the finding says so, since a
      private function is no command. Then the asset parses as the contract language (ContractCommand,
      [ADR-REPO-CMDCONTRACT#2](/docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract2)), the file's
      signature is read without loading it (Read-CommandSignature), and ContractCommand.Compare gives one finding per
      disagreement. A contract or a file that does not parse is the finding.
    parameters:
      RepositoryRoot: The repository root the asset and its target are relative to.
      Asset: The command contract asset.
    outputs: '[string[]] The findings; none when the command declares what the contract says.'
    examples:
      - Get-ContractCommandFindings -RepositoryRoot $root -Asset $asset
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
            return "$($missing[0]) '$private' exists, so '$name' is a private function, not a command (ADR-REPO-CMDCONTRACT#1)."
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

    try {
        $command = Read-CommandSignature -Path (Join-Path $RepositoryRoot $Asset.Target) -Name $name
    }
    catch {
        return $_.Exception.Message
    }

    [Catzc.Base.Contracts.ContractCommand]::Compare($contract, $command)
}
