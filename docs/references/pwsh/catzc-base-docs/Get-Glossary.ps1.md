# automation/pwsh/Catzc.Base.Docs/Get-Glossary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the controlled vocabulary: every concept of every glossary source, merged and sorted by term.

### description

Merges the opting-in modules' configs/glossary.yml sources (Get-GlossarySources,
[ADR-REPO-VOCAB-GLOSSARYSOURCE](../../../adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab-glossarysource)) into one list of
Catzc.Base.Docs.GlossaryEntry: each concept with the module that declares it, that source's repo-relative path, and the source's defaulted
options. Sorted by term (ordinal), so the result reads like a glossary and is stable across runs.

Each source is validated on load by its type; the facts that span more than one source — a term or key declared twice, a contrast that is
not reciprocal, a source git does not track — are not checked here. They belong to the glossary checks (Get-GlossarySourceViolations), so a
reader always gets the vocabulary as declared.

The result is cached for the session per repository root ([ADR-PWSH-CACHE](../../../adr/automation/pwsh/script-scope-caching.md)); re-run the importer
to pick up an edited glossary. Callers treat it as read-only (the same array is returned on every call).

### outputs

`[Catzc.Base.Docs.GlossaryEntry[]]` Empty when no module ships a glossary.

### example 1

```powershell
Get-Glossary | Format-Table { $_.Concept.term }, Owner, { $_.Concept.defined_by }
```

## comment:1

Above `$script:glossaryCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE-STRICTSAFEPROBE](/docs/adr/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe))
```
