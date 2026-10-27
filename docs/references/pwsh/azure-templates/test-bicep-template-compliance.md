# pwsh/Azure.Templates/Test-BicepTemplateCompliance.ps1

The gate that holds every compiled template slot to the landing-zone rules, with each value read as the slot resolves it, and an expression
it cannot resolve reported rather than passed.

## help

### synopsis

Checks the CAF tags, diagnostic settings, public network access, TLS minimum and, in production, the availability zone redundancy of every compiled template slot.

### description

Builds each template (Build-Bicep), then walks its main.json for every slot with that slot's compiled parameters: nested deployments take
the parameters their parent passes and their own defaults, and a resource whose condition is false or that is `existing` is skipped. Each
deployed resource whose type is not in untaggable_types must carry tags that hold to the tag schema of azure.yml; each resource kind in
diagnostic_types needs a diagnostic setting scoped to it; a public-access property must not resolve to Enabled; a TLS-minimum property must
resolve to 1.2 or above; and on a production slot a zone-redundancy property must resolve to true. Values are evaluated by the ArmExpression
subset (parameters, equals, and, or, not, if, empty, contains, createArray); anything outside it is a finding that the value does not
resolve, never a pass. The rules are template-compliance.yml, defaults on TemplateComplianceConfig; its known_findings list is a ratchet the
real-templates test holds the gate to, each entry naming the plan step that closes it.

### parameter `Template`

The templates to check. Defaults to every shipped template.

### parameter `Config`

The compliance rules. Defaults to template-compliance.yml.

### parameter `TagSchema`

The tag schema the tags are held to. Defaults to the tags section of azure.yml.

### parameter `OutputFolder`

Where the gate report is written. Defaults to the shared report folder.

### parameter `PassThru`

Return the gate result instead of throwing on issues.

### example 1

```powershell
Test-BicepTemplateCompliance -Template expedition -PassThru
```
