<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/Get-BicepTemplateCustomers.ps1
    name: get-bicep-template-customers
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
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1
    docs: "[Get-BicepTemplateCustomers.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateCustomers.ps1.md)"
---
#>

function Get-BicepTemplateCustomers {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Position = 0)]
        [string] $Template
    )

    if ([string]::IsNullOrEmpty($Template)) {
        return @()
    }

    # Assign first so the comma-wrapped array is collected, then enumerate element-by-element.
    $templates = Get-BicepTemplates
    $templateDescriptor = $templates | Where-Object { $_.name -eq $Template } | Select-Object -First 1
    if (-not $templateDescriptor) {
        return @()
    }

    @($templateDescriptor.customers)
}
