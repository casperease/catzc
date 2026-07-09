# Add a function

Adding a public function is a one-step operation: **create the file**. The bootstrap module discovers it on the next importer run — no
manifest to edit, no export list to maintain.

## Steps

1. Pick the right module folder under `automation/` (or [create a new module](../add-a-module.md) first).
2. Create `automation/<Module>/Verb-Noun.ps1`. The **file name must equal the function name**, and the file must contain exactly one
   function (see [one-function-per-file](../../../../adr/automation/powershell/one-function-per-file.md)).
3. Create the paired test `automation/<Module>/tests/Verb-Noun.Tests.ps1`.
4. Re-run the importer (`. ./importer.ps1`) and run `Test-Automation`.

## The shape of a function

```powershell
# automation/<Module>/Get-Widgets.ps1
function Get-Widgets {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Source,

        [int] $Limit = 10
    )

    Assert-NotNullOrWhitespace $Source        # validate input at entry
    Assert-PathExist $Source -PathType Leaf

    $raw = Get-Content $Source -Raw
    Assert-NotNullOrWhitespace $raw            # assert after an external read

    $widgets = $raw | ConvertFrom-Json
    foreach ($w in $widgets) {                 # foreach, not ForEach-Object
        $w.name = $w.name.Trim()
    }

    $widgets | Select-Object -First $Limit
}
```

Five functional lines, three assertions — that ratio is the target (see
[fail-fast-with-asserts](../../../../adr/automation/fail-fast-with-asserts.md)).

## The rules you must follow

These are enforced by PSScriptAnalyzer and the convention tests — code that breaks them fails `Test-Automation`.

- **Approved verb, meaningful noun.** Use a verb from `Get-Verb` (`Get`, `New`, `Set`, `Install`, `Invoke`, `Assert`, `Test`, …). Use a
  **plural** noun when you return a collection (`Get-Widgets`) and a **singular** noun when you return one object (`Get-Widget`). The verb
  is a contract: `Get-` must not change state, `Test-` returns `[bool]`, `Assert-` throws on failure (see
  [respect-pwsh-verb-rules](../../../../adr/automation/powershell/respect-pwsh-verb-rules.md)).
- **Assert your assumptions.** Validate parameters at entry and results after every external call with the `Assert-*` library — never inline
  `if (-not $x) { throw }` (see [fail-fast-with-asserts](../../../../adr/automation/fail-fast-with-asserts.md)).
- **Throw, don't warn.** Use `throw` / `Assert-*` for failure and `Write-Message` / `Write-Verbose` for information. `Write-Error` and
  `Write-Warning` are banned (see [error-handling](../../../../adr/automation/powershell/error-handling.md)).
- **Sensible defaults.** Make the zero/low-argument call do the common thing; pull defaults from config where they live (see
  [sensible-defaults](../../../../adr/automation/sensible-defaults.md)); make the primary argument positional and use `[switch]` for opt-in
  behavior (see [parameter-design](../../../../adr/automation/powershell/parameter-design.md)).
- **One responsibility.** A function does one thing its name describes. `Invoke-Widget` must not secretly install the tool — assert the
  precondition and let the caller compose (see
  [single-responsibility-functions](../../../../adr/automation/single-responsibility-functions.md)).
- **Style.** K&R braces, 4-space indent, no trailing semicolons, `foreach` over `ForEach-Object` for anything with control flow, PascalCase
  parameters / camelCase locals (see [powershell-formatting](../../../../adr/automation/powershell/powershell-formatting.md)).

## Reuse the base library

Before writing a helper, reach for what already exists in `Catzc.Base.*` and `Catzc.Base.Asserts`:

- Run external tools with `Invoke-Executable` (it logs the command, handles exit codes, and returns a `CliResult` with `-PassThru`) — not a
  bare `& tool`.
- Locate files with `Get-RepositoryRoot` / `Get-RepositoryFile`; write output under `Get-OutputRoot`. Never depend on `$PWD` (see
  [never-depend-on-pwd](../../../../adr/automation/never-depend-on-pwd.md)).
- Load config with `Get-Config -Config <name>`.
- Common guards: `Assert-NotNullOrWhitespace`, `Assert-PathExist`, `Assert-Command`, `Assert-True`, `Test-Command`.

## Call a private helper

A `.ps1` in the module root is exported; a `.ps1` in `private/` is loaded into the same module scope but **not** exported. Public functions
call private helpers directly — no import, no qualification. To add one, drop `automation/<Module>/private/Verb-Noun.ps1` (same
one-function-per-file rule).

## The paired test

Every function file pairs one-to-one with a test file. Every test carries **two mandatory tags**: a tier (`L0`/`L1`/`L2`/`L3`) and a
category (`logic`/`integrity`). A run fails fast if either is missing.

```powershell
# automation/<Module>/tests/Get-Widgets.Tests.ps1
Describe 'Get-Widgets' -Tag 'L1', 'logic' {
    It 'returns the trimmed widgets, capped at -Limit' {
        $fixture = Join-Path $PSScriptRoot 'assets/widgets.json'
        $result = Get-Widgets -Source $fixture -Limit 2
        $result.Count | Should -Be 2
    }
}
```

Logic tests run on fixtures/mocks and are hermetic; mock only real boundaries (filesystem location, CLIs), and mock the whole boundary
function — see [test-automation](../../../../adr/automation/test-automation.md) for tiers and tagging, and
[pester-testing](../../../../adr/automation/powershell/pester-testing.md) for the isolation idioms.

### Optionally cite the ADR rule a test enforces

A test may also declare the ADR rule(s) it enforces, as an **optional** third tag — so the suite is traceable from a test to the rule behind
it and back. Cite the rule in the index's `#` form (`ADR-<CODE>#<n>`, e.g. `ADR-AUTO-ERROR#3`) as a `-Tag` beside the tier and category:

```powershell
Describe 'Invoke-Poetry' -Tag 'L1', 'logic', 'ADR-AUTO-ERROR#3' {   # this test pins "throw, never Write-Error"
```

The citation is optional (absence is never a violation), but a **present** one is validated: it must be well-formed and name a real rule, or
the run fails — so renumbering a rule turns its stale tags red. It is set-valued: put a broad rule on the `Describe` and a specific one on
an inner `Context`/`It`, and both count (citations are unioned across the block chain, unlike the nearest-wins tier/category). Mind the two
spellings of one rule: the **tag** uses `#` (`ADR-AUTO-ERROR#3`, the citation form), while the rule's **heading** in the ADR uses `:`
(`### Rule ADR-AUTO-ERROR:3`). Each run then writes `rule-coverage.md`/`.csv` (rule → enforcers, and the uncovered), and `tests.csv` gains a
`Rules` column you can filter by a citation to find every test that enforces it.

Citing is one of **two** ways a rule gets mechanical coverage; the other is a PSScriptAnalyzer rule. So when you add a **custom analyzer
rule** (`automation/.scriptanalyzer/*.psm1`), map it to the rule id(s) it enforces in
`automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` — an integrity test fails if a custom rule is left unmapped.

Then:

```powershell
. ./importer.ps1
Test-Automation                 # L0 + L1, the fast default
```

See [Run tests and checks](../run-tests-and-checks.md) for levels, categories, and the report files.
