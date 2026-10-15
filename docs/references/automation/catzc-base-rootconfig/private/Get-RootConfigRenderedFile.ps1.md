---
catzc:
  derived:
    path: docs/references/automation/catzc-base-rootconfig/private/Get-RootConfigRenderedFile.ps1.md
    kind: comment-page
    body_sha: "790a07dbe583"
---

# automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Calls the entry's generator through the dispatch (Invoke-RootConfigGenerator, passing the entry's target) and
normalises its output to records, so Build-RootConfig writes every generated file the same way and
Test-RootConfigFiles expands a wildcard entry into its files:

  - a single-file generator returns one string: the content of the entry's one target;
  - a multi-file generator returns { Target; Content } records (e.g. Catzc.Base.Languages.GoWorkspaceFile),
    each for one repository-relative path that must match the entry's target (case-sensitive wildcard
    match; a literal target matches only itself).

A wildcard target (go/tests/*/go.mod) needs records and may render none (no folder yet); a literal target
must render exactly one file. Any other shape throws, naming the entry and the generator. See
[ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
```
