<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-module-system/private/Get-ModuleGroupConfig.ps1.md"
  header: "generated"
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
