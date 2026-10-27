function Invoke-SlotBreakGlassRotation {
    # A state-changing helper that previews with -DryRun, not ShouldProcess.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Uses -DryRun instead of ShouldProcess — see ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS')]
    [CmdletBinding()]
    param(
        # Slot, ResourceGroup, Server, Vault and Secret of one slot's break-glass password.
        [Parameter(Mandatory)]
        [pscustomobject] $Target,

        [ValidateRange(16, 128)]
        [int] $Length = 32,

        [switch] $DryRun
    )

    $server, $vault, $secretName = $Target.Server, $Target.Vault, $Target.Secret
    if ($DryRun) {
        Write-Message "Would set a new break-glass password on SQL server $server ($($Target.ResourceGroup)), then write it to secret $secretName in vault $vault (slot $($Target.Slot))"
        return
    }

    $password = New-BreakGlassPassword -Length $Length
    $update = Invoke-AzCli "sql server update --resource-group $($Target.ResourceGroup) --name $server --admin-password `"$password`" --output none" -PassThru -NoAssert -Silent
    if ($update.ExitCode -ne 0) {
        throw "Could not set the new password on SQL server $server (slot $($Target.Slot), az exit code $($update.ExitCode)); the server and the vault keep the old one."
    }

    $file = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($file, $password, [System.Text.UTF8Encoding]::new($false))
        $secret = Invoke-AzCli "keyvault secret set --vault-name $vault --name $secretName --file `"$file`" --encoding utf-8 --output none" -PassThru -NoAssert -Silent
    }
    finally {
        [System.IO.File]::Delete($file)
    }
    if ($secret.ExitCode -ne 0) {
        throw "SQL server $server has a new password, but writing it to secret $secretName in vault $vault failed (slot $($Target.Slot), az exit code $($secret.ExitCode)); run the rotation again, which sets a fresh password on both."
    }
    Write-Message "Rotated the break-glass password of SQL server $server (slot $($Target.Slot)); secret $secretName in vault $vault holds it"
}
