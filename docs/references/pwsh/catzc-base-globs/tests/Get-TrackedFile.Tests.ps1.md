# pwsh/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-TrackedFile'`, written with `#`.

```text
The matching universe ([FDR-CD-GLOBS-TRACKEDFILESONLY](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)): tracked
files as `git ls-files` defines them, repo-relative — answered by Get-GitTrackedPath for the whole repository.
```

## comment:2

Above `Describe 'Get-TrackedFile (real index)'`, written with `#`.

```text
The real universe: this repository's own tracked files come back repo-relative with forward slashes,
including this test file — read in-process from the real index, so no git process runs.
```

## comment:3

Above `$files = @(InModuleScope Catzc.Base.Globs { Get-TrackedFile })`, written with `#`.

```text
@()-wrap both counts: under the importer's strict mode, .Count on a scalar (or an empty pipeline
result) throws instead of adapting.
```
