---
catzc:
  edges:
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-REPO-FILEMETA-METAKIND
---

# pwsh/Catzc.Base.QualityGates/configs/file-meta.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `kinds:`, written with `#`.

```text
The meta-kind registry: each entry is one kind of derived fact imprinted into a file's meta block, with defaults on FileMetaKind.
[ADR-REPO-FILEMETA-METAKIND](/docs/drs/repository/file-meta.md#rule-adr-repo-filemeta-metakind),
[ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)
```

## comment:3

Above `drs-codes:`, written with `#`.

```text
The ADR codes the file cites, its comment page's too, sorted and without duplicates, less the rules it defines; a long key, so late.
A file of a code class (domain_classes) also lists the bare domain codes.
```

## comment:4

Above `kinds:`, written with `#`.

```text
A meta kind selects files by their file kind (a kind, or kind/subkind, of the file-kinds registry) and language, never by glob; with no
select it applies to every file that carries a head.
```

## comment:5

Above `relative-edges:`, written with `#`.

```text
The one file a file is bound to by a relation that costs to derive: the page its comments live on, under its docs section. A page knows
its code by its name, so it records no edge back, and a test is found by convention, so neither carries an edge. It is written only when
the page exists.
```
