# pwsh/Base.Repository/ConvertTo-RepoRelativePath.ps1

The normalization that turns a path into its communication form for records and configs: `out/`-anchored, else repository-relative, else
absolute. `Resolve-RepoPath` is its inverse.

## help

### synopsis

Normalizes a path to its communication form: out/-anchored, then repo-root-relative, else absolute.

### description

The "relative-where-possible" normalization for paths kept in records, configs, and long-lived information
([ADR-AUTO-PATH](../../../drs/automation/path-representation.md)). It picks the anchor in order:

1. Under the OUTPUT root (Get-OutputRoot) -> '`out/<remainder>`' (forward slashes). The output root is context-dependent ({root}/out on a
   devbox, the external staging directory in a pipeline), so the reserved 'out/' sentinel keeps an output artifact portable across the
   build->deploy boundary: Resolve-RepoPath re-anchors it via Get-OutputRoot at the other end. A pipeline artifact that would otherwise have
   no repo-relative form (it lives outside the repo) is captured here.
2. Under the REPOSITORY root (Get-RepositoryRoot) -> a plain repo-relative path (forward slashes).
3. Under neither -> returned absolute (normalized). No repo/out-relative form exists; degrade honestly
   ([ADR-AUTO-PATH-FOREIGNPATHS](../../../drs/automation/path-representation.md#rule-adr-auto-path-foreignpaths)) rather than emit a hybrid.

Pairs with Resolve-RepoPath, which turns the result back into an absolute path against the matching root.

### parameter `Path`

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

## Why the output anchor wins first

The reserved `out/` anchor is tried before the repository root. An output artifact stays portable as `out/...` even when the output root
sits outside the repository, as a pipeline's staging area does, where no repository-relative form exists.
