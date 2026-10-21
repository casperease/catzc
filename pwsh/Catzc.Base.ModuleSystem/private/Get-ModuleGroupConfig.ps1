<#
---
catzc:
  immutable:
    with_body_sha: "379aaaae4fc9"
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/Get-ModuleGroupConfig.Tests.ps1
    docs: "[Get-ModuleGroupConfig.ps1.md](docs/references/pwsh/catzc-base-module-system/private/Get-ModuleGroupConfig.ps1.md)"
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
