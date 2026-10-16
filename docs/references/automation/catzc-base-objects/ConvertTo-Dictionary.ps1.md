---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/ConvertTo-Dictionary.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "6bd79eff9796"
---

# automation/Catzc.Base.Objects/ConvertTo-Dictionary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$dict = ConvertTo-YamlSafe -Value $InputObject -MaxDepth $MaxDepth`, written with `#`.

```text
ConvertTo-YamlSafe is the shared recursive reflector — it already turns any object (typed class,
PSCustomObject, dictionary, array) into nested ordered dicts / arrays / scalars via
PSObject.Properties. We reuse it for the dictionary form, then optionally re-shape to PSCustomObjects.
```
