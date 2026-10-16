---
catzc:
  immutable:
    with_body_sha: "17736e91a36c"
    repo_status: locked
    path: docs/references/automation/catzc-azure-devops/types/AdoConfig.cs.md
    folder: docs/references/automation/catzc-azure-devops/types
    name: ado-config-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Azure.DevOps/types/AdoConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The Azure DevOps coupling (configs/ado.yml): the data that binds this repo to one ADO organization and the
Entra (Azure AD) tenant behind it — the single source of truth for which org/tenant is the *correct* thing to
be connected to. Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Azure.DevOps.AdoConfig), so
Get-Config -Config ado returns this typed record. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  organization  required; the org REST URL (https://dev.azure.com/<org> or https://<org>.visualstudio.com)
  project       required, non-empty; the default project (may be URL-encoded)
  tenant        required; the Entra tenant GUID backing the org — the directory every auth path must be
                proven to target before Get-AdoAuthorizationHeader returns a header
and no other key (a non-snake_case or misspelled key fails fast at load).
```
