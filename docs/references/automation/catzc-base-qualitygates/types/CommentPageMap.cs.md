---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/CommentPageMap.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "5cad299b80d8"
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-README#7
---

# automation/Catzc.Base.QualityGates/types/CommentPageMap.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One entry of comments.yml's `pages:` list: which docs folder holds the comment pages of the files under a source
folder. A comment page is the one living copy of a file's long comments
([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)); the pages live under
docs/references like every other authored source
([ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7)).
  source — a repository-relative folder (`pipelines`), or `<prefix>/*` for each immediate, non-dot-prefixed
           subfolder of the prefix (`automation/*`), the same convention readme.yml uses
  docs   — the docs folder the pages go under, starting with `docs/`; with a `/*` source it may carry `{kebab}`,
           the matched subfolder's leaf name lowercased with dots turned to hyphens
           (automation/Catzc.Base.QualityGates -> catzc-base-qualitygates)
The page of a file is `<docs>/<path relative to the matched folder>.md`, so
automation/Catzc.Base.QualityGates/private/Get-FormatScope.ps1 ->
docs/references/automation/catzc-base-qualitygates/private/Get-FormatScope.ps1.md: the extension stays in the name,
so a page maps back to exactly one file. Property names mirror the YAML keys
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
