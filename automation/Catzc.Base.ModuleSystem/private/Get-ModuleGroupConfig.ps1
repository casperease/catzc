<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/private/Get-ModuleGroupConfig.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.ModuleSystem/tests/Get-ModuleGroupConfig.Tests.ps1
  config:
    synopsis: Returns the declared module GROUPS from configs/dependencies.yml.
    description: |-
      A group is a named set of on-disk modules with its own internal dependency DAG — a concept,
      not a disk module. A consumer module's allowed-deps list may name a group (which permits an
      edge to any member) and/or a specific module. The group's member->member map is the layering
      contract that an ex-monolith enforced "inside one module".

      Loads the optional top-level 'groups' map via Get-Config (same parse + validation +
      session cache as Get-ModuleDependencyConfig) and projects each Catzc.Base.ModuleSystem.ModuleGroup
      to its member map. The returned object is an ordered dictionary: group name -> (read-only ordered
      dictionary: member module -> list of members it may depend on). A file with no 'groups' key
      returns an empty ordered dictionary (groups are optional).
    examples:
      - (Get-ModuleGroupConfig)['Base']['Catzc.Base.Writers']
---
#>

function Get-ModuleGroupConfig {
    param()

    $groups = [ordered]@{}
    foreach ($group in (Get-Config -Config dependencies).groups.Values) {
        $groups[$group.name] = $group.members
    }
    $groups
}
