---
name: catzc-verify
description:
  The per-file and end-of-task checks a delegated change must pass, and the shared files it may never edit; for catzc-module; input is the
  list of files the brief owns.
user-invocable: false
allowed-tools: Bash, Read
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [pwsh]
---

# catzc-verify

1. Per file right after its edit, through `catzc-gate`: `Test-Parsing -Path <ps1, psm1, psd1, yml>` (a stray `'` breaks every import), then
   `Invoke-TestFile -Path <its test file>`; re-read a file right before editing it and never overwrite another session's in-flight edit. A
   rename of a folder or command the tooling names lands its import-path readers (`rootconfig.yml` and Build-RootConfig's writers,
   `Get-LanguageTestFolders`, the `.internal` loaders, the contract readers) in the same pass inside a burst, never a HOLD or GO message:
   one background `pwsh/.internal/assets/Enter-CatzcBurst.ps1 -Seconds <s> '<step>' '<step>' …` call holds the run lock, runs the swap-in,
   the checks and one fresh full import (`Invoke-CatzcCommand.ps1 -InBurst`) as its steps, each its own argument, and releases it; on
   failure restore them from HEAD; staged files are edited under `<scratchpad>/<topic>/staged/`, never `out/` and never first in the tree (a
   new public file or an import-path file is written to the staged folder before any parse check, even when a per-edit hook asks for one),
   and swapped in by `pwsh/.internal/assets/Invoke-StagedBurst.ps1 -StagedFolder <that folder> '<command>' …` in place of a hand burst (it
   backs up, swaps, tests under one fresh import, restores on failure; a staged folder reported ready is frozen until its burst ends, and a
   burst changing a type runs every test file whose fixtures build that type), a public staged copy proved by that swap, never by
   dot-sourcing it (the exported command stays); `Get-CodeCaller -Name <type or config key>` lists callers of a changed type or config,
   never a recursive grep, and a cross-module type call first reads `dependencies.yml` for a cycle; a C# type edit that adds a call and its
   member lands in one Edit. A new folder under `.claude/hooks` is an import-path change too, since every import builds each hook folder
   with a csproj, so it is drafted outside the tree and lands in a burst, and a change to a file the Bash hook compiles (`TestTiers.cs`, a
   new `timeouts.yml` key) runs `Build-AgentHook` in that same burst; a Python file writer passes `newline="\n"`, since `Path.write_text`
   writes CRLF on Windows; the glossary's family heads (gate, scope, source, domain, layer, slot, zone) are written in a declared qualified
   form, so a new heading or page draws no G6 hit, and a hit is fixed with a declared form, never a new one; a comment-only edit is proven
   by a diff showing only comment lines changed, never by a parse. A test file red on HEAD is fixed inside the burst that touches its
   subject; a burst leaves out only files red for commit state or a named race, each listed in its step.
2. At the end on the owned files, each at 0: `Test-ScriptAnalyzer -Path <ps1> -PassThru`, `Test-Spelling -Path <files> -PassThru`,
   `Format-Types -Path <module>/types -DryRun -PassThru` for C#, `Format-Code -Path <files>` (before any fresh import: formatting a C# type
   changes the types hash; a new test file or a new or changed comment page puts its code file in that `-Path` to re-imprint it, since the
   head's `test:`, `docs:` and `cites:` derive from them; it formats only its `-Path`, so a file an imprint or generator writes besides goes
   in that `-Path` too; a body diff after it may be a comment moved to its page, so check the page first) then
   `Test-Links -Path <md> -PassThru` (links in docs prose are relative; Test-Links rejects repository-rooted ones),
   `Test-Glossary -PassThru` (issues naming an owned file), and after a generated file's source changed its generator (`Build-Readme`,
   `Build-Glossary`, `Build-DrsIndex`) then `Test-GeneratedFiles -PassThru`; a new L1 `integrity` block needs its check in a
   manual-test-plan category page (an ask, since those pages are shared), and a new file gets its head from `Format-FileMeta` before its
   gates; never the full `Test-Automation`, and in a burst no tier above L1 (L0 78 s, L1 33 s, L2 past the roof); a new command's task
   closes only on one live run of it, its output reported verbatim, never on green tests alone; a command's help is proved by a read of its
   page under `docs/references/`, never by `Get-Help`; a test red before the edit has its name grepped in `.claude/plans` first, since a
   plan may already hold its cause; a `types/<Name>.cs` declares one public class `<Name>`, no partial class; a new file naming the accosted
   word needs its scope line in `pwsh/Base.QualityGates/configs/terminology/reserved.yml` (an ask unless owned); a staged `.cs` is formatted
   in place as its burst's first step; a gate that reads tracked files only reads an uncommitted file red, reported as owed to the commit;
   plan text names a rule family by its code without a trailing star.
3. Shared files are the coordinator's unless the brief names them owned: `dependencies.yml`, `configs.yml`, `rootconfig.yml`,
   `gitignore.yml`, `globs.yml`, `terminology.yml`, `guids.yml`, every `glossary.yml`, `docs/drs/glossary.md`, `docs/drs/index.md`,
   `docs/how-to/pwsh/manual-test-plan/**`; an entry needed there goes in the report as the exact lines under asks, tested meanwhile with
   mocks or fixtures; the code file a new test re-imprints is its owner's, so a re-imprint of a file the brief does not own is an ask too.
