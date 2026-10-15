<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepTrackTagNameSet.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns the Azure tag *names* used to record what was last deployed.
.DESCRIPTION
    Subscription-scope tag names carry the template name, since many templates share one subscription.
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-BicepTrackTagNameSet.ps1.md#comment1)
.PARAMETER Template
    Template name.
.EXAMPLE
    Get-BicepTrackTagNameSet sample
#>
function Get-BicepTrackTagNameSet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template
    )

    $templateDescriptor = Get-BicepTemplate $Template
    if ($templateDescriptor.deployment_target -eq 'Subscription') {
        [ordered]@{
            commit   = "${Template}_Deployed_From_Commit"
            build_id = "${Template}_Deployed_From_BuildId"
            branch   = "${Template}_Deployed_From_Branch"
        }
    }
    else {
        [ordered]@{
            commit   = 'Deployed_From_Commit'
            build_id = 'Deployed_From_BuildId'
            branch   = 'Deployed_From_Branch'
        }
    }
}
