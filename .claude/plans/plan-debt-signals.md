---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      pwsh/Catzc.Base.QualityGates/Format-Code.ps1,
      pwsh/Catzc.Base.QualityGates/private/Write-TestRunFailures.ps1,
      docs/references/pwsh/internal/index.md,
      docs/references/pwsh/catzc-base-rootconfig.md,
      docs/references/pwsh/catzc-base-languages/Invoke-PythonTest.ps1.md,
      docs/references/pwsh/catzc-base-qualitygates,
      docs/references/pwsh/catzc-base-globs.md,
      docs/references/pwsh/catzc-base-languages.md,
      docs/references/pwsh/catzc-base-docs/Format-MarkdownParagraph.ps1.md,
      pwsh/Catzc.Base.Languages/Invoke-PythonTest.ps1,
      pwsh/Catzc.Base.QualityGates/private/Invoke-PythonWorkspaceTool.ps1,
      pwsh/.internal/assets/Invoke-CatzcCommand.ps1,
      pwsh/Catzc.Base.Docs/Add-SessionLearning.ps1,
      docs/adr/repository/ai-agent-contract.md,
      docs/adr/automation/pwsh,
      .gitignore,
    ]
---

# Debt: signals the tree declares but does not carry to the session

Seven grumbles of hindsight 226bbf name a fact a session found by outage or by hand: a bad janitor source, a missing test precedent, an
index-only file list, a reformat that does not say what it changed, a lint failure hidden in a setup block, an ignored file a janitor
overwrites, and a throwaway script that groups failures. Eleven more, from the rest of hindsight 226bbf and hindsight d7c207, are the same
kind: an article that omits a part or a side effect, a failure message that stops short of the fix, an entry script that sets no location, a
log that accepts a repeated line, and three pitfalls no ADR names. None is read from the start of a session, so each is a command output or
a page line placed where the session already looks.

## Why its value is medium

Each cuts a diagnosis a session pays today (a re-run by hand, a reread, an outage), none blocks work, and the one command each step changes
is already tested.

## Open steps

1. [ ] Susan from HR: Hindsight "If only the session had read the load sequence": `docs/references/pwsh/internal/index.md:19` and
       `docs/references/pwsh/catzc-base-rootconfig.md:62` each gain one sentence that a janitor's bad source (glossary, root config) breaks
       every session's next import. Cost today: an outage learned live. Check: `Test-Links` on both pages, `Grep "every session"` finds
       both.
2. [ ] Susan from HR: Hindsight "If only the fixture had copied its neighbours":
       `docs/references/pwsh/catzc-base-qualitygates/Get-FileMetaFact.ps1.md:20` names `Invoke-FileMetaEngine.Tests.ps1`'s script-scope
       `Get-WidgetPathFileMetaFact` as the fixture precedent. Cost today: a fixture invented and failed. Check: `Test-Links` on the page.
3. [ ] Susan from HR: Hindsight "If only the session had read Get-GitTrackedPath": the gate articles of `Test-IdiomaticNames` and
       `Test-Links` under `docs/references/pwsh/catzc-base-qualitygates/` say "tracked" means in the index, so a new file counts only once
       staged; one file per edit. Cost today: a gate that ignores a new file looks green. Check: `Test-Links` on each page.
4. [ ] Susan from HR: Hindsight "If only Format-Code had said what kind of change it made":
       `pwsh/Catzc.Base.QualityGates/Format-Code.ps1:212` reports, beside the changed-file count, how many files changed in content and how
       many only in wrapping. Cost today: a reread of every changed file. Check:
       `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1 -PassThru` with a case for each kind.
5. [ ] Susan from HR: Hindsight "If only the session had read the Invoke-PythonTest article":
       `docs/references/pwsh/catzc-base-languages/Invoke-PythonTest.ps1.md:45` adds that the ruff throw lands in the `BeforeAll` of
       `Language.Bridge.ps1:77` and fails every case of every engine. Cost today: 321 cases failing for one lint line. Check: `Test-Links`
       on the page. The test-side fix is plan-test-signal-proposals' first question (peer-dirty, no edit).
6. [ ] Susan from HR: Hindsight "If only the session had read the registry": `.gitignore:71` carries a comment that the root `catzc.sln` is
       rendered by the RootConfig janitor from `assets/root/catzc.sln` on every load and a hand edit is lost. Cost today: a hand edit
       overwritten. Check: `Grep "catzc.sln" .gitignore` shows the comment, `git check-ignore catzc.sln` still ignores it.
7. [ ] Susan from HR: Hindsight "If only Test-Automation had grouped its failures":
       `pwsh/Catzc.Base.QualityGates/private/Write-TestRunFailures.ps1:42` prints failures grouped by message with a count, so one cause
       behind many cases prints once. Cost today: a throwaway script over the shard XML. Check:
       `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1 -PassThru` with a case of three failures sharing
       a message.
8. [ ] Susan from HR: Hindsight "If only a command had listed the callers of a type or config": a command
       `Get-CodeCaller -Name <type or config key>` in `Catzc.Base.Files` lists the tracked files that name it, from `Get-GitTrackedPath`, so
       the one-living-version change finds every in-tree caller. Cost today: a hand grep. Check: its Pester file under `Invoke-TestFile`,
       `Test-Contracts`, `Test-IdiomaticNames`.
