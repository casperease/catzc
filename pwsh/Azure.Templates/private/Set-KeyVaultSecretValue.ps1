function Set-KeyVaultSecretValue {
    # A state-changing helper whose callers branch on -DryRun before they call it.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Callers branch on -DryRun before calling it — see ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS')]
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory)]
        [string] $Vault,

        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $Value
    )

    $file = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($file, $Value, [System.Text.UTF8Encoding]::new($false))
        $secret = Invoke-AzCli "keyvault secret set --vault-name $Vault --name $Name --file `"$file`" --encoding utf-8 --output none" -PassThru -NoAssert -Silent
    }
    finally {
        [System.IO.File]::Delete($file)
    }
    $secret.ExitCode
}
