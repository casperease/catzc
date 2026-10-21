# pwsh/Catzc.Base.CodeMeta/types/CommentPageMap.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One entry of comment-pages.yml's `pages:` list: which docs folder holds the comment pages of the files under a source
folder. A comment page is the one living copy of a file's long comments
([ADR-PRIN-ONELIVE-ONEVERSION](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive-oneversion)); the pages live under
docs/references like every other authored source
([ADR-REPO-README-AUTHOREDSOURCES](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme-authoredsources)).
  source — a repository-relative folder (`pipelines`), or `<prefix>/*` for each immediate, non-dot-prefixed
           subfolder of the prefix (`pwsh/*`), the same convention readme.yml uses
  docs   — the docs folder the pages go under, starting with `docs/`; with a `/*` source it may carry `{kebab}`,
           the matched subfolder's leaf name lowercased with dots turned to hyphens
           (pwsh/Catzc.Base.QualityGates -> catzc-base-qualitygates)
The page of a file is `<docs>/<path relative to the matched folder>.md`, so
pwsh/Catzc.Base.QualityGates/private/Get-FormatScope.ps1 ->
docs/references/pwsh/catzc-base-qualitygates/private/Get-FormatScope.ps1.md: the extension stays in the name,
so a page maps back to exactly one file. Property names mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
```
