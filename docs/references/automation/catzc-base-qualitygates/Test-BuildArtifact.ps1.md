---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-BuildArtifact.ps1.md
    kind: reference
    body_sha: f8de49c2dbde
    adrs:
      - ADR-AUTO-TEST#24
      - ADR-AUTO-TEST#35
      - ADR-DSGN-RUNMODE#2
---

# automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The built, immutable artifact is what ships, so it is verified as built
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
[ADR-AUTO-TEST#24](/docs/adr/automation/test-automation.md#rule-adr-auto-test24)). The gate runs
Build-Modules (vendor policy 'full', so Pester ships and a build-mode session can enter a module's scope) into
a fresh temporary destination, checks the build facet by facet, and deletes it. Every issue is prefixed with
its facet:

  [build]     Build-Modules succeeds — it verifies its own output with Assert-CatzcBundle, the bundle's
              integrity check (layout, no tests/, the one types DLL and its sources, the modules and their
              manifests, the content hash), so a failed bundle check arrives here as Build-Modules' throw,
              one issue per violation — and the build ships the full type set (its typesHash equals the
              source tree's combined hash, whatever modules are selected).
  [types]     The committed automation/.compiled assembly is the current one (Get-CommittedTypesDrift) —
              the DLL every build copies. Needs no build.
  [load]      The build loads cold in a fresh pwsh (Invoke-BuildArtifactProbe): build mode with the build as
              the code root and the repository as the working root; every built module once, from the build
              root, exporting functions; the internal modules from the build; the types DLL named for the
              build's typesHash and its accelerators; every shipped config through Get-Config; comment-based
              help kept and privates not exported; InModuleScope enters a built module.
  [parity]    Every built module exports exactly its source folder's public functions and defines exactly its
              private ones ([ADR-DSGN-RUNMODE#2](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode2)).
  [manifest]  Every built manifest (Catzc.psd1 and each <Module>.psd1) is formatter-stable — Format-Code
              -Language powershell -DryRun would leave it byte-for-byte unchanged — so a published manifest
              never churns.

Collects every issue and ends with Write-QualityGateReport: the report lands in out/test-build-artifact/, and
the gate throws once listing every issue (or returns the result with -PassThru). It builds from the source
tree, so it needs the source mode (Assert-SourceTree).
```

## comment:2

Section `.PARAMETER Module` of the comment-based help.

```text
Modules to build (combinable with -ModuleProfile; closure-expanded by Build-Modules). Neither -> the default
bundle's profile (exporter.yml default_bundle).
```

## comment:3

Section `.PARAMETER Facet` of the comment-based help.

```text
Check only these facets (default: every one). 'types' alone builds nothing; any other facet builds once and
also checks [build].
```

## comment:4

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return the gate result { Subject; IssueCount; Issues; ReportPath; Modules; TypesHash } instead of throwing on
issues.
```
