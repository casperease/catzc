# pwsh/Azure.Templates/Get-BicepRoleAssignmentPlan.ps1

The review of who gets which role where. The templates assign built-in roles to groups and managed identities
([ADR-AZ-LZ-CAFIDENTITY](../../../drs/azure/landing-zones.md#rule-adr-az-lz-cafidentity)), spread over modules, loops and conditions; this
command lists the assignments every slot makes, read from the compiled templates, so the stacked set is reviewed in one table before a
deploy and an L1 test pins each slot's set.

## help

### synopsis

Lists the role assignments of the compiled templates, one per template, slot, principal, role and scope, read offline.

### description

Reads each template as `Build-Bicep` compiled it, `<OutputRoot>/<template>/main.json` with each slot's parameters file, and evaluates its
resources with the slot's parameter values offline, as the template-compliance quality gate does (`Get-ArmDeployedResource`), sent to the
slot's azure.yml subscription and resource group, so a resource id resolves exactly or not at all. Every evaluated
`Microsoft.Authorization/roleAssignments` becomes one `BicepRoleAssignment`: the template, the slot's coordinate (customer, environment and
slot joined by `.`), the principal's object id, the role by its `roles.yml` name (its definition id when `roles.yml` names none), the scope
and the attribute-based condition. The scope is `subscription` or `resourceGroup` for an assignment on the scope its template deploys to,
and `<provider>/<type>/<name>` for one on a single resource, its id less the subscription and group. An assignment whose condition does not
resolve offline is not listed and is named in a message; a value that does not resolve, such as a principal read from another deployment's
output, is the empty string. A template with no compiled `main.json` fails, naming the `Build-Bicep` call that compiles it.

### parameter `Template`

The templates to list; every template when omitted.

### parameter `OutputRoot`

The folder holding the compiled templates, one subfolder per template; the build output root by default.

### example 1

```powershell
Get-BicepRoleAssignmentPlan discovery | Format-Table slot, principal, role, scope
```

### example 2

```powershell
Get-BicepRoleAssignmentPlan | Where-Object condition | Format-List
```