9. [ ] Susan from HR: Hindsight "If only the module articles were whole": `docs/references/pwsh/catzc-base-globs.md`, its Division of
       commands, lists the public `Get-FileKind`. Cost today: the article a session scans hides a part it needed. Check:
       `Grep "Get-FileKind"` finds it in the page, `Test-Links` on it.
10. [ ] Susan from HR: Hindsight "If only the help said one object":
        `docs/references/pwsh/catzc-base-docs/Format-MarkdownParagraph.ps1.md:40` says the function writes its lines as one array object
        (the closing unary comma), so a joiner takes the object whole. Cost today: a rediscovery by every caller. Check: `Test-Links` on the
        page.
11. [ ] Susan from HR: Hindsight "If only the article admitted the side effect":
        `docs/references/pwsh/catzc-base-qualitygates/Format-Code.ps1.md:19` says a run also imprints the file-meta heads
        (`Invoke-ImprintStep`) of the files in scope. Cost today: a folder run writes heads into neighbours nobody asked about. Check:
        `Test-Links` on the page.
12. [ ] Susan from HR: Hindsight "If only the one place had a page": `docs/references/pwsh/catzc-base-languages.md` names `TestFolderOf` in
        `LanguagesConfig` as the one source of every test folder name, called by `Invoke-PythonTest` and `Invoke-GoTest`. Cost today: a grep
        to find the single source. Check: `Test-Links` on the page.
13. [ ] Susan from HR: Hindsight "If only the lock had a janitor": the `uv sync failed` message in
        `pwsh/Catzc.Base.Languages/Invoke-PythonTest.ps1:100` and `pwsh/Catzc.Base.QualityGates/private/Invoke-PythonWorkspaceTool.ps1:57`
        adds that `uv.lock` is a gitignored product that pins member paths, so a moved member needs it deleted and the run repeated; one
        file per edit. Cost today: a red sync and a manual delete after every member move. Check: `Invoke-TestFile` on both functions' test
        files.
14. [ ] Susan from HR: Hindsight "If only someone had parsed it once":
        `docs/references/pwsh/catzc-base-qualitygates/private/Get-DefinedName.ps1.md` says it strips the `script:`, `global:`, `local:` and
        `private:` scope qualifier that `FunctionDefinitionAst.Name` keeps, so a name check calls it and never strips by hand. Cost today:
        each name check strips by hand or not at all. Check: `Test-Links` on the page.
15. [ ] Susan from HR: Hindsight "If only the tip had read catzc-run": `pwsh/.internal/assets/Invoke-CatzcCommand.ps1` sets its location to
        the repository root before the first command, so a relative path in a quoted command no longer drifts. Cost today: a path that
        resolves against the caller's folder. Check: run `Get-Location` through the entry script (catzc-run) and read the repository root
        back.
16. [ ] Susan from HR: Hindsight "If only Add-SessionLearning had looked before it wrote": `pwsh/Catzc.Base.Docs/Add-SessionLearning.ps1`
        skips a line equal to one already in `.claude/learnings/` and reports the skip, so a relayed lesson is logged once. Cost today: a
        duplicate line in a log a session reads. Check: `Invoke-TestFile pwsh/Catzc.Base.Docs/tests/Add-SessionLearning.Tests.ps1 -PassThru`
        with a repeated-line case. Context: plan-session-learnings owns the function and is dirty in a peer's tree, so this step names the
        file as a target and waits for that peer.
17. [ ] Susan from HR: Hindsight "If only someone had written it down": `docs/adr/repository/ai-agent-contract.md` (read first by every
        robot) gains one sentence that a new tool counts as working only after a live run, never on green tests alone. Cost today: green
        tests vouching for a broken tool. Check: `Test-AdrRegistry` and `Test-Links` on the page.
18. [ ] Susan from HR: Hindsight "If only someone had warned the tests": `docs/adr/automation/pwsh/pester-testing.md` gains one sentence
        that `Should -BeLike` and `Should -Throw` match a `-like` pattern, where `[ ]` is a character class, so a bracketed fragment is
        escaped or matched with `-BeExactly`. Cost today: learned twice in one session. Check: `Test-AdrRegistry` and `Test-Links` on the
        page.
19. [ ] Susan from HR: Hindsight "If only the pitfalls ADR knew .NET": `docs/adr/automation/pwsh/automatic-variable-pitfalls.md` gains one
        sentence that `[System.IO.File]::ReadLines` cut short by `Select-Object -First` keeps its file open until disposed, so a reader
        takes `Get-Content -TotalCount` or `ReadAllLines`. Cost today: a write that fails on a held file. Check: `Test-AdrRegistry` and
        `Test-Links` on the page.
20. [ ] `docs/references/pwsh/catzc-base-docs.md`: a responsibility for the rolling logs, with `Add-SessionLearning`, `learnings.yml` and
        `hindsight.yml` in the Division, which today names none of them though the authoring guide says every exported function appears
        exactly once. Cost today: the 2020-hindsight and its-a-chore-but-i-will-do-better robots find the logs only by grep. Check:
        `Test-Links` and `Test-Markdownlint` on the article.
