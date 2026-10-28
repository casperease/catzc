function Set-AnomalyAlertRecipientSecret {
    # A state-changing command that previews with -DryRun, not ShouldProcess.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Uses -DryRun instead of ShouldProcess — see ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).environments.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).environments.Keys })]
        [string] $Environment,

        [Parameter(Mandatory)]
        [string] $Value,

        [string] $SubscriptionIdAssertIs,

        [switch] $DryRun
    )

    if ((Test-IsRunningInPipeline) -and [string]::IsNullOrEmpty($SubscriptionIdAssertIs)) {
        throw "Set-AnomalyAlertRecipientSecret requires -SubscriptionIdAssertIs in a pipeline — the pipeline must pin the subscription GUID its service connection is expected to target ($Environment)."
    }
    $recipients = @($Value -split ',' | ForEach-Object { $_.Trim() })
    $malformed = @($recipients | Where-Object { $_ -notmatch '^[^@\s,]+@[^@\s,]+\.[^@\s,]+$' })
    if ($recipients.Count -eq 0 -or $malformed.Count -gt 0) {
        throw "The anomaly alert's recipients must be comma-separated email addresses; $($malformed.Count) of $($recipients.Count) entries are not ($Environment)."
    }

    # The az session decides the subscription, as for a deploy; the assert guard only pins it.
    $session = Get-AzCliSessionSubscription
    if (-not [string]::IsNullOrEmpty($SubscriptionIdAssertIs)) {
        Assert-IsGuid $SubscriptionIdAssertIs
        if ("$($session.id)" -ne $SubscriptionIdAssertIs) {
            throw "-SubscriptionIdAssertIs failed: the az session targets subscription '$($session.name)' ($($session.id)), not $SubscriptionIdAssertIs."
        }
    }
    $customer = if ([string]::IsNullOrEmpty($session.customer)) {
        ''
    }
    else {
        $session.customer
    }

    # The secret's name is the one the configuration template references; the vault is the vault template's, by the namer.
    $templates = Get-Config -Config anomaly-alert
    $configurationTemplate = $templates.configuration_template
    $vaultTemplate = $templates.vault_template
    $parameters = (Get-BicepTemplateConfiguration $configurationTemplate $Environment -Customer $customer).ParametersFile.parameters
    if (-not $parameters.Contains('anomalyAlertRecipients') -or -not $parameters['anomalyAlertRecipients'].Contains('reference')) {
        throw "The $configurationTemplate configuration for $Environment$(if ($customer) { " (customer '$customer')" }) has no Key Vault reference for anomalyAlertRecipients, so there is no secret to seed."
    }
    $reference = $parameters['anomalyAlertRecipients'].reference
    $vault = Get-BicepResourceName -Template $vaultTemplate -Environment $Environment -Type kv -Customer $customer
    $referencedVault = ($reference.keyVault.id -split '/')[-1]
    if ($referencedVault -ne $vault) {
        throw "The $configurationTemplate configuration for $Environment references vault '$referencedVault', but the $vaultTemplate vault there is '$vault'; correct the reference."
    }
    $secretName = $reference.secretName

    if ($DryRun) {
        Write-Message "Would write $($recipients.Count) anomaly alert recipients to secret $secretName in vault $vault (subscription $($session.name))"
        return
    }
    $exitCode = Set-KeyVaultSecretValue -Vault $vault -Name $secretName -Value ($recipients -join ',')
    if ($exitCode -ne 0) {
        throw "Writing the anomaly alert recipients to secret $secretName in vault $vault failed (subscription $($session.name), az exit code $exitCode); the vault keeps its previous value."
    }
    Write-Message "Wrote $($recipients.Count) anomaly alert recipients to secret $secretName in vault $vault (subscription $($session.name))"
}
