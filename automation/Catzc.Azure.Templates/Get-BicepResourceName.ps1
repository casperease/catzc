<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Azure.Templates
    visibility: public
    relatives:
      page: docs/references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md
      test: automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1
    adrs:
      - ADR-AZ-NAMING#8
  config:
    synopsis: Generates an Azure resource name for a template's slot from the naming standard.
    description: |-
      The templating-layer name generator. It resolves the name components from the template and
      environment, then assembles the name for the requested resource type via Get-AzureResourceName:
        - env         — the environment NAME (generous types) and its 2-char shortcode (restricted)
        - slot        — the optional special-slot discriminator (`-Slot`)
        - region_code — the environment's azure.yml region_code
        - org         — azure.yml top-level org
        - short_name  — the template's options.yml short_name
        - order       — the active naming order (Get-AdoNaming; the ado_naming repo-wide variant)

      The caller supplies only what is genuinely per-call: the resource Type and optional Customer /
      Role. Two intended uses for the same generator:
        validation — compare a name configured in a template's ParametersFile against the generated
                     one to catch drift.
        generation — produce the name to inject into the built parameter files (the PrePost seam).
    parameters:
      Template: Template name.
      Environment: Environment shortname.
      Type: Resource-type abbreviation — a key of Get-AzureResourceTypeSet (`rg`, `st`, `kv`, ...).
      Slot: Optional special-slot discriminator; omitted selects the env's base / index-0 slot.
      Customer: |-
        Optional customer, named by its key OR its 2-char shortcode (customer.yml). Its readable key renders in
        generous names and its 2-char shortcode in restricted ones — both resolved here (Get-AzureCustomer) and
        passed to the namer.
      Role: Optional 2-3 char sibling discriminator among same-type resources (per resource).
    examples:
      - 'Get-BicepResourceName -Template sample -Environment dev -Type st   # -> deweuzctsmplst'
      - |-
        Get-BicepResourceName -Template sample-indexed -Environment dev -Slot 001 -Type rg
        # -> dev-001-weu-zct-sidx-rg
---
#>

# cspell:ignore deweuzctsmplst
function Get-BicepResourceName {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ (Get-Config -Config azure).environments.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).environments.Keys })]
        [string] $Environment,

        [Parameter(Mandatory, Position = 2)]
        [ArgumentCompleter({ (Get-AzureResourceTypeSet).Keys })]
        [string] $Type,

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateSlots -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment'] -Customer $fakeBoundParameters['Customer']
            })]
        [string] $Slot,

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateCustomers -Template $fakeBoundParameters['Template']
            })]
        [string] $Customer,
        [string] $Role
    )

    $templateDescriptor = Get-BicepTemplate $Template
    $azure = Get-Config -Config azure
    $envEntry = $azure.environments[$Environment]

    $nameArgs = @{
        Env        = $Environment
        Shortcode  = $envEntry.shortcode
        RegionCode = $envEntry.region_code
        Org        = $azure.org
        ShortName  = $templateDescriptor.short_name
        Type       = $Type
        Order      = Get-AdoNaming
    }
    if (-not [string]::IsNullOrEmpty($Slot)) {
        $nameArgs['Slot'] = $Slot
    }
    if (-not [string]::IsNullOrEmpty($Customer)) {
        $resolvedCustomer = Get-AzureCustomer $Customer
        $nameArgs['Customer'] = $resolvedCustomer.key
        $nameArgs['CustomerShortcode'] = $resolvedCustomer.shortcode
    }
    if (-not [string]::IsNullOrEmpty($Role)) {
        $nameArgs['Role'] = $Role
    }

    Get-AzureResourceName @nameArgs
}
