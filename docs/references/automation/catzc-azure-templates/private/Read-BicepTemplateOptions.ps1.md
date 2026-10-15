---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Read-BicepTemplateOptions.ps1.md
    kind: reference
    body_sha: "6b71c6729bba"
    adrs: []
---

# automation/Catzc.Azure.Templates/private/Read-BicepTemplateOptions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Each template folder under `infrastructure/templates/<name>/` MAY carry an `options.yml` beside
`main.bicep` declaring how the template deploys:

    short_name: smpl                  # 2-5 lowercase alnum — OVERRIDES the folder-derived Azure id segment
    deployment_mode: Incremental      # Incremental | Complete | DoNotRun
    deployment_target: Subscription   # ResourceGroup | Subscription
    environment_kind: subscription    # standard | subscription
    customer_deployment: true         # bool — is this a customer template? (defaults to the have_customers variant)

Every key is OPTIONAL — the file itself is optional (Read-BicepTemplateOptions just validates what is
present). `short_name` here is a pure OVERRIDE: with no options.yml (or no `short_name` key) the template's
short_name is DERIVED from its folder name by `Get-BicepTemplates` ([BicepShortName]::Resolve) and checked
for global uniqueness. An absent file (or an absent key) leaves the caller's default in place;
`Get-BicepTemplates` overlays the returned keys onto each template's descriptor, replacing the hardcoded
`Incremental` / `ResourceGroup` defaults.

The schema is STRICT: any key other than the allowed set (`short_name` / `deployment_mode` /
`deployment_target` / `environment_kind` / `customer_deployment`), or any value outside the matching
enum / format / type, throws — so a typo fails fast at discovery time rather than silently doing nothing.

Returns an ordered dictionary containing ONLY the keys present in the file (empty when the
file is absent or carries no recognised keys).
```
