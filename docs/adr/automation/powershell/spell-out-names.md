# ADR: Spell out names — no invented abbreviations

## Rules: ADR-SPELL

### Rule ADR-SPELL:1

Identifiers — variable names, parameter names, hashtable keys, and the nouns in function names — use full, spelled-out words. Write
`$protocols`, not `$protos`; `$ruleCollectionGroup`, not `$rcg`; `$templateFolderPath`, not `$tfPath`; `$stringBuilder`, not `$sb`. No
truncated words, no dropped vowels, and no locally-invented acronyms. (A short list of conventional abbreviations — `ctx`, `cfg`, `cmd`, … —
is exempt; see ADR-SPELL:2.)

- [Why this matters](#why-this-matters)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-SPELL:2

The only abbreviations allowed without spelling out are: single-letter loop indices (`$i`, `$j`, `$k`); the small set of universal,
industry-standard acronyms that ARE the canonical name for a thing (CSV, JSON, YAML, URL, URI, ID, HTTP, IP, UTC, API, CLI, DNS, TLS, SDK,
GUID, regex, UTF, BOM); PowerShell's own automatic variables; and a short, curated allow-list of conventional abbreviations that every
developer reads fluently (`ctx`, `cfg`, `cmd`, `params`, `env`, `repo`, …). That allow-list — each term mapped to its full word — is the
authoritative set, authored as `abbreviation` entries in the terminology registry (ADR-SPELL:5, ADR-SPELL:6). Everything else is spelled
out, and an invented local shorthand (`tfPath`, `perSubEnvs`, `expectedMgr`) is never added to the registry to silence the gate
(ADR-SPELL:3).

- [Allowed exceptions](#allowed-exceptions)

### Rule ADR-SPELL:3

The curated vocabulary is authored in one place — the terminology registry (ADR-SPELL:5) — which carries both genuine domain terms kept
as-is (a real product, protocol, tool, or external field name) and the conventional-abbreviation allow-list of ADR-SPELL:2, each as a
categorized entry (ADR-SPELL:6). It grows only by review. A term worth keeping earns a reviewed entry, used consistently everywhere; a term
not worth that is not worth coining. What the rule forbids is the reflex of dropping a one-off local shorthand (`tfPath`, `perSubEnvs`) into
the vocabulary just to clear the gate — that is a junk drawer, not curation (ADR-SPELL:7).

- [The dictionary is the backstop](#the-dictionary-is-the-backstop)

### Rule ADR-SPELL:4

This governs identifiers, not data. String literals, CSV headers, Azure resource-property names, and external API response keys keep their
source spelling — renaming them would break the contract with the outside system.

- [Identifiers, not data](#identifiers-not-data)

### Rule ADR-SPELL:5

Approved vocabulary has one authored source — the terminology registry (`terminology.yml`) — and the spell-checker's accepted-word lists are
generated from it, never hand-edited or auto-appended. A gate fails when the generated lists differ from the registry, so the two cannot
drift.

- [The terminology registry](#the-terminology-registry)

### Rule ADR-SPELL:6

Every registry entry is grouped under a category and declares a meaning. The `terms:` map groups entries by category — the group is the
entry's category, so there is no per-entry category field. The allowed categories are defined in the registry's `categories:` map, each a
named vocabulary class with a description, and `TerminologyConfig` validates every group against it, so the category set is data, not
hardcoded. They are the enforced form of the distinctions drawn in ADR-SPELL:2 and ADR-SPELL:4.

- [The terminology registry](#the-terminology-registry)

### Rule ADR-SPELL:7

A token the spell-checker flags is a candidate for review, never an automatic acceptance: it joins the vocabulary only as a categorized
registry entry a human adds. No tool registers a flagged token on its own.

- [From backstop to registry](#from-backstop-to-registry)

### Rule ADR-SPELL:8

The registry holds only live vocabulary. An entry no code in the tree references is removed, and the terminology gate rejects an
unreferenced entry.

- [From backstop to registry](#from-backstop-to-registry)

### Rule ADR-SPELL:9

A custom PSScriptAnalyzer rule, `Measure-SpellOutIdentifiers`, is the automatic identifier-level enforcer. It tokenizes every variable name,
parameter name, and function noun (camelCase / PascalCase / snake_case) and flags any fragment that is neither a real English word nor an
approved registry term. It applies no minimum word length, so it catches the short and compound coined abbreviations cspell's
`minWordLength` lets through (`$rcg`, `$tfPath`) — the class code review used to own alone. Its oracle is a native type (`SpellingOracle`)
over cspell's own English words (`Build-EnglishDictionary` flattens them to `assets/english.txt.gz`) combined with the registry term lists,
so the analyzer and the spell gate agree on what a word is. It cannot separate an abbreviation that is also a real dictionary word (`$spec`,
`$info`) from a genuine short word; those remain a code-review concern.

- [The dictionary is the backstop](#the-dictionary-is-the-backstop)

### Rule ADR-SPELL:10

Name a function's return value by its **role**, not its type or contents, with one of two blessed conventional locals: **`$ret`** — the
_return accumulator_ a function builds up and then hands back (returned directly, emitted under `-PassThru`, or returned once at the end);
and **`$found`** — the _lookup result_ a search returns (the located value, or `$null`). `$ret` generalizes over the accumulator's type: a
`[StringBuilder]` assembled for return, a list appended to, or a hashtable populated are each `$ret`, not `$stringBuilder` / `$results` /
`$output` — the name states what the variable is _for_, not what it _is_. `$ret` may also name the value a tight loop emits
(`Write-Output $ret`, or a direct return). A local that is not the function's return value keeps its own name (ADR-SPELL:1, ADR-SPELL:11).

- [Role, then type](#role-then-type)

### Rule ADR-SPELL:11

When no other rule names a local variable — it carries no domain meaning to spell out (ADR-SPELL:1) and it is not the return value
(ADR-SPELL:10) — name it after the **simple type of what it holds**: a `[System.Text.StringBuilder]` is `$stringBuilder`, a `[hashtable]` is
`$hashtable`, a `[regex]` is `$regex`, an `[xml]` is `$xml`. The type is a true, self-describing name when there is nothing more specific to
say, and it keeps scratch and working variables consistent across the codebase instead of a scatter of `$sb` / `$temp` / `$thing`. It is the
default of last resort — below meaning, below role.

- [Role, then type](#role-then-type)

### Rule ADR-SPELL:12

A short-lived, throwaway intermediate — a value assigned and consumed within a tight, co-located window (roughly 10–15 lines) that has no
domain meaning worth naming (ADR-SPELL:1), no return role (ADR-SPELL:10), and no type worth stating (ADR-SPELL:11) — takes a **generic
blessed placeholder** rather than a coined bespoke name. The sanctioned generic is **`$obj`**. This is what keeps trivial scratch from
minting one-off vocabulary — the `myapp` / `myvalue` / `myproject` / `myvar` placeholders that otherwise each need a `fixture` registry
entry just to clear the spelling gate. It applies equally to example and test placeholder data: reach for the generic blessed token (`$obj`,
`'obj'`) before coining a new word. The bar is deliberately high — `$obj` is for the genuinely nameless intermediate, never a licence to
blur a value that has a real meaning, a return role, or a type worth a glance.

- [Role, then type](#role-then-type)

## Context

This codebase is infrastructure automation. Its functions are read far more often than they are written — during an incident, in code
review, by someone who has never opened the file before — and they are read by people reasoning about money, networks, and access. A name is
the densest documentation a reader gets, and an abbreviated name spends that budget badly.

### Why this matters

**A name is read many times and written once.** `$protos` saves five keystrokes the day it is typed and charges a small translation tax to
every later reader. Translation is where bugs hide: `$protos` and `$ports` blur together at a glance, while `$protocols` and `$ports` do
not. The full word is self-describing; the abbreviation is a puzzle whose answer lives only in the author's head.

**Local abbreviations fragment the vocabulary.** Left to invention, one file's `$cfg` is another's `$conf` is another's `$settings`; one
`$rcg` means "rule collection group" and nothing to anyone else. Full words converge — everyone writes `$configuration` the same way — so
the codebase reads as one voice instead of a dozen personal dialects. Discovery and search work too: a reader can `grep` for `protocol` and
find every use, which `protos`/`proto`/`prot` defeat.

**Abbreviation is a false economy.** The editor completes `$configuration` on a few keystrokes; tab-completion erases the typing cost
entirely. What it cannot erase is the reading cost, which the abbreviation makes permanent.

### Allowed exceptions

Four categories keep their short form, because each is already as clear to a reader as the spelled-out version:

- **Loop indices.** `$i`, `$j`, `$k` in a counting loop are a universal idiom; `$index` is welcome but not required.
- **Acronyms that _are_ the name.** Nobody writes "comma-separated-values file" or "uniform-resource-locator" — the acronym is the canonical
  term, more recognizable than its expansion. CSV, JSON, URL, ID, HTTP, IP, UTC, API, CLI, DNS, TLS, SDK, GUID, and the like stay as-is.
- **PowerShell automatic variables.** `$_`, `$args`, `$PSItem`, `$PSCmdlet`, `$PSBoundParameters` are the language's own names.
- **The conventional-abbreviation allow-list.** A short, curated set that every developer reads without translating — `ctx`, `cfg`, `cmd`,
  `params`, `env`, `repo`, and the like. The authoritative list, with each term mapped to its full word, lives in the terminology registry
  (ADR-SPELL:5); it grows only by review, never by reflex.

The test for an exception is "is the short form a _standard, shared_ name recognized outside this repository, or on the curated allow-list?"
— not "is it shorter?" `$tfPath` and `$rcg` fail that test; `JSON` and `$ctx` pass it.

### Role, then type

Four things can name a local, in order of preference — meaning, then role, then type, then a generic placeholder.

- **Meaning** is best, and is what ADR-SPELL:1 asks for: `$subscription`, `$templateFolderPath`. A name that says what the value _means_ in
  the domain is the densest documentation a reader gets.
- **Role** comes next, for the one or two variables that _are_ the function's output: `$ret` for the accumulator built up and handed back,
  `$found` for what a lookup located (ADR-SPELL:10). The role name wins here because a reader scanning the function finds the return value
  at a glance, and it stays stable when the accumulator's type changes — a `[StringBuilder]` swapped for a `[List]` is still `$ret`.
- **Type** comes next (ADR-SPELL:11): a scratch buffer or working object with no domain meaning and no return role is named for the simple
  type it holds — `$stringBuilder`, `$hashtable`, `$regex`. Type-as-name says exactly what the value is and is shared (everyone names a
  scratch StringBuilder the same way), which is why it beats an invented `$sb` or `$temp`.
- **Generic placeholder** is the honest default of last resort (ADR-SPELL:12): a genuinely nameless, short-lived intermediate — no domain
  meaning, no return role, no type worth a glance — is `$obj`, rather than a coined bespoke name or a one-off `fixture` token. The bar is
  high: `$obj` is for the truly anonymous scratch value only, never a blur over something that has a real name.

So `$stringBuilder` is right for a StringBuilder used as a mid-function scratch buffer — but the same StringBuilder becomes `$ret` the
moment its role is "the value this function returns."

### The dictionary is the backstop

Two automatic backstops cover different reaches, and it is worth being precise about each. The shared spell-checker (`cspell.yml`, run by
`Test-Spelling`) flags a coined token none of its dictionaries recognize, but its `minWordLength` (4) lets short tokens through: `$ctx`,
`$rcg`, and `$tmpl` all pass cspell. The identifier-level rule `Measure-SpellOutIdentifiers` (ADR-SPELL:9) closes that gap — it tokenizes
identifiers and checks every fragment with no length floor against the same corpus (cspell's English words plus the registry terms), so the
short and compound coined abbreviations cspell misses (`$rcg`, `$tfPath`, `$perSubEnvs`) are caught automatically. What neither can catch is
an abbreviation that is _also_ a real dictionary word — `$spec`, `$info` — since membership alone cannot tell a truncation from a short
word; those stay a code-review concern. When either gate flags a token, there are two honest resolutions: spell it out, or — when it is a
genuine domain term or a conventional abbreviation worth blessing — add a deliberate, reviewed entry to the terminology registry
(ADR-SPELL:5). Dropping a one-off local invention into the vocabulary just to clear the gate is the anti-pattern this rule forbids; adding a
genuinely conventional abbreviation as a categorized registry entry is the opposite — a reviewed decision the whole team then shares.

### Identifiers, not data

The rule is about names the code chooses, not data it carries. A CSV column called `Protos`, an Azure property named `addrPrefix`, or an API
field `acct_id` is part of an external contract: the code reads and writes it under its real key and must not rename it. Spell out the
_variable_ that holds such a value (`$accountId = $row.acct_id`), but leave the external key exactly as the outside system spells it.

### The terminology registry

The allow-list of ADR-SPELL:2 and the domain glossary of ADR-SPELL:3 are not two piles of tokens in the spell-checker's config; they are one
authored registry, `terminology.yml`, and the spell-checker's word lists are generated from it. A flat list of accepted words answers only
"is this token spelled legally?" — it cannot say what a term means, where it is legitimate, or whether anything still uses it. So the same
token that silences the gate is silently blessed everywhere and forever, and the next author reads the coinage as sanctioned vocabulary. The
registry keeps the meaning attached to the term and makes generation the only way a word reaches the checker (ADR-SPELL:5), so the accepted
set is always exactly the authored set.

Each entry is grouped under a category (ADR-SPELL:6), and the category is what drains that ambiguity:

- **`domain`** — a real product, tool, protocol, or external field name (`bicep`, `entra`). Kept as-is, with a one-line meaning; legal
  everywhere.
- **`abbreviation`** — a conventional short form from the ADR-SPELL:2 allow-list (`ctx`, `cfg`). It carries its full-word expansion, and an
  abbreviation without one is rejected.
- **`fixture`** — external-shaped data that appears only in test assets, such as a sample resource name (ADR-SPELL:4). Scoped to test assets
  so it cannot bless a real identifier.

A token in none of these is not in the registry at all: the checker flags it and it is spelled out. That is where a coined local shorthand
like `$tfPath` belongs.

### From backstop to registry

The spell-checker is a backstop, not an intake. When it flags a token, the token is a candidate for review, not something a tool may accept
on its own (ADR-SPELL:7): a human either spells it out or adds a categorized registry entry that explains it. Auto-appending flagged tokens
to the accepted list is the junk drawer this ADR forbids — it teaches the vocabulary it was only meant to tolerate.

The registry also stays honest about what is live. A term worth keeping is used consistently and stays referenced; an entry no code
references is dead vocabulary and is removed (ADR-SPELL:8). The terminology gate enforces both directions — a flagged coinage cannot enter
except as a reviewed entry, and an unreferenced entry cannot remain.

## Decision

Spell out identifier names in full. Abbreviate only the universal acronyms and loop indices in ADR-SPELL:2, and coin nothing local. A domain
term worth keeping is added to the terminology registry and used consistently; everything else is written as the real, whole word.

This is the variable-and-parameter complement to the function-naming rules in [respect-pwsh-verb-rules](respect-pwsh-verb-rules.md): verbs
gives functions a shared, spelled-out vocabulary, and this gives the same to the names inside them.

### How this is enforced

- **`Measure-SpellOutIdentifiers`** (custom PSScriptAnalyzer rule, ADR-SPELL:9, in the L2 analyzer gate) is the primary automatic enforcer:
  it tokenizes every variable name, parameter name, and function noun and flags any fragment that is neither a real English word nor an
  approved registry term, with no minimum length — so it catches the short and compound coined abbreviations (`$rcg`, `$tfPath`) that
  cspell's `minWordLength` lets through. A flagged fragment is spelled out or blessed as a reviewed registry entry (ADR-SPELL:7).
- **cspell / `Test-Spelling`** (the L2 spelling gate) is the complementary net over prose and comments (not just identifiers); it flags
  coined tokens its dictionaries do not recognize. A blessed term added to the terminology registry (ADR-SPELL:3) is a reviewed change
  visible in the diff.
- **Code review** covers what neither gate can: an abbreviation that is also a real dictionary word (`$spec`, `$info`, `$prop`), which
  membership alone cannot distinguish from a genuine short word, is spelled out in review.
- **`Test-Terminology`** is the gate over the registry itself: it fails when the generated word lists differ from the registry
  (ADR-SPELL:5), when an entry lacks a category, a meaning, or an abbreviation's expansion (ADR-SPELL:6), or when an entry is unreferenced
  in the tree (ADR-SPELL:8). `Build-TerminologyDictionary` regenerates the lists from the registry.
- **The English half of the oracle is a committed, version-stamped artifact.** `Build-EnglishDictionary` flattens cspell's bundled `en`/
  `en-GB` dictionaries to `assets/english.txt.gz` and writes a sidecar `assets/english.stamp` recording the cspell + dict versions it was
  built from. Regenerating needs node, so — like the compiled-type prebuild (ADR-OUTDIR:5) — the artifact is committed rather than rebuilt
  at import. A drift gate (`Build-EnglishDictionary.Tests.ps1`) compares the stamp's cspell version against the `tools.yml` pin and its word
  count against the gz, with no node round-trip, so a cspell bump that leaves the dictionary stale fails in CI with "re-run
  Build-EnglishDictionary".

## Consequences

- Functions read as plain language; a reader unfamiliar with a file can follow it without reconstructing what each shortened name meant.
- Search and refactoring are reliable — one spelling per concept means `grep`/rename find every occurrence.
- The terminology registry becomes a meaningful glossary of real domain terms, and each new entry is a small, deliberate decision rather
  than a reflex to silence the gate.
- The cost lands on the author (a few more keystrokes, fully absorbed by tab-completion), and the benefit lands on every reader.
