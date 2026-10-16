<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Get-ManagedGuids.ps1
    name: get-managed-guids
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  config:
    synopsis: Returns the managed-GUID registry entries — the named GUIDs the repository is allowed to carry.
    description: |-
      Thin accessor over Get-Config -Config guids (mapped and validated by the GuidsConfig type on load,
      session-cached). The returned map is read-only. Each entry is name -> ManagedGuidEntry
      { guid, description [, sentence] }; `sentence` is set when the GUID was minted from a sentence with
      ConvertTo-Guid.
    outputs: |-
      [System.Collections.Specialized.OrderedDictionary] entry-name -> entry (empty when the registry has no
      entries).
    examples:
      - Get-ManagedGuids
---
#>

function Get-ManagedGuids {
    [CmdletBinding()]
    param()

    (Get-Config -Config guids).guids
}
