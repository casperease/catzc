# docs/references/automation/catzc-tooling-inspiration/private/Resolve-InspirationRoot.ps1.md

`automation/Catzc.Tooling.Inspiration/private/Resolve-InspirationRoot.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
An inspiration's root is stored in communication form
([ADR-AUTO-PATH#6](/docs/adr/automation/path-representation.md#rule-adr-auto-path6)) and resolved only at the point
of use ([ADR-AUTO-PATH#3](/docs/adr/automation/path-representation.md#rule-adr-auto-path3)):

  - '{workspace}/<folder>' resolves against the workspace, the parent folder of the repository root
    ([ADR-AUTO-PATH#11](/docs/adr/automation/path-representation.md#rule-adr-auto-path11));
  - any other path goes through Resolve-RepoPath, so a repository-relative root resolves against the repository
    root and an absolute one passes through.

Both pwsh's and Git Bash's view of a path resolve the same: the repository root, or an absolute root, given as
'/c/projects/...' on Windows is read as 'C:/projects/...' (InspirationRoot.ToNative). The result is normalized
with [IO.Path]::GetFullPath, so it is in the platform's own form.
```
