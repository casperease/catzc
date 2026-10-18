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
