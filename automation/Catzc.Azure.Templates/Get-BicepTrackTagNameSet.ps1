<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/Get-BicepTrackTagNameSet.ps1
    name: get-bicep-track-tag-name-set
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1
  config:
    synopsis: Returns the Azure tag *names* used to record what was last deployed.
    description: |-
      For ResourceGroup-target templates the tags live on the RG and have generic names
      (`Deployed_From_Commit`, etc.) — every template that deploys into that RG writes the
      same three tags.

      For Subscription-target templates the tags live on the subscription itself, so they
      are prefixed with the template name to avoid collisions across templates.

      Returned shape:
        { commit, build_id, branch }
    parameters:
      Template: Template name.
    examples:
      - Get-BicepTrackTagNameSet sample
---
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
