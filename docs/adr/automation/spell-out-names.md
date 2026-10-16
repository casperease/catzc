---
catzc:
  derived:
    path: docs/adr/automation/spell-out-names.md
    kind: adr
    language: markdown
    filetype: md
    track: docs
    body_sha: "9a5905f33231"
    defines:
      - ADR-AUTO-SPELL#{1-8}
    adrs:
      - ADR-PWSH-NAMES#1
      - ADR-REPO-OUTDIR#5
    links:
      - docs/adr/pwsh/identifier-names.md
      - docs/adr/pwsh/identifier-names.md#rule-adr-pwsh-names1
      - docs/adr/pwsh/identifier-names.md#rule-adr-pwsh-names6
      - docs/adr/pwsh/respect-pwsh-verb-rules.md
---

# ADR: Spell out names — no invented abbreviations

## Rules: ADR-AUTO-SPELL

### Rule ADR-AUTO-SPELL:1

Identifiers — variable names, parameter names, the keys of a map, and the nouns in command names — use full, spelled-out words. Write
`protocols`, not `protos`; `ruleCollectionGroup`, not `rcg`; `templateFolderPath`, not `tfPath`; `stringBuilder`, not `sb`. No truncated
words, no dropped vowels, and no locally-invented acronyms. (A short list of conventional abbreviations — `ctx`, `cfg`, `cmd`, … — is
exempt; see ADR-AUTO-SPELL#2.)

- [Why this matters](#why-this-matters)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-SPELL:2

The only abbreviations allowed without spelling out are: single-letter loop indices (`i`, `j`, `k`); the small set of universal,
industry-standard acronyms that ARE the canonical name for a thing (CSV, JSON, YAML, URL, URI, ID, HTTP, IP, UTC, API, CLI, DNS, TLS, SDK,
GUID, regex, UTF, BOM); the engine's own automatic variables; and a short, curated allow-list of conventional abbreviations that every
developer reads fluently (`ctx`, `cfg`, `cmd`, `params`, `env`, `repo`, …). That allow-list — each term mapped to its full word — is the
authoritative set, authored as `abbreviation` entries in the terminology registry (ADR-AUTO-SPELL#5, ADR-AUTO-SPELL#6). Everything else is
spelled out, and an invented local shorthand (`tfPath`, `perSubEnvs`, `expectedMgr`) is never added to the registry to silence the gate
(ADR-AUTO-SPELL#3).

- [Allowed exceptions](#allowed-exceptions)

### Rule ADR-AUTO-SPELL:3

The curated vocabulary is authored in one place — the terminology registry (ADR-AUTO-SPELL#5) — which carries both genuine product terms
kept as-is (a real product, protocol, tool, or external field name) and the conventional-abbreviation allow-list of ADR-AUTO-SPELL#2, each
as a categorized entry (ADR-AUTO-SPELL#6). It grows only by review. A term worth keeping earns a reviewed entry, used consistently
everywhere; a term not worth that is not worth coining. What the rule forbids is the reflex of dropping a one-off local shorthand (`tfPath`,
`perSubEnvs`) into the vocabulary just to clear the gate — that is a junk drawer, not curation (ADR-AUTO-SPELL#7).

- [The dictionary is the backstop](#the-dictionary-is-the-backstop)

### Rule ADR-AUTO-SPELL:4

This governs identifiers, not data. String literals, CSV headers, Azure resource-property names, and external API response keys keep their
source spelling — renaming them would break the contract with the outside system.

- [Identifiers, not data](#identifiers-not-data)

### Rule ADR-AUTO-SPELL:5

Approved vocabulary has one authored source — the terminology registry (`terminology.yml`) — and the spell-checker's accepted-word lists are
generated from it, never hand-edited or auto-appended. A gate fails when the generated lists differ from the registry, so the two cannot
drift.

- [The terminology registry](#the-terminology-registry)

### Rule ADR-AUTO-SPELL:6

Every registry entry is grouped under a category and declares a meaning. The `terms:` map groups entries by category — the group is the
entry's category, so there is no per-entry category field. The allowed categories are defined in the registry's `categories:` map, each a
named vocabulary class with a description, and `TerminologyConfig` validates every group against it, so the category set is data, not
hardcoded. They are the enforced form of the distinctions drawn in ADR-AUTO-SPELL#2 and ADR-AUTO-SPELL#4.

- [The terminology registry](#the-terminology-registry)

### Rule ADR-AUTO-SPELL:7

A token the spell-checker flags is a candidate for review, never an automatic acceptance: it joins the vocabulary only as a categorized
registry entry a human adds. No tool registers a flagged token on its own.

- [From backstop to registry](#from-backstop-to-registry)

### Rule ADR-AUTO-SPELL:8

The registry holds only live vocabulary. An entry no code in the tree references is removed, and `Test-Terminology` rejects an unreferenced
entry.

- [From backstop to registry](#from-backstop-to-registry)

## Context

This codebase is infrastructure automation. Its functions are read far more often than they are written — during an incident, in code
review, by someone who has never opened the file before — and they are read by people reasoning about money, networks, and access. A name is
the densest documentation a reader gets, and an abbreviated name spends that budget badly.

### Why this matters

**A name is read many times and written once.** `protos` saves five keystrokes the day it is typed and charges a small translation tax to
every later reader. Translation is where bugs hide: `protos` and `ports` blur together at a glance, while `protocols` and `ports` do not.
The full word is self-describing; the abbreviation is a puzzle whose answer lives only in the author's head.

**Local abbreviations fragment the vocabulary.** Left to invention, one file's `cfg` is another's `conf` is another's `settings`; one `rcg`
means "rule collection group" and nothing to anyone else. Full words converge — everyone writes `configuration` the same way — so the
codebase reads as one voice instead of a dozen personal dialects. Discovery and search work too: a reader can `grep` for `protocol` and find
every use, which `protos`/`proto`/`prot` defeat.

**Abbreviation is a false economy.** The editor completes `configuration` on a few keystrokes; tab-completion erases the typing cost
entirely. What it cannot erase is the reading cost, which the abbreviation makes permanent.

### Allowed exceptions

Four categories keep their short form, because each is already as clear to a reader as the spelled-out version:

- **Loop indices.** `i`, `j`, `k` in a counting loop are a universal idiom; `index` is welcome but not required.
- **Acronyms that _are_ the name.** Nobody writes "comma-separated-values file" or "uniform-resource-locator" — the acronym is the canonical
  term, more recognizable than its expansion. CSV, JSON, URL, ID, HTTP, IP, UTC, API, CLI, DNS, TLS, SDK, GUID, and the like stay as-is.
- **The engine's automatic variables.** The names an engine defines for itself are its own vocabulary, not a choice the author made; the
  PowerShell set is [identifier-names](../pwsh/identifier-names.md#rule-adr-pwsh-names6).
- **The conventional-abbreviation allow-list.** A short, curated set that every developer reads without translating — `ctx`, `cfg`, `cmd`,
  `params`, `env`, `repo`, and the like. The authoritative list, with each term mapped to its full word, lives in the terminology registry
  (ADR-AUTO-SPELL#5); it grows only by review, never by reflex.

The test for an exception is "is the short form a _standard, shared_ name recognized outside this repository, or on the curated allow-list?"
— not "is it shorter?" `tfPath` and `rcg` fail that test; `JSON` and `ctx` pass it.

A local whose meaning is its role or its type, or that has no meaning at all, takes a blessed name rather than a coined one; the PowerShell
conventions for those names are [identifier-names](../pwsh/identifier-names.md).

### The dictionary is the backstop

Two automatic backstops cover different reaches, and it is worth being precise about each. The shared spell-checker (`cspell.yml`, run by
`Test-Spelling`) flags a coined token none of its dictionaries recognize, but its `minWordLength` (4) lets short tokens through: `ctx`,
`rcg`, and `tmpl` all pass cspell. The identifier-level analyzer rule ([ADR-PWSH-NAMES#1](../pwsh/identifier-names.md#rule-adr-pwsh-names1))
closes that gap — it tokenizes identifiers and checks every fragment with no length floor against the same corpus (cspell's English words
plus the registry terms), so the short and compound coined abbreviations cspell misses (`rcg`, `tfPath`, `perSubEnvs`) are caught
automatically. What neither can catch is an abbreviation that is _also_ a real dictionary word — `spec`, `info` — since membership alone
cannot tell a truncation from a short word; those stay a code-review concern. When either gate flags a token, there are two honest
resolutions: spell it out, or — when it is a genuine product term or a conventional abbreviation worth blessing — add a deliberate, reviewed
entry to the terminology registry (ADR-AUTO-SPELL#5). Dropping a one-off local invention into the vocabulary just to clear the gate is the
anti-pattern this rule forbids; adding a genuinely conventional abbreviation as a categorized registry entry is the opposite — a reviewed
decision the whole team then shares.

### Identifiers, not data

The rule is about names the code chooses, not data it carries. A CSV column called `Protos`, an Azure property named `addrPrefix`, or an API
field `acct_id` is part of an external contract: the code reads and writes it under its real key and must not rename it. Spell out the
_variable_ that holds such a value (`accountId`, read from `acct_id`), but leave the external key exactly as the outside system spells it.

### The terminology registry

The allow-list of ADR-AUTO-SPELL#2 and the product glossary of ADR-AUTO-SPELL#3 are not two piles of tokens in the spell-checker's config;
they are one authored registry, `terminology.yml`, and the spell-checker's word lists are generated from it. A flat list of accepted words
answers only "is this token spelled legally?" — it cannot say what a term means, where it is legitimate, or whether anything still uses it.
So the same token that silences the gate is silently blessed everywhere and forever, and the next author reads the coinage as sanctioned
vocabulary. The registry keeps the meaning attached to the term and makes generation the only way a word reaches the checker
(ADR-AUTO-SPELL#5), so the accepted set is always exactly the authored set.

Each entry is grouped under a category (ADR-AUTO-SPELL#6), and the category is what drains that ambiguity:

- **`product`** — a real product, tool, protocol, or external field name (`bicep`, `entra`). Kept as-is, with a one-line meaning; legal
  everywhere.
- **`abbreviation`** — a conventional short form from the ADR-AUTO-SPELL#2 allow-list (`ctx`, `cfg`). It carries its full-word expansion,
  and an abbreviation without one is rejected.
- **`fixture`** — external-shaped data that appears only in test assets, such as a sample resource name (ADR-AUTO-SPELL#4). Scoped to test
  assets so it cannot bless a real identifier.

A token in none of these is not in the registry at all: the checker flags it and it is spelled out. That is where a coined local shorthand
like `tfPath` belongs.

### From backstop to registry

The spell-checker is a backstop, not an intake. When it flags a token, the token is a candidate for review, not something a tool may accept
on its own (ADR-AUTO-SPELL#7): a human either spells it out or adds a categorized registry entry that explains it. Auto-appending flagged
tokens to the accepted list is the junk drawer this ADR forbids — it teaches the vocabulary it was only meant to tolerate.

The registry also stays honest about what is live. A term worth keeping is used consistently and stays referenced; an entry no code
references is dead vocabulary and is removed (ADR-AUTO-SPELL#8). `Test-Terminology` enforces both directions — a flagged coinage cannot
enter except as a reviewed entry, and an unreferenced entry cannot remain.

## Decision

Spell out identifier names in full. Abbreviate only the universal acronyms and loop indices in ADR-AUTO-SPELL#2, and coin nothing local. A
product term worth keeping is added to the terminology registry and used consistently; everything else is written as the real, whole word.

This is the variable-and-parameter complement to the function-naming rules in [respect-pwsh-verb-rules](../pwsh/respect-pwsh-verb-rules.md):
verbs gives functions a shared, spelled-out vocabulary, and this gives the same to the names inside them.

### How this is enforced

- **The identifier analyzer rule** ([ADR-PWSH-NAMES#1](../pwsh/identifier-names.md#rule-adr-pwsh-names1), in the L2 `Test-ScriptAnalyzer`
  quality gate) is the primary automatic enforcer: it tokenizes every variable name, parameter name, and function noun and flags any
  fragment that is neither a real English word nor an approved registry term, with no minimum length — so it catches the short and compound
  coined abbreviations (`rcg`, `tfPath`) that cspell's `minWordLength` lets through. A flagged fragment is spelled out or blessed as a
  reviewed registry entry (ADR-AUTO-SPELL#7).
- **cspell / `Test-Spelling`** (the L2 spelling quality gate) is the complementary net over prose and comments (not just identifiers); it
  flags coined tokens its dictionaries do not recognize. A blessed term added to the terminology registry (ADR-AUTO-SPELL#3) is a reviewed
  change visible in the diff.
- **Code review** covers what neither gate can: an abbreviation that is also a real dictionary word (`spec`, `info`, `prop`), which
  membership alone cannot distinguish from a genuine short word, is spelled out in review.
- **`Test-Terminology`** is the gate over the registry itself: it fails when the generated word lists differ from the registry
  (ADR-AUTO-SPELL#5), when an entry lacks a category, a meaning, or an abbreviation's expansion (ADR-AUTO-SPELL#6), or when an entry is
  unreferenced in the tree (ADR-AUTO-SPELL#8). `Build-TerminologyDictionary` regenerates the lists from the registry.
- **The English half of the oracle is a committed, version-stamped artifact.** `Build-EnglishDictionary` flattens cspell's bundled `en`/
  `en-GB` dictionaries to `assets/english.txt.gz` and writes a sidecar `assets/english.stamp` recording the cspell + dict versions it was
  built from. Regenerating needs node, so — like the compiled-type prebuild (ADR-REPO-OUTDIR#5) — the artifact is committed rather than
  rebuilt at import. A drift check (`Build-EnglishDictionary.Tests.ps1`) compares the stamp's cspell version against the `tools.yml` pin and
  its word count against the gz, with no node round-trip, so a cspell bump that leaves the dictionary stale fails in CI with "re-run
  Build-EnglishDictionary".

## Consequences

- Functions read as plain language; a reader unfamiliar with a file can follow it without reconstructing what each shortened name meant.
- Search and refactoring are reliable — one spelling per concept means `grep`/rename find every occurrence.
- The terminology registry becomes a meaningful glossary of real product terms, and each new entry is a small, deliberate decision rather
  than a reflex to silence the gate.
- The cost lands on the author (a few more keystrokes, fully absorbed by tab-completion), and the benefit lands on every reader.
