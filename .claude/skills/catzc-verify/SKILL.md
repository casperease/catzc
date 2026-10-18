---
name: catzc-verify
description:
  The per-file and end-of-task checks a delegated change must pass, and the shared files it may never edit; for catzc-worker and
  build-inspiration-module; input is the list of files the brief owns.
user-invocable: false
allowed-tools: Bash, Read
metadata:
  catzc:
    immutable:
      repo_status: clean
      path: ".claude/skills/catzc-verify/SKILL.md"
      folder: skills/catzc-verify
      name: skill
      filetype: md
      role: capability
      language: markdown
      track: ".claude"
      tracktype: vendor-settings
      vendor: claude
      module: ".claude"
      moduletype: settings
    config:
      model_floor: haiku
      needs: [pwsh]
---

# catzc-verify

1. Per file right after its edit, through catzc-check: parse every `.ps1`/`.psm1` (a stray `'` breaks the importer for every session), then
   `Invoke-TestFile -Path <its test file>`; re-read a file right before editing it and never overwrite another session's in-flight edit.
2. At the end on the owned files, each at 0: `Test-ScriptAnalyzer -Path <ps1> -PassThru`, `Test-Spelling -Path <files> -PassThru`,
   `Format-Types -Path <module>/types -DryRun -PassThru` for C#, `Format-Code -Path <files>` then `Test-Links -Path <md> -PassThru`,
   `Test-Glossary -PassThru` (issues naming an owned file), and after a generated file's source changed its generator (`Build-Readme`,
   `Build-Glossary`, `Build-AdrIndex`) then `Test-GeneratedFiles -PassThru`; never the full `Test-Automation`.
3. Shared files are the coordinator's unless the brief names them owned: `dependencies.yml`, `configs.yml`, `rootconfig.yml`,
   `gitignore.yml`, `globs.yml`, `terminology.yml`, `guids.yml`, every `glossary.yml`, `docs/adr/glossary.md`, `docs/adr/index.md`,
   `docs/how-to/pwsh/manual-test-plan/**`; an entry needed there goes in the report as the exact lines under asks, tested meanwhile with
   mocks or fixtures.
