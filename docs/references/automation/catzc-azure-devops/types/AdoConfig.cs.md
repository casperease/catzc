---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/types/AdoConfig.cs.md
    kind: comment-page
    body_sha: "327280ee7de3"
    adrs:
      - ADR-AUTO-TYPES#8
    links: []
---

# automation/Catzc.Azure.DevOps/types/AdoConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

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
