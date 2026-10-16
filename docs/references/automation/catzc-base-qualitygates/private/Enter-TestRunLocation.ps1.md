---
catzc:
  immutable:
    with_body_sha: fcca4c9c5e1b
    path: docs/references/automation/catzc-base-qualitygates/private/Enter-TestRunLocation.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: enter-test-run-location-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-CACHE#10
      - ADR-AUTO-ENGINE#2
---

# automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$sourceCache = Join-Path (Get-OutputRoot) 'cache'`, written with `#`.

```text
The snapshot starts with the working folder's quality-check result caches (out/cache), which it would not
otherwise carry: each entry is keyed on a file's content and the stamps of the check's inputs
([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)), so it holds in a copy of the same
tree and a file the snapshot changed is simply a new key. Without them every snapshot run would format and
analyse every file from cold. The snapshot's own updates stay in the snapshot.
```

## comment:2

Above `Write-Message 'Priming the snapshot: one import materialises its generated...`, written with `#`.

```text
Prime the snapshot with one full import, as a fresh clone's first import does: the janitors materialise
the generated, gitignored files the snapshot does not carry (module manifests, READMEs, root configs,
cspell dictionaries), once, before any worker starts — workers import with -SkipJanitors and would
otherwise find them missing, or race each other generating manifests. The snapshot is never committed to:
Sync-GeneratedFile recognises it by its provenance marker (Test-RepositorySnapshot).
Non-interactive, from the engine model
([ADR-AUTO-ENGINE#2](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine2)): no person can answer a
prompt here, so one fails at
once instead of waiting out the time limit.
```
