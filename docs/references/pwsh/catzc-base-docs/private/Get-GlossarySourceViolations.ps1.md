# pwsh/Catzc.Base.Docs/private/Get-GlossarySourceViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the glossary facts that span more than one source (check G1, cross-source) — one message per violation.

### description

The GlossaryConfig type checks each source on its own when it loads; this checks what no single source can see
([ADR-REPO-VOCAB](../../../../adr/repository/controlled-vocabulary.md)):

- a term defined by two sources, or a machine key used by two

```text
([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1));
```

- a domain that adrs.yml does not declare

```text
([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1));
```

- an avoided phrase that is another source's term

```text
([ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5));
```

- a contrast or relation target that no source defines

```text
([ADR-REPO-VOCAB#3](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab3));
```

- a contrast that is not reciprocal — A contrasts B, but B does not contrast A

```text
([ADR-REPO-VOCAB#4](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab4));
```

- a source that git does not track

```text
([ADR-REPO-VOCAB#3](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab3)).
```

The first source in owner order keeps a duplicated term or key; every later one is reported. Each message starts with the repo-relative path
of the source it reports and names the term, so it points at the line to fix.

Private helper for the glossary checks; not exported.

### parameter `Source`

The glossary sources, as Get-GlossarySources returns them ({ Owner; Path; Config; Tracked }). Defaults to every source in the repository.

### outputs

`[string[]]` One message per violation, in source and concept order; empty when the sources agree.

### example 1

```powershell
Get-GlossarySourceViolations
```
