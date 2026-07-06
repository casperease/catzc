<#
.SYNOPSIS
    PrePost extension-point starter — the copy-in template for a per-template PrePost.psm1.
.DESCRIPTION
    This file is NOT loaded or called by Build-Bicep / Deploy-Bicep. It exists only as the canonical
    shape that template authors copy to `infrastructure/templates/<name>/PrePost.psm1`: three hook functions,
    each a no-op baseline, that a template overrides as needed.

    At build/deploy time, Build-Bicep / Deploy-Bicep import a template's OWN PrePost.psm1 (when it
    ships one) and invoke whichever of the three hooks it exports. A template with no PrePost.psm1 —
    or one that does not export a given hook — simply skips that step (a no-op). There is no default
    hook loaded from here, and no production code calls into this file.

    Each hook receives an invocation collection describing the build/deploy operation, plus the
    computed descriptor objects:
      BuildInvocation  (prepare)         = @{ Template; Environment; Slot; Subscription; Customer }
      DeployInvocation (pre/post deploy) = @{ Template; Environment; Slot; Subscription; Customer; Mode }
    Read what you need from the collection ($BuildInvocation.Subscription, $DeployInvocation.Mode, …);
    new dimensions arrive as new keys without changing the hook signature. (-DryRun is a separate
    first-class switch on PreDeploy, not a collection key.)

    To customise: copy this file to `infrastructure/templates/<name>/PrePost.psm1`, keep the hook(s) you need,
    delete the rest, and ship.

    See `docs/adr/automation/powershell/prepost-extension-modules.md` for the full extension-point design.
#>

<#
.SYNOPSIS
    Starter build-time hook (no-op): returns ConfigurationDescriptor unchanged.
.DESCRIPTION
    When a template ships this hook, Build-Bicep runs it once per slot, immediately before rendering
    `parameters.<slot>.json` from the result's `.ParametersFile`. It is the deliberate merge seam
    between per-slot config (`configuration/<slot>.yml`) and the global asset configs
    (`Catzc.Azure.Templates/assets/*.yml`). Override it to fill values the per-slot yaml omits.
.PARAMETER BuildInvocation
    The build operation for this slot: @{ Template; Environment; Slot; Subscription; Customer }
    (Slot/Customer empty for a base / core slot; Subscription is the config subfolder being built).
.PARAMETER TemplateDescriptor
    Template descriptor from Get-BicepTemplate.
.PARAMETER ConfigurationDescriptor
    The loaded `configuration/<slot>.yml` (ordered dict carrying `ParametersFile`).
#>
function Invoke-BicepPrepareParameterSet {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Fixed extension-point hook signature: every parameter is part of the contract Build-Bicep binds by name and a template override fills in. This no-op starter reads only what it illustrates, but no parameter may be removed — see the file-level .DESCRIPTION.')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $BuildInvocation,
        [Parameter(Mandatory)] $TemplateDescriptor,
        [Parameter(Mandatory)] $ConfigurationDescriptor
    )

    Write-Verbose "Default Invoke-BicepPrepareParameterSet: returning ConfigurationDescriptor unchanged for $($BuildInvocation.Environment)"
    $ConfigurationDescriptor
}

<#
.SYNOPSIS
    Starter pre-deploy hook (no-op).
.DESCRIPTION
    When a template ships this hook, Deploy-Bicep runs it immediately before `az deployment ...
    create`. State-changing preparation (queue creation, key-vault material, etc.) belongs here — and
    MUST respect `-DryRun` (skip state changes on a preview). This starter does nothing.
.PARAMETER DeployInvocation
    The deploy operation: @{ Template; Environment; Slot; Subscription; Customer; Mode }.
.PARAMETER TemplateDescriptor
    Template descriptor from Get-BicepTemplate.
.PARAMETER ConfigurationDescriptor
    Loaded `configuration/<slot>.yml`.
.PARAMETER EnvironmentDescriptor
    Resolved environment from Get-AzureEnvironment (identity + serving subscription).
.PARAMETER DryRun
    Preview mode — a state-changing hook must return without mutating anything when set.
#>
function Invoke-BicepPreDeploy {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Fixed extension-point hook signature: every parameter is part of the contract Deploy-Bicep binds by name and a template override fills in. This no-op starter reads only what it illustrates, but no parameter may be removed — see the file-level .DESCRIPTION.')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $DeployInvocation,
        [Parameter(Mandatory)] $TemplateDescriptor,
        [Parameter(Mandatory)] $ConfigurationDescriptor,
        [Parameter(Mandatory)] $EnvironmentDescriptor,
        [switch] $DryRun
    )
    Write-Verbose "Default Invoke-BicepPreDeploy: no-op for $($TemplateDescriptor.name) / $($DeployInvocation.Environment) / $($DeployInvocation.Mode)"
}

<#
.SYNOPSIS
    Starter post-deploy hook (no-op).
.DESCRIPTION
    When a template ships this hook, Deploy-Bicep runs it after `az deployment ... create` succeeds and
    before tracking tags are written. Use it for post-deployment fixups or verification. This starter
    does nothing.
.PARAMETER DeployInvocation
    The deploy operation: @{ Template; Environment; Slot; Subscription; Customer; Mode }.
.PARAMETER TemplateDescriptor
    Template descriptor from Get-BicepTemplate.
.PARAMETER ConfigurationDescriptor
    Loaded `configuration/<slot>.yml`.
.PARAMETER EnvironmentDescriptor
    Resolved environment from Get-AzureEnvironment.
.PARAMETER DeploymentOutput
    Parsed `az deployment ... create -o yaml` output. Access `.properties.outputs.<name>.value`
    to pull through Bicep `output` values.
#>
function Invoke-BicepPostDeploy {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Fixed extension-point hook signature: every parameter is part of the contract Deploy-Bicep binds by name and a template override fills in. This no-op starter reads only what it illustrates, but no parameter may be removed — see the file-level .DESCRIPTION.')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $DeployInvocation,
        [Parameter(Mandatory)] $TemplateDescriptor,
        [Parameter(Mandatory)] $ConfigurationDescriptor,
        [Parameter(Mandatory)] $EnvironmentDescriptor,
        [Parameter(Mandatory)] $DeploymentOutput
    )
    Write-Verbose "Default Invoke-BicepPostDeploy: no-op for $($TemplateDescriptor.name) / $($DeployInvocation.Environment) / $($DeployInvocation.Mode)"
}
