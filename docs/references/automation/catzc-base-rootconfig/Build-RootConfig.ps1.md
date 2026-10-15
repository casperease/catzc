---
catzc:
  derived:
    path: docs/references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md
    kind: comment-page
    body_sha: da9c3e178b6f
---

# automation/Catzc.Base.RootConfig/Build-RootConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:10

Above `$sourcePath = Resolve-RepoPath $entry.source`.

```text
A link entry skips content composition entirely: the target IS the source, verified or
(re)created as a filesystem link by the one mechanism owner (Set-FileLink, Catzc.Base.Files).
```

## comment:11

Above `foreach ($listed in $entry.sources) {`.

```text
A generator's rendered output (which owns its whole content below the head): one file, or one
record per file of a wildcard target.
```

## comment:12

Above `$item = Get-Item -LiteralPath $targetPath -Force -ErrorAction Ignore`.

```text
A target that is currently a LINK is stale regardless of content equality: a comment:none entry
flipped back from copyAsLink composes bytes identical to its source, which the compare would read
through the link and call current — leaving the link in place while the registry says copy.
```

## comment:13

Above `$changed = Write-FileIfChanged -Path $targetPath -Content $file.Content...`.

```text
Canonicalise, EOL-insensitively compare, and write-on-change via the one shared primitive
(Write-FileIfChanged, Catzc.Base.Files).
```
