---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/configs/file-meta.yml.md
    folder: docs/references/automation/catzc-base-qualitygates/configs
    name: file-meta-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "0532a409c074"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-FILEMETA#2
---

# automation/Catzc.Base.QualityGates/configs/file-meta.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `kinds:`, written with `#`.

```text
The meta-kind registry: each entry is one kind of derived fact imprinted into a file's meta block, with defaults on FileMetaKind.
[ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2),
[ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
```

## comment:3

Above `adr-codes:`, written with `#`.

```text
The ADR codes the file cites, its comment page's too, sorted and without duplicates, less the rules it defines; a long key, so late.
A code file also lists the bare domain codes.
```

## comment:4

Above `kinds:`, written with `#`.

```text
A meta kind selects files by their file kind (a kind, or kind/subkind, of the file-kinds registry) and language, never by glob; with no
select it applies to every file that carries a head.
```

## comment:5

Above `relatives:`, written with `#`.

```text
The two files a code file is bound to by a relation that costs to derive and defines it: the page its comments live on, and the test
that proves it. Each path stays in the file's own module or its docs section, never in another module, and only the code side points: a
test or a page knows its code by its name, so no pair is recorded twice. One is written only when its file exists.
```
