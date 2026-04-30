<#
.SYNOPSIS
    The build-artifact parameters filename for a (subscription, env, slot) config.
.DESCRIPTION
    The single source of the per-slot parameters artifact name, used by both Build-Bicep (which writes
    it) and Get-BicepDeploymentContext (which reads it) so the two can never drift — the same principle
    as the derived RG name (Get-BicepResourceGroupName).

    `parameters.<subscription>.<config>.json` — where `<config>` is `<env>[-<slot>]`
    (Get-BicepConfigName). All of a template's slots render into one build folder, so keying the
    artifact on the subscription (the config folder) makes it structurally collision-free: two
    subscriptions serving the same env+slot get distinct artifact names with no guard to remember. The
    naming complexity is encapsulated here — the human-facing config tree stays simple. See
    docs/adr/azure/data-model.md.
.PARAMETER Environment
    Environment name.
.PARAMETER Slot
    Optional special-slot discriminator; omitted ⇒ the base slot.
.PARAMETER Subscription
    The subscription (config folder) the slot belongs to.
.EXAMPLE
    Get-BicepParametersFileName -Environment dev -Subscription shared_nonprod            # -> parameters.shared_nonprod.dev.json
.EXAMPLE
    Get-BicepParametersFileName -Environment dev -Slot 001 -Subscription apex_nonprod    # -> parameters.apex_nonprod.dev-001.json
#>
function Get-BicepParametersFileName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Environment,

        [Parameter(Position = 1)]
        [string] $Slot,

        [Parameter(Mandatory, Position = 2)]
        [string] $Subscription
    )

    $config = Get-BicepConfigName $Environment $Slot
    "parameters.$Subscription.$config.json"
}
