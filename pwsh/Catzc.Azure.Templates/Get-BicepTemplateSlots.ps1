<#
---
catzc:
  immutable:
    with_body_sha: aaa577839458
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1
    docs: "[Get-BicepTemplateSlots.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateSlots.ps1.md)"
---
#>

function Get-BicepTemplateSlots {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Position = 0)]
        [string] $Template,

        [Parameter(Position = 1)]
        [string] $Environment,

        [Parameter(Position = 2)]
        [string] $Customer
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

    $wantCustomer = [string]$Customer
    @($templateDescriptor.slots |
            Where-Object { -not [string]::IsNullOrEmpty($_.slot) } |
            Where-Object { $_.customer -eq $wantCustomer } |
            Where-Object { [string]::IsNullOrEmpty($Environment) -or $_.environment -eq $Environment } |
            ForEach-Object { $_.slot } |
            Select-Object -Unique)
}
