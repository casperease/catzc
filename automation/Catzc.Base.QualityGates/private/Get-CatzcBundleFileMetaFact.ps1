<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Get-CatzcBundleFileMetaFact.ps1
    folder: private
    name: get-catzc-bundle-file-meta-fact
    filetype: ps1
    kind: function
    subkind: fact
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-CatzcBundleFileMetaFact.Tests.ps1
    cites:
      - ADR-PRIN-CONFIG#1
  config:
    synopsis: 'The bundle meta kind''s fact: the smallest built bundle that holds the module a file is in.'
    description: |-
      A bundle is a profile of the exporter registry, resolved to its module set by Get-ModuleProfile, and the larger bundles hold every
      module of the smaller ones. The module is the folder under the automation track's root, so the infrastructure folders such as
      `.internal` count, and the fact names the bundle with the fewest modules that holds it: `minimal` for a core module, `full` for one
      only the full bundle ships. A file in no module of a bundle, such as a document or a pipeline, gets an empty value, so the key is left
      out of its head. The bundles are data in the exporter registry, never a list in this function
      ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)). The member lists are kept for as long as
      the exporter registry object is the same one.
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Kind: The registry entry that subscribed this function.
    outputs: '[System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.'
---
#>

function Get-CatzcBundleFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind reads the bundle by path alone')]
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $State,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.FileMetaKind] $Kind
    )

    $exporter = Get-Config -Config exporter
    # One resolved member list per bundle, smallest first, built once per exporter registry.
    $cachedFor = Get-Variable -Name bundleMembersFor -Scope Script -ValueOnly -ErrorAction Ignore
    if (-not [object]::ReferenceEquals($cachedFor, $exporter)) {
        $members = foreach ($name in $exporter.bundles.Keys) {
            [pscustomobject]@{ Name = $name; Modules = [string[]] @(Get-ModuleProfile -Name $exporter.bundles[$name].profile) }
        }
        $script:bundleMembers = @($members | Sort-Object { $_.Modules.Count })
        $script:bundleMembersFor = $exporter
    }

    $root = (Get-Track -Name automation).places[0]
    $value = ''
    $folder = [regex]::Match(($Path -replace '\\', '/'), '^' + [regex]::Escape($root) + '/(?<folder>[^/]+)/')
    if ($folder.Success) {
        foreach ($bundle in $script:bundleMembers) {
            if ($folder.Groups['folder'].Value -in $bundle.Modules) {
                $value = $bundle.Name
                break
            }
        }
    }
    [ordered]@{ $Kind.keys[0] = $value }
}
