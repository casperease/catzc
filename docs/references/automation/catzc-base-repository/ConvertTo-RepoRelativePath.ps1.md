---
catzc:
  immutable:
    with_body_sha: "6a672e92a9c6"
    repo_status: locked
    path: docs/references/automation/catzc-base-repository/ConvertTo-RepoRelativePath.ps1.md
    folder: docs/references/automation/catzc-base-repository
    name: convert-to-repo-relative-path-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Normalizes a path to its communication form: out/-anchored, then repo-root-relative, else absolute.

### description

The "relative-where-possible" normalization for paths kept in records, configs, and long-lived information
([ADR-AUTO-PATH](../../../adr/automation/path-representation.md)). It picks the anchor in order:

1. Under the OUTPUT root (Get-OutputRoot) -> '`out/<remainder>`' (forward slashes). The output root is
   context-dependent ({root}/out on a devbox, the external staging directory in a pipeline), so the
   reserved 'out/' sentinel keeps an output artifact portable across the build->deploy boundary:
   Resolve-RepoPath re-anchors it via Get-OutputRoot at the other end. A pipeline artifact that
   would otherwise have no repo-relative form (it lives outside the repo) is captured here.
2. Under the REPOSITORY root (Get-RepositoryRoot) -> a plain repo-relative path (forward slashes).
3. Under neither -> returned absolute (normalized). No repo/out-relative form exists; degrade
   honestly
   ([ADR-AUTO-PATH#5](../../../adr/automation/path-representation.md#rule-adr-auto-path5)) rather than emit a hybrid.

Pairs with Resolve-RepoPath, which turns the result back into an absolute path against the matching
root.

### parameter Path

The path to normalize. Need not exist.

### example 1

```powershell
ConvertTo-RepoRelativePath 'C:\repo\catzc\out\template\sample\main.json'   # -> out/template/sample/main.json
```

### example 2

```powershell
ConvertTo-RepoRelativePath 'C:\repo\catzc\automation\mod\file.ps1'         # -> automation/mod/file.ps1
```

### example 3

```powershell
ConvertTo-RepoRelativePath 'D:\a\1\ws\sample\main.json'                   # outside both roots -> unchanged (absolute)
```

## comment:1

Above `$outputRoot = [IO.Path]::GetFullPath((Get-OutputRoot))`, written with `#`.

```text
1. Prefer the reserved output anchor — an output artifact stays portable as 'out/...' even when the
   output root sits outside the repo (a pipeline's staging area), where no repo-relative form exists.
```
