<#
.SYNOPSIS
    Resolves which subscription a deploy targets — the single source of the deploy-time resolution rule.
.DESCRIPTION
    A template targets a subscription by naming a config folder after it
    (configuration/<subscription>/<env>[-<slot>].yml). Given a (template, env[, slot]) this finds the
    subscriptions that have a config for that exact (env, slot):
      - explicit -Subscription: validated to be one of them (else throws, naming the candidates);
      - exactly one candidate: returned (the common case — `-Subscription` is not needed);
      - more than one: throws asking for -Subscription (the accepted downside — several subscriptions
        serve the same env+slot, e.g. shared + customers);
      - none: throws (the template has no such config).
    Shared by Get-BicepDeploymentContext, Deploy-Bicep, Get-BicepTemplateConfiguration, and
    Set-BicepTrackingTagSet so the resolution rule lives in one place. See docs/adr/azure/data-model.md#rule-adr-datamod7.
.PARAMETER Template
    Template name.
.PARAMETER Environment
    Environment name.
.PARAMETER Slot
    Optional special-slot discriminator; omitted ⇒ the base slot.
.PARAMETER Subscription
    Optional explicit subscription; required only to disambiguate when several serve the env+slot.
.EXAMPLE
    Resolve-BicepDeploymentSubscription -Template discovery -Environment dev                        # -> the one sub, or throws ambiguous
.EXAMPLE
    Resolve-BicepDeploymentSubscription -Template discovery -Environment dev -Subscription apex_nonprod
#>
function Resolve-BicepDeploymentSubscription {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template,

        [Parameter(Mandatory, Position = 1)]
        [string] $Environment,

        [Parameter(Position = 2)]
        [string] $Slot,

        [Parameter(Position = 3)]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateSubscriptions -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment'] -Slot $fakeBoundParameters['Slot']
            })]
        [string] $Subscription
    )

    $templateDescriptor = Get-BicepTemplate $Template
    $configName = Get-BicepConfigName $Environment $Slot
    $wantSlot = [string]$Slot

    $matching = @($templateDescriptor.slots | Where-Object { $_.environment -eq $Environment -and $_.slot -eq $wantSlot })
    $candidates = @($matching | ForEach-Object { $_.subscription } | Select-Object -Unique)

    if (-not [string]::IsNullOrEmpty($Subscription)) {
        if ($Subscription -notin $candidates) {
            throw "Template '$Template' has no config '$configName' for subscription '$Subscription'. Subscriptions with a '$configName' config: $(@($candidates | Sort-Object) -join ', ')"
        }
        return $Subscription
    }

    if ($candidates.Count -eq 0) {
        $configured = @($templateDescriptor.slots | ForEach-Object { $_.name } | Select-Object -Unique | Sort-Object) -join ', '
        $slotText = if ($Slot) {
            ", slot '$Slot'"
        }
        else {
            ''
        }
        throw "Template '$Template' has no config '$configName' (environment '$Environment'$slotText). Configured: $configured"
    }
    if ($candidates.Count -gt 1) {
        throw "Template '$Template' config '$configName' exists in more than one subscription ($(@($candidates | Sort-Object) -join ', ')) — pass -Subscription to choose."
    }
    $candidates[0]
}
