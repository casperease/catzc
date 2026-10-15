# docs/references/automation/catzc-base-docs/Get-Glossary.ps1.md

`automation/Catzc.Base.Docs/Get-Glossary.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Merges the opting-in modules' configs/glossary.yml sources (Get-GlossarySources,
[ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)) into one
list of Catzc.Base.Docs.GlossaryEntry: each concept with the module that declares it, that source's
repo-relative path, and the source's defaulted options. Sorted by term (ordinal), so the result reads like a
glossary and is stable across runs.

Each source is validated on load by its type; the facts that span more than one source — a term or key
declared twice, a contrast that is not reciprocal, a source git does not track — are not checked here. They
belong to the glossary checks (Get-GlossarySourceViolations), so a reader always gets the vocabulary as
declared.

The result is cached for the session per repository root
([ADR-PWSH-CACHE](/docs/adr/pwsh/script-scope-caching.md)); re-run the importer to pick up
an edited glossary. Callers treat it as read-only (the same array is returned on every call).
```

## comment:2

Above `$script:glossaryCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
