---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository/ConvertTo-RepoRelativePath.ps1.md
    kind: comment-page
    body_sha: "6a600fbe96b9"
    adrs:
      - ADR-AUTO-PATH#5
---

# automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The "relative-where-possible" normalization for paths kept in records, configs, and long-lived information
([ADR-AUTO-PATH](/docs/adr/automation/path-representation.md)). It picks the anchor in order:

  1. Under the OUTPUT root (Get-OutputRoot) -> 'out/<remainder>' (forward slashes). The output root is
     context-dependent ({root}/out on a devbox, the external staging directory in a pipeline), so the
     reserved 'out/' sentinel keeps an output artifact portable across the build->deploy boundary:
     Resolve-RepoPath re-anchors it via Get-OutputRoot at the other end. A pipeline artifact that
     would otherwise have no repo-relative form (it lives outside the repo) is captured here.
  2. Under the REPOSITORY root (Get-RepositoryRoot) -> a plain repo-relative path (forward slashes).
  3. Under neither -> returned absolute (normalized). No repo/out-relative form exists; degrade
     honestly
     ([ADR-AUTO-PATH#5](/docs/adr/automation/path-representation.md#rule-adr-auto-path5)) rather than emit a hybrid.

Pairs with Resolve-RepoPath, which turns the result back into an absolute path against the matching
root.
```

## comment:2

Above `$outputRoot = [IO.Path]::GetFullPath((Get-OutputRoot))`.

```text
1. Prefer the reserved output anchor — an output artifact stays portable as 'out/...' even when the
   output root sits outside the repo (a pipeline's staging area), where no repo-relative form exists.
```

## comment:3

Above `$outputRoot = [IO.Path]::GetFullPath((Get-OutputRoot))`.

```text
1. Prefer the reserved output anchor — an output artifact stays portable as 'out/...' even when the
   output root sits outside the repo (a pipeline's staging area), where no repo-relative form exists.
```
