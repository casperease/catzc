# pwsh/Catzc.Base.Docs/private/Get-GlossarySourceViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the glossary facts that span more than one source (check G1, cross-source) — one message per violation.

### description

The GlossaryConfig type checks each source on its own when it loads; this checks what no single source can see
([ADR-REPO-VOCAB](../../../../drs/repository/controlled-vocabulary.md)):

- a term defined by two sources, or a machine key used by two

```text
([ADR-REPO-VOCAB-DEFINEDTERM](/docs/drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-definedterm));
```

- a domain that drs.yml does not declare

```text
([ADR-REPO-VOCAB-DEFINEDTERM](/docs/drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-definedterm));
```

- a defined_by that is not a rule's code under the drs.yml kinds — the GlossaryConfig type checks only its shape, and the registry decides
  how many segments a rule's code has after its kind, so an ADR's code is reported here

```text
([ADR-REPO-DRSCODE-NAMEDNOTNUMBERED](/docs/drs/repository/drs-code-language.md#rule-adr-repo-drscode-namednotnumbered));
```

- an avoided phrase that is another source's term

```text
([ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED](/docs/drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-avoidedphrasingreplaced));
```

- a contrast or relation target that no source defines

```text
([ADR-REPO-VOCAB-SOURCESINREPOSITORY](/docs/drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-sourcesinrepository));
```

- a contrast declared on both terms — A contrasts B and B contrasts A; a contrast is declared once, the build shows it on both entries, and
  the second declaration of the pair is the finding

```text
([ADR-REPO-VOCAB-SIMILARTERMSCONTRASTED](/docs/drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-similartermscontrasted));
```

- a source that git does not track

```text
([ADR-REPO-VOCAB-SOURCESINREPOSITORY](/docs/drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-sourcesinrepository)).
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

## comment:1

Above `elseif ($termConcept[$other].contrasts.ContainsKey($term) -and -not...`, written with `#`.

```text
A contrast is declared once and the build shows it on both entries; the second declaration of a pair
is the finding.
```
