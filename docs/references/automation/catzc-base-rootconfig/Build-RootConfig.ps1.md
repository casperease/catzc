---
catzc:
  immutable:
    with_body_sha: db6cee771e6d
    path: docs/references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md
    folder: docs/references/automation/catzc-base-rootconfig
    name: build-root-config-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.RootConfig/Build-RootConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$sourcePath = Resolve-RepoPath $entry.source`, written with `#`.

```text
A link entry skips content composition entirely: the target IS the source, verified or
(re)created as a filesystem link by the one mechanism owner (Set-FileLink, Catzc.Base.Files).
```

## comment:2

Above `foreach ($listed in $entry.sources) {`, written with `#`.

```text
A generator's rendered output (which owns its whole content below the head): one file, or one
record per file of a wildcard target.
```

## comment:3

Above `$item = Get-Item -LiteralPath $targetPath -Force -ErrorAction Ignore`, written with `#`.

```text
A target that is currently a LINK is stale regardless of content equality: a comment:none entry
flipped back from copyAsLink composes bytes identical to its source, which the compare would read
through the link and call current — leaving the link in place while the registry says copy.
```

## comment:4

Above `$changed = Write-FileIfChanged -Path $targetPath -Content $file.Content...`, written with `#`.

```text
Canonicalise, EOL-insensitively compare, and write-on-change via the one shared primitive
(Write-FileIfChanged, Catzc.Base.Files).
```
