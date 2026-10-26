# pwsh/Base.Git/tests/Get-AutoControlledGlobs.Tests.ps1

The tests of `Get-AutoControlledGlobs`: they classify paths against the whitelist over a fixture registry.

## The fixture registry

The registry holds one gitignored managed target (it belongs in the whitelist), one committed managed target (`importer.ps1`-shaped, which
must not be whitelisted) and one not opted in.

## Plan files

The authored plan files are working notes, not output
([ADR-REPO-OUTDIR-PLANNOTES](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-plannotes)).
