---
plan:
  status: active
  value: low-medium
  reviewed: 2026-10-23
  class: feature
  targets:
    [
      docs/drs/repository/plans.md,
      docs/references/pwsh/catzc-base-quality-gates/Test-Automation.ps1.md,
      docs/drs/automation/pwsh/automatic-variable-pitfalls.md,
      docs/drs/automation/pwsh/pester-testing.md,
      docs/references/pwsh/catzc-base-code-meta/types/PropertyHead.cs.md,
    ]
---

# Debt hindsight pages: six sentences the 2026-10-23 hindsight log found missing from the pages a session reads

The hindsight log of 2026-10-23 (`.claude/hindsight/hindsight963317.md`) found the tree right in every case but six: the rule, the
parameter or the carrier is built and tested, and the page that describes it stops one sentence short. Each step below is one sentence on
one page, checked against the tree on 2026-10-23, in the page's own present tense. Nothing here is a new file, a new key or a line a session
reads at its start.

## Why its value is low-medium

It saves a red round trip per rediscovery (a coined plan topic meeting the spelling gate, a case-only rename lost in a snapshot, a probe
rerun for a Mock body), and breaks nothing while it waits.

## Open steps

- [ ] Susan from HR: hindsight "If only the plans ADR had said the name is prose": `docs/drs/repository/plans.md`, rule
      ADR-REPO-PLANS-ONETOPICONEFILE gains one sentence: the topic is prose, spell-checked wherever `plan-master.md` or `value-of-plan.md`
      cites it, so a coined topic word goes into `terminology.yml` before the plan is named. Cost today: a coined topic meets `Test-Spelling`
      before any rule. The `plan-shape` capability is left unchanged, since the rule lives in its one record (PDR-ONELIVE). Check:
      `Test-Spelling -Path docs/drs/repository/plans.md`, `Test-Links -Path docs/drs/repository/plans.md`, and a Grep of the page for
      "spell-checked".
- [ ] Susan from HR: hindsight "If only the Isolated parameter had said whose tree it copies":
      `docs/references/pwsh/catzc-base-quality-gates/Test-Automation.ps1.md`, section parameter `Isolated` (lines 125 to 130 on 2026-10-23)
      gains one sentence: the snapshot is HEAD plus every uncommitted change, so a case-only rename, invisible to git until committed, is
      lost in it (`docs/how-to/automation/rename-a-tooling-folder.md` and `private/Enter-TestRunLocation.ps1.md` hold the two halves).
      Cost today: the red round trip of `Get-DynamicManifestContent.Tests.ps1`. Check: `Test-Links -Path` on the page, `Test-Spelling -Path`
      on it, and a Grep of the page for "case-only".
- [ ] Susan from HR: hindsight "If only the unroll warning covered statements":
      `docs/drs/automation/pwsh/automatic-variable-pitfalls.md`, the "What to do instead" block after line 305 gains one sentence: the two
      `$value = if` forms yield a scalar and are safe; a branch that yields a list is wrapped whole, `$value = @(if (...) { ... })`, since the
      assignment unrolls a one-item or empty list (the analyzer rule Measure-NoUnrolledArrayBranch, ADR-PWSH-ERROR-STRICTCLEAN). The
      hindsight line read the examples as against the rule; they are not, and only the list case lacked a word. Cost today: learned twice in
      one day by two sessions with two different cures. Check: `Test-Links -Path` and `Test-Spelling -Path` on the page, and a Grep of it
      for `@(if`.
- [ ] Susan from HR: hindsight "If only Jack had probed before he pitied": `docs/drs/automation/pwsh/pester-testing.md`, the bullet "Chained
      mock state hits a Pester `$script:` scope surprise" (line 376 on 2026-10-23) gains what a Mock body sees. First a scratch test under
      `$TestDrive` or out/ proves it, a Mock defined in BeforeAll and one inside the It, each reading an It local, on the Pester the repository
      pins; the sentence then states the result as probed, and the bullet's `$script:` claim is re-read against it. Cost today: the log
      carries a line for each side of the same engine behaviour (one reversed by a probe the same day). Check: `Invoke-TestFile -PassThru` on
      the scratch file green, then `Test-Spelling -Path` and `Test-Links -Path` on the page.
- [ ] Susan from HR: hindsight "If only someone had written the placement down": `docs/drs/automation/pwsh/pester-testing.md`, a bullet
      beside the one above: PSReviewUnusedParameter does not trace a parameter into a nested `Should -Throw` block, so the call that uses the
      parameter sits inside the throw block (`pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1`, the `throws when the build's
      entry does not exist` case) and needs no `SuppressMessageAttribute`. Cost today: the next test reaches for a suppression first. Check:
      `Test-ScriptAnalyzer -Path pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1 -PassThru` at 0, then `Test-Spelling -Path`
      and `Test-Links -Path` on the page.
- [ ] Susan from HR: hindsight "If only the carrier page had met its newest file":
      `docs/references/pwsh/catzc-base-code-meta/types/PropertyHead.cs.md`, section `comment:2`: the sentence "An XML file whose root is an
      MSBuild project keeps it ..." covers any XML file the carriers declare as a property carrier, `nuget.config` (configuration root)
      beside an MSBuild project, in the same labelled first PropertyGroup (`file-carriers.yml` line 39, `PropertyHead.cs` lines 58 and 158).
      Cost today: the configuration-rooted variant is declared in config and missing from the page. Check: Grep the page for "nuget.config",
      `Test-Links -Path` and `Test-Spelling -Path` on it, and `Invoke-TestFile` on `pwsh/Catzc.Base.CodeMeta/tests/types/PropertyHead.Tests.ps1`
      still green.

## Open questions

- Susan from HR: hindsight "If only the session had waited for the commit": the Python backslash-n, -r and -t escape glued to the next word
  (`cspell-template.yml`, the `ignoreRegExpList` entry under the backtick pattern). A pattern cannot tell `"a\nword"` from the Windows path
  `src\nuget`, so ignoring `\n` before a letter would leave `uget` spelled and hide real paths. Recommendation: no pattern; the text is
  written so the escape stands alone or in a code span, and the gap stays recorded here. A root asset edit would also start with a HOLD to
  every live peer (`catzc-run`). The user decides.
- Susan from HR: hindsight "If only a lint rule had been asked to watch names": `python/pyproject.toml` lines 13 to 15, ruff selects no
  rule. Whether ruff carries a rule that flags a local shadowing a module-level helper is not shown by anything in the tree, and a selected
  rule set changes the findings of every Python file in the kit. Recommendation: leave the config as it is; the shadowing fails the first
  test at once, and a probe by `ruff rule` for a shadowing rule comes before any key. The user decides.
