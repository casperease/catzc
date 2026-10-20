<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/Get-BicepTrackTagNameSet.ps1
    name: get-bicep-track-tag-name-set
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1
    docs: "[Get-BicepTrackTagNameSet.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-BicepTrackTagNameSet.ps1.md)"
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
