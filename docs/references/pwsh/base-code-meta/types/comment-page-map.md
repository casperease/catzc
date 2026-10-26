# pwsh/Base.CodeMeta/types/CommentPageMap.cs

One entry of `comment-pages.yml`'s `pages:` list: which docs folder holds the comment pages of the files under a source folder. A comment
page is the one living copy of a file's long comments
([PDR-ONELIVE-ONEVERSION](../../../../drs/principles/one-living-version.md#rule-pdr-onelive-oneversion)); the pages live under
`docs/references` like every other authored source
([ADR-REPO-README-AUTHOREDSOURCES](../../../../drs/repository/generated-readmes.md#rule-adr-repo-readme-authoredsources)). Property names
mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Properties

- **`source`** — a repository-relative folder (`.ado/pipelines`), or `<prefix>/*` for each immediate, non-dot-prefixed subfolder of the
  prefix (`pwsh/*`), the same convention `readme.yml` uses. A hidden folder needs an entry of its own to have pages.
- **`docs`** — the plain docs folder the pages go under, starting with `docs/`.

## Validation

Constructing the entry rejects an unknown key, a missing `source` or `docs`, a path with a backslash or a leading or trailing slash, a
pattern other than a trailing `/*` in `source`, a `docs` outside `docs/`, and a `docs` that holds a pattern or a brace.

## The page of a file

The page of a file is `<docs>/[<module>/][<aspect path>/]<file>.md`, every part in the normal form, so
`pwsh/Base.QualityGates/private/Get-FormatScope.ps1` has the page `docs/references/pwsh/base-quality-gates/private/get-format-scope.md`. A
folder or module name is rendered in the kebab case, so a namespace never appears in a folder. The file name drops its trailing language
extension and its `.Tests` role and keeps an inner part, so `Get-OutputRoot.OutputOnlyByAddress.Tests.ps1` is
`get-output-root-output-only-by-address`. A module's article is `<docs>/<module>/index.md`. A file directly under the prefix, or under a
dot-prefixed folder, has no page from a `/*` entry.
