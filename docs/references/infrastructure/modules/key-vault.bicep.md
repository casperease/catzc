---
catzc:
  immutable:
    with_body_sha: d16317b818b8
    repo_status: locked
    path: docs/references/infrastructure/modules/key-vault.bicep.md
    folder: docs/references/infrastructure/modules
    name: key-vault-bicep
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/modules/key-vault.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `@description('Key vault name (3-24 alphanumeric/hyphen, starts with a letter,...`, written with `//`.

```text
Reusable bicep module: a Key Vault (RBAC-authorized, no access policies). Templates reference it
with a relative `module` declaration (../../modules/key-vault.bicep) and `az bicep build` inlines
it into the template's main.json.
```
