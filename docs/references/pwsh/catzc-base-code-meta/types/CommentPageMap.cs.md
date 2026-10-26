# pwsh/Base.CodeMeta/types/CommentPageMap.cs

One entry of `comment-pages.yml`'s `pages:` list: which docs folder holds the comment pages of the files under a source folder. A comment
page is the one living copy of a file's long comments
([PDR-ONELIVE-ONEVERSION](../../../../drs/principles/one-living-version.md#rule-pdr-onelive-oneversion)); the pages live under
`docs/references` like every other authored source
([ADR-REPO-README-AUTHOREDSOURCES](../../../../drs/repository/generated-readmes.md#rule-adr-repo-readme-authoredsources)). Property names
mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Properties

- **`source`** — a repository-relative folder (`pipelines`), or `<prefix>/*` for each immediate, non-dot-prefixed subfolder of the prefix
  (`pwsh/*`), the same convention `readme.yml` uses.
- **`docs`** — the docs folder the pages go under, starting with `docs/`. With a `/*` source it may carry `{kebab}`, the matched module's
  name rendered in the kebab case of `NameCase` (`pwsh/Base.QualityGates` becomes `catzc-base-quality-gates`).

## Validation

Constructing the entry rejects an unknown key, a missing `source` or `docs`, a path with a backslash or a leading or trailing slash, a
pattern other than a trailing `/*` in `source`, a `docs` outside `docs/` or holding a pattern, and a `{kebab}` without a `/*` source.

## The page of a file

The page of a file is `<docs>/<path relative to the matched folder>.md`, so
`pwsh/Base.QualityGates/private/Get-FormatScope.ps1` has the page
`docs/references/pwsh/catzc-base-quality-gates/private/Get-FormatScope.ps1.md`. The extension stays in the name, so a page maps back to
exactly one file. A file directly under the prefix, or under a dot-prefixed folder, has no page from a `/*` entry.
