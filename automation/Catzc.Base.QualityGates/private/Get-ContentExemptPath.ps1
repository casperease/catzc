<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-ContentExemptPath.Tests.ps1
    adrs:
      - ADR-REPO-CONTRACT#6
      - ADR-REPO-ROOTCFG#1
  config:
    synopsis: Lists which of the given paths the content tools leave as written.
    description: |-
      The one predicate the tools that rewrite or check tracked-file content (the link tools, the Markdown-title tools)
      ask before they touch a file. A path is exempt when .gitattributes puts it in one of four classes:
      linguist-vendored (third-party code, kept as shipped), linguist-generated (files the automation writes, aligned at
      their authored input instead), catzc-fixture (test fixture trees, data on purpose), and catzc-contract (contract
      assets under contracts/<unit>/<version>/, whose bytes are what a contract check compares —
      [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)). The classes are declared
      in the authored .gitattributes that Build-RootConfig renders to the root
      ([ADR-REPO-ROOTCFG#1](/docs/adr/repository/generated-root-configs.md#rule-adr-repo-rootcfg1)), never in a list of a
      tool's own; this function only names which classes mean "leave as written".
    parameters:
      RepositoryRoot: The repository root the paths are relative to.
      Path: Repository-relative, '/'-separated paths.
    outputs: '[string[]] The given paths that are exempt, in the given order.'
---
#>

function Get-ContentExemptPath {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    $classNames = 'linguist-vendored', 'linguist-generated', 'catzc-fixture', 'catzc-contract', 'catzc-notes'
    if ($Path.Count -eq 0) {
        return , [string[]] @()
    }
    $attributes = Get-GitAttributeValue -RepositoryRoot $RepositoryRoot -Path $Path -Attribute $classNames
    , [string[]] @($Path | Where-Object {
            $classes = $attributes[$_]
            $classes -and @($classNames | Where-Object { $classes[$_] -in 'set', 'true' }).Count -gt 0
        })
}
