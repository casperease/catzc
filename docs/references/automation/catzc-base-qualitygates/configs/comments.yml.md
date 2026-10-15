---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/configs/comments.yml.md
    kind: comment-page
    body_sha: "48783500490c"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-CODEMETA#5
      - ADR-REPO-OUTDIR#1
---

# automation/Catzc.Base.QualityGates/configs/comments.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `languages: [powershell, yaml, pipeline-yaml, csharp, bicep]`.

```text
Comment-page settings for Export-Comments / Format-Comments / Build-CommentView / Test-Comments.

A file carries one line per comment — the insight, the ADR citations, and a link — and the prose lives in the
file's comment page under docs/references, so each has exactly one living copy
([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)). Every key is optional:
an omitted key takes the sensible default declared once on Catzc.Base.QualityGates.CommentsConfig
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). The comment syntax of
each language is CommentLexer's, the one place that knows it; this file decides what moves and where it goes
([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
```

## comment:2

Above `languages: [powershell, yaml, pipeline-yaml, csharp, bicep]`.

```text
The file languages (languages.yml names) whose files carry comment pages. A language CommentLexer cannot read
(python, bash) is out until the lexer learns it. Default: powershell, yaml, pipeline-yaml, csharp, bicep.
```

## comment:3

Above `keep:`.

```text
Per language, the comment lines that never move: a prefix of a trimmed comment line (marker included for a line
comment), which stays in place wherever it sits in a run and splits the run around it, or a comment-based help
keyword naming a section whose body stays whole. A language listed here replaces its default list; an unlisted
language keeps the default. Tool directives (`cspell:`) stay with the code they govern.
```

## comment:4

Above `pages:`.

```text
Where a file's comment page lives, first match wins. `source` is a folder, or `<prefix>/*` for each immediate
subfolder of the prefix (dot-prefixed folders never match, so .vendor is out and .scriptanalyzer and .internal are
listed by name); `docs` is the
folder under docs/ the pages go under, and with a `/*` source `{kebab}` is the matched subfolder's leaf name,
lowercased with dots turned to hyphens. The page keeps the file's name and extension plus `.md`
(automation/Catzc.Base.QualityGates/Format-Code.ps1 -> docs/references/automation/catzc-base-qualitygates/Format-Code.ps1.md).
```

## comment:5

Above `exclude:`.

```text
Files that keep their comments: repository-relative glob (the durable-sha-globs dialect) -> why. An asset is copied or
published verbatim elsewhere (a root-config template, the hook's C# source, a standalone script), where a residue's docs link
would be foreign. A test is not listed, so its prose moves to a comment page like any other file's. Listing this key replaces
the default map, so only the asset entry is kept.
```

## comment:6

Above `view: out/annotated`.

```text
The gitignored folder, under out/, Build-CommentView writes the annotated view to
([ADR-REPO-OUTDIR#1](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir1)).
```

## comment:7

Above `keep_run:`.

```text
A head listed here keeps the whole run of comment lines it opens, which is how the meta head stays in the file.
[ADR-REPO-CODEMETA#5](/docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta5)
```
