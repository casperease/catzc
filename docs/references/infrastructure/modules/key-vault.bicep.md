---
catzc:
  derived:
    path: docs/references/infrastructure/modules/key-vault.bicep.md
    kind: comment-page
    body_sha: "5deebb21501a"
---

# infrastructure/modules/key-vault.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('Key vault name (3-24 alphanumeric/hyphen, starts with a letter,...`.

```text
Reusable bicep module: a Key Vault (RBAC-authorized, no access policies). Templates reference it
with a relative `module` declaration (../../modules/key-vault.bicep) and `az bicep build` inlines
it into the template's main.json.
```
