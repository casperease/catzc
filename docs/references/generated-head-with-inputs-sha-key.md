# The `with_inputs_sha` key of a generated-file head: what it said, and why nothing replaces it

## What the key said

A generator that skipped an unchanged build wrote a second hash into the head of the file it generated, after `with_body_sha`:

```yaml
catzc:
  immutable:
    with_body_sha: fdcdabe91e35
    with_inputs_sha: "791b2b36762f09b2a6d46d37e4ded89f285266a6b645fc02b701229748e78e56"
```

It was an inputs stamp: one SHA-256 over the generator's input files (`Get-InputStamp`), written by `Format-GeneratedFileHead -InputsSha`.
On the next run, `Test-GeneratedFileCurrent` read the stamp back and returned early when it still matched, so the generator did not render
at all. Five generators wrote it: `Build-Glossary`, `Build-DrsIndex`, `Build-DrsCodeDictionary`, `Build-TerminologyDictionary` and
`Build-ContractReference`. Its place in the head's key order came from `generated-head.yml` (`keys:`), and
`contracts/catzc/0.0.0/catzc.base.quality_gates/head.schema.json` admitted it.

## Why it goes

It was a cache key committed into tracked files. An edit to any input, an ADR or a type, changed the stamp while the generated body stayed
identical, so `docs/drs/glossary.md` and `docs/drs/index.md` changed their heads in commits that changed no fact. That breaks
[ADR-REPO-FILEMETA-IMPRINTEDPARTS](../drs/repository/file-meta.md#rule-adr-repo-filemeta-imprintedparts): a hash belongs in a head only when
it changes exactly when something a reader cares about changes. The skip it enabled bought little, because generated files are regenerated
often (the user, 2026-10-19).

## What replaces it

Nothing. A generator always renders and lets `Write-FileIfChanged` decide whether the file changes, and `with_body_sha` is the one currency
fact a generated head carries. No gitignored companion cache takes the stamp's place, and `Test-GeneratedFileCurrent` is deleted whole
([one-living-version](../drs/principles/one-living-version.md)). `Get-InputStamp` stays for its remaining caller, the root-config inputs
stamp of `Catzc.Base.RootConfig`. `ADR-REPO-FILEMETA-IMPRINTEDPARTS` absorbs this page when it is next restated.
