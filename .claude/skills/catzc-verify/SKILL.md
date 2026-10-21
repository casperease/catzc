---
name: catzc-verify
description:
  The per-file and end-of-task checks a delegated change must pass, and the shared files it may never edit; for catzc-worker and
  build-inspiration-module; input is the list of files the brief owns.
user-invocable: false
allowed-tools: Bash, Read
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [pwsh]
---

# catzc-verify

1. Per file right after its edit, through catzc-check: parse every `.ps1`/`.psm1` (a stray `'` breaks the importer for every session), then
   `Invoke-TestFile -Path <its test file>`; re-read a file right before editing it and never overwrite another session's in-flight edit. A
   rename of a folder or command the tooling names lands its import-path readers (`rootconfig.yml` and Build-RootConfig's writers,
   `Get-LanguageTestFolders`, the `.internal` loaders, the contract readers) in the same pass after a HOLD to every peer ListAgents shows,
   the orchestrator included, then one fresh full import and a GO to the same peers; on failure restore them from HEAD; multi-file type work
   is edited on staged copies under `out/<topic>/staged/` and swapped in by one script with a fresh import and a restore on failure, a
   public staged copy proved by that swap, never by dot-sourcing it (the exported command stays);
   `Get-CodeCaller -Name <type or config key>` lists the callers of a changed type or config, never a recursive grep.
2. At the end on the owned files, each at 0: `Test-ScriptAnalyzer -Path <ps1> -PassThru`, `Test-Spelling -Path <files> -PassThru`,
   `Format-Types -Path <module>/types -DryRun -PassThru` for C#, `Format-Code -Path <files>` (before any fresh import: formatting a C# type
   changes the types hash) then `Test-Links -Path <md> -PassThru`, `Test-Glossary -PassThru` (issues naming an owned file), and after a
   generated file's source changed its generator (`Build-Readme`, `Build-Glossary`, `Build-DrsIndex`) then `Test-GeneratedFiles -PassThru`;
   never the full `Test-Automation`; a new command's task closes only on one live run of it, its output reported verbatim, never on green
   tests alone.
3. Shared files are the coordinator's unless the brief names them owned: `dependencies.yml`, `configs.yml`, `rootconfig.yml`,
   `gitignore.yml`, `globs.yml`, `terminology.yml`, `guids.yml`, every `glossary.yml`, `docs/drs/glossary.md`, `docs/drs/index.md`,
   `docs/how-to/pwsh/manual-test-plan/**`; an entry needed there goes in the report as the exact lines under asks, tested meanwhile with
   mocks or fixtures.
