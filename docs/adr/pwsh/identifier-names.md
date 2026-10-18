# ADR: Identifier names — the pwsh rules over spell-out-names

## Rules: ADR-PWSH-NAMES

### Rule ADR-PWSH-NAMES:1

A custom PSScriptAnalyzer rule, `Measure-SpellOutIdentifiers`, is the automatic identifier-level enforcer of
[spell-out-names](../automation/spell-out-names.md) (`ADR-AUTO-SPELL`). It tokenizes every variable reference — assignment targets,
parameters, loop variables, and reads — and the noun of every function name (camelCase / PascalCase / snake_case), and flags any fragment
that is neither a real English word nor an approved registry term. It applies no minimum word length, so it catches the short and compound
coined abbreviations cspell's `minWordLength` lets through (`$rcg`, `$tfPath`) — a class left to code review alone. Its oracle is a native
type (`SpellingOracle`) over cspell's own English words (`Build-EnglishDictionary` flattens them to `assets/english.txt.gz`) combined with
the registry term lists, so the analyzer and `Test-Spelling` agree on what a word is. It cannot separate an abbreviation that is also a real
dictionary word (`$spec`, `$info`) from a genuine short word; those remain a code-review concern.

- [The analyzer rule](#the-analyzer-rule)

### Rule ADR-PWSH-NAMES:2

Name a function's return value by its **role**, not its type or contents, with one of two blessed conventional locals: **`$ret`** — the
_return accumulator_ a function builds up and then hands back (returned directly, emitted under `-PassThru`, or returned once at the end);
and **`$found`** — the _lookup result_ a search returns (the located value, or `$null`). `$ret` generalizes over the accumulator's type: a
`[StringBuilder]` assembled for return, a list appended to, or a hashtable populated are each `$ret`, not `$stringBuilder` / `$results` /
`$output` — the name states what the variable is _for_, not what it _is_. `$ret` may also name the value a tight loop emits
(`Write-Output $ret`, or a direct return). A local that is not the function's return value keeps its own name (ADR-AUTO-SPELL#1,
ADR-PWSH-NAMES#3).

- [Role, then type](#role-then-type)

### Rule ADR-PWSH-NAMES:3

When no other rule names a local variable — it carries no meaning of its own to spell out (ADR-AUTO-SPELL#1) and it is not the return value
(ADR-PWSH-NAMES#2) — name it after the **simple type of what it holds**: a `[System.Text.StringBuilder]` is `$stringBuilder`, a
`[hashtable]` is `$hashtable`, a `[regex]` is `$regex`, an `[xml]` is `$xml`. The type is a true, self-describing name when there is nothing
more specific to say, and it keeps scratch and working variables consistent across the codebase instead of a scatter of `$sb` / `$temp` /
`$thing`. It is the default of last resort — below meaning, below role.

- [Role, then type](#role-then-type)

### Rule ADR-PWSH-NAMES:4

A short-lived, throwaway intermediate — a value assigned and consumed within a tight, co-located window (roughly 10–15 lines) that has no
meaning worth naming (ADR-AUTO-SPELL#1), no return role (ADR-PWSH-NAMES#2), and no type worth stating (ADR-PWSH-NAMES#3) — takes a **generic
blessed placeholder** rather than a coined bespoke name. The sanctioned generic is **`$obj`**. This is what keeps trivial scratch from
minting one-off vocabulary — the `myapp` / `myvalue` / `myproject` / `myvar` placeholders that otherwise each need a `fixture` registry
entry just to clear `Test-Spelling`. It applies equally to example and test placeholder data: reach for the generic blessed token (`$obj`,
`'obj'`) before coining a new word. The bar is deliberately high — `$obj` is for the genuinely nameless intermediate, never a licence to
blur a value that has a real meaning, a return role, or a type worth a glance.

- [Role, then type](#role-then-type)

### Rule ADR-PWSH-NAMES:5

In PowerShell, the identifiers [ADR-AUTO-SPELL#1](../automation/spell-out-names.md#rule-adr-auto-spell1) spells out are variable names
(`$protocols`, not `$protos`), parameter names (`-TemplateFolderPath`), hashtable keys, and the noun of a `Verb-Noun` function name; the
verb is one of PowerShell's approved verbs ([respect-pwsh-verb-rules](respect-pwsh-verb-rules.md)).

- [The analyzer rule](#the-analyzer-rule)

### Rule ADR-PWSH-NAMES:6

The engine's own names that [ADR-AUTO-SPELL#2](../automation/spell-out-names.md#rule-adr-auto-spell2) exempts are PowerShell's automatic and
preference variables — `$_`, `$PSItem`, `$args`, `$PSCmdlet`, `$PSBoundParameters`, `$IsWindows`, `$ErrorActionPreference`, and the like. A
drive-qualified variable (`$env:`, `$function:`, `$variable:`) names data outside our choosing, not an identifier
([ADR-AUTO-SPELL#4](../automation/spell-out-names.md#rule-adr-auto-spell4)), and is never checked.

- [The analyzer rule](#the-analyzer-rule)

## Context

[spell-out-names](../automation/spell-out-names.md) fixes the doctrine: identifiers are spelled out in full, the curated vocabulary lives in
one registry, and a flagged token is a review candidate. This ADR realises it in pwsh — what an identifier is in PowerShell, which names the
engine owns, the analyzer rule that checks them, and the blessed names a local takes when it has no meaning of its own.

### The analyzer rule

`How Measure-SpellOutIdentifiers reads a file`

`Measure-SpellOutIdentifiers` lives in `pwsh/.scriptanalyzer/SpellOutIdentifiers.psm1` and runs inside the L2 `Test-ScriptAnalyzer` quality
gate. Per file it:

- reads every variable reference and every function definition from the script's syntax tree;
- skips a drive-qualified variable and the automatic and preference variables (ADR-PWSH-NAMES#6), and strips a scope prefix (`script:`,
  `global:`, `local:`, `using:`) before it checks the bare name;
- splits each name into its camelCase, PascalCase, or snake_case fragments, and checks each fragment against the oracle;
- reports each distinct coined name once per file, however often it is read, and names the coined fragments in the diagnostic.

The oracle accepts the fixture vocabulary (`.cspell/fixture.txt`) only when the analyzed file is a test — a `*.Tests.ps1` file or a file
under `tests/` — so a test may use fixture names that production code may not
([ADR-AUTO-SPELL#6](../automation/spell-out-names.md#rule-adr-auto-spell6)). The oracle is a native type because a PowerShell method call
costs too much to look up thousands of fragments per file; the rule loads the committed types assembly into the analyzer's own runspace
once.

Hashtable keys and string literals are not read: a key often mirrors an external contract (ADR-AUTO-SPELL#4), so a coined key is a
code-review concern.

### Role, then type

Four things can name a local, in order of preference — meaning, then role, then type, then a generic placeholder.

- **Meaning** is best, and is what ADR-AUTO-SPELL#1 asks for: `$subscription`, `$templateFolderPath`. A name that says what the value
  _means_ is the densest documentation a reader gets.
- **Role** comes next, for the one or two variables that _are_ the function's output: `$ret` for the accumulator built up and handed back,
  `$found` for what a lookup located (ADR-PWSH-NAMES#2). The role name wins here because a reader scanning the function finds the return
  value at a glance, and it stays stable when the accumulator's type changes — a `[StringBuilder]` swapped for a `[List]` is still `$ret`.
- **Type** comes next (ADR-PWSH-NAMES#3): a scratch buffer or working object with no meaning of its own and no return role is named for the
  simple type it holds — `$stringBuilder`, `$hashtable`, `$regex`. Type-as-name says exactly what the value is and is shared (everyone names
  a scratch StringBuilder the same way), which is why it beats an invented `$sb` or `$temp`.
- **Generic placeholder** is the honest default of last resort (ADR-PWSH-NAMES#4): a genuinely nameless, short-lived intermediate — no
  meaning of its own, no return role, no type worth a glance — is `$obj`, rather than a coined bespoke name or a one-off `fixture` token.
  The bar is high: `$obj` is for the truly anonymous scratch value only, never a blur over something that has a real name.

So `$stringBuilder` is right for a StringBuilder used as a mid-function scratch buffer — but the same StringBuilder becomes `$ret` the
moment its role is "the value this function returns."

## Decision

PowerShell identifiers — variables, parameters, hashtable keys, and function nouns — are spelled out; the engine's automatic variables and
drive-qualified data keep their names; a local with no meaning of its own is named for its role (`$ret`, `$found`), then its type, then
`$obj`; and `Measure-SpellOutIdentifiers` checks every variable and function noun on every build.

### How this is enforced

- **`Measure-SpellOutIdentifiers`** (custom PSScriptAnalyzer rule, ADR-PWSH-NAMES#1) — in the L2 `Test-ScriptAnalyzer` quality gate; a
  flagged fragment is spelled out or blessed as a reviewed registry entry
  ([ADR-AUTO-SPELL#7](../automation/spell-out-names.md#rule-adr-auto-spell7)).
- **Code review** — the role, type, and placeholder names (ADR-PWSH-NAMES#2 to ADR-PWSH-NAMES#4), coined hashtable keys, and abbreviations
  that are also dictionary words are review concerns.

## Consequences

- A coined variable or function noun is flagged by the analyzer quality gate on the developer's machine, before review.
- Scratch and return variables read the same in every file, so a reader finds a function's return value at a glance.
- Placeholder data stops minting one-off vocabulary: `$obj` needs no registry entry.
