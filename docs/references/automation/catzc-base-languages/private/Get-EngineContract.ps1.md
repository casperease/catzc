---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/private/Get-EngineContract.ps1.md
    kind: comment-page
    body_sha: ec0bddfccf82
    adrs:
      - ADR-AUTO-GO#3
      - ADR-AUTO-PY#3
---

# automation/Catzc.Base.Languages/private/Get-EngineContract.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A Go or Python test starts the engine as a process and asserts on its output
([ADR-AUTO-GO#3](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go3),
[ADR-AUTO-PY#3](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py3)). How to start it comes from
the execution engine model, never from the test ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)), so
the same test runs under every engine:

  CATZC_ENGINE             the engine's name (ExecutionEngines.Names);
  CATZC_ENGINE_EXECUTABLE  the engine's executable;
  CATZC_ENGINE_ENTRY       the script that loads catzc into the engine: the PowerShell entry for pwsh, the
                           repository's importer.sh (forward-slashed) for the POSIX engines — what a Bash test
                           loads;
  CATZC_ENGINE_START       the arguments after it, as a JSON array (ExecutionEngine.StartArguments): they start the
                           engine non-interactively, load its importer with the output discarded, and end in the
                           command text, where the test puts its catzc command in place of {command};
  CATZC_IMPORTER           the POSIX engines only: the PowerShell entry the cats dispatcher loads (importer.sh reads
                           it);
  CATZC_REPOSITORY_ROOT    the repository root.

The PowerShell entry is the repository's importer.ps1 for a source run, or -EntryScript (the build's
Import-Catzc.ps1) for a build run. pwsh loads it directly. The POSIX engines load the repository's importer.sh,
whose cats dispatcher loads it through CATZC_IMPORTER, so a POSIX engine's session drives the build too.
```

## comment:2

Section `.PARAMETER EngineExecutable` of the comment-based help.

```text
The engine's executable, already located by the caller (a test run's source session hands it down, since a build
run's engine does not carry the tools.yml entry a POSIX engine is located through). Default:
Resolve-EngineExecutable.
```

## comment:3

Above `$entry = if ($model.Name -eq [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name) {`.

```text
The entry the engine itself loads: pwsh the PowerShell entry; any other engine its own importer in the repository,
forward-slashed so a POSIX shell on Windows reads the path.
```

## comment:4

Above `$entry = if ($model.Name -eq [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name) {`.

```text
The entry the engine itself loads: pwsh the PowerShell entry; any other engine its own importer in the repository,
forward-slashed so a POSIX shell on Windows reads the path.
```
