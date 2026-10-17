---
catzc:
  immutable:
    repo_status: clean
    path: docs/adr/automation/managed-guids.md
    folder: docs/adr/automation
    name: managed-guids
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-AUTO-GUIDS#{1-6}
    cites:
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#4
    links:
      - docs/adr/automation/spell-out-names.md
      - docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8
      - docs/adr/automation/test-automation.md#rule-adr-auto-test35
      - docs/adr/configuration/module-config-loading.md
      - docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4
      - docs/adr/principles/everything-as-code.md
      - docs/adr/repository/protected-globs.md#rule-adr-repo-protglob6
---

# ADR: Managed GUIDs — every GUID literal is a registered, described identity

## Rules: ADR-AUTO-GUIDS

### Rule ADR-AUTO-GUIDS:1

Every GUID literal in tracked text — code, configs, fixtures, pipelines, docs — is registered in the managed-GUID registry,
`automation/Catzc.Base.QualityGates/configs/guids.yml`. No exceptions by location: a GUID in the tree is configuration
([everything-as-code](../principles/everything-as-code.md)), and an unbound GUID is drift.

- [The registry](#the-registry)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-GUIDS:2

A registry entry is name-keyed and strict: `<snake_case_name>: { guid, description [, sentence] }`. The `guid` is canonical (lowercase,
hyphenated), guid values are unique across entries — a GUID has exactly one registered name — and unknown keys are rejected. The registry
also carries a `denied:` non-allow list — values that are never a legitimate identity, headed by the all-zeros GUID: a denied value can
never be registered under `guids:` (the config type rejects the overlap) and must never appear in tracked text (the gate names it as denied;
code that needs it constructs it at runtime, e.g. `[guid]::Empty`). Its config type, `GuidsConfig`, validates the file on load, collecting
every violation into one throw.

- [The registry](#the-registry)

### Rule ADR-AUTO-GUIDS:3

Two entry classes, one table. An **external-facing** GUID — a well-known platform id, a real tenant or subscription id — is registered
as-is, because its value is fixed by the outside world. A **placeholder** GUID — a fixture id, a demo value proving tooling loads and
content validates — is minted by a human or an LLM with `ConvertTo-Guid`, so the value best-effort spells its `sentence` (leet-style:
`s`→`5`, `o`→`0`, `i`/`l`→`1`) and reads as a placeholder on sight. Production code never mints: the `SentenceGuid` engine exists to fill
the registry, not to generate identity at runtime.

- [The mint](#the-mint)

### Rule ADR-AUTO-GUIDS:4

The registry holds only live entries, and the gate enforces both directions: a GUID found in tracked text but absent from the registry fails
the test run, and a registry entry no tracked file references is dead vocabulary and fails too — the same liveness discipline as the
terminology registry ([spell-out-names](spell-out-names.md#rule-adr-auto-spell8)).

- [The gate](#the-gate)

### Rule ADR-AUTO-GUIDS:5

The scan matches the canonical hyphenated GUID form only, never bare 32-hex — bare hex would false-positive on hashes (the durable SHAs are
64 hex and unhyphenated, so they never match). The universe is tracked files (`git ls-files`), minus vendored third-party code, the compiled
assembly, binary extensions, and the registry file itself — the registry is the definition of the managed set, not a reference to it.

- [The gate](#the-gate)

### Rule ADR-AUTO-GUIDS:6

cspell never sees a GUID: the spelling config carries an `ignoreRegExpList` pattern for the hyphenated form, so GUID hex fragments generate
no spelling noise and need no `cspell:ignore` comments. One gate owns words (cspell + the terminology registry); one owns GUIDs (this gate).
A GUID identity check in code goes through `Assert-ManagedGuid` / `Test-ManagedGuid`, never a hand-rolled registry read.

- [Division of ownership](#division-of-ownership)

## Context

GUIDs accumulate in an infrastructure repository: real tenant and subscription ids in the identity config, well-known platform ids (an OAuth
resource, a policy type, a project-type id), and — most numerous — placeholder values in fixtures, function help, and docs that exist only
to prove tooling loads and content validates. Unmanaged, they are opaque: a reader cannot tell a real id from a demo value, a leaked
production identity from an arbitrary token, or which fixture a value belongs to. And nothing stops a new, unexplained GUID from entering
the tree.

The repair is the registry pattern the repository already applies to vocabulary ([spell-out-names](spell-out-names.md)): one authored source
of truth, deliberate reviewed entries, a liveness rule, and a gate that enforces membership both ways.

### The registry

`configs/guids.yml` in `Catzc.Base.QualityGates` is the single table, read through `Get-Config -Config guids`
([module-config-loading](../configuration/module-config-loading.md)) and validated by its config type, `GuidsConfig`. Entries are keyed by a
snake_case name — readable diffs, and the duplicate-guid check lives in the config type where YAML's silent last-key-wins cannot hide it.
`description` says what the GUID identifies; `sentence` is present exactly when the value was minted from a sentence, so a minted
placeholder carries its own decoding.

The `denied:` section is the inverse table: values that are never a legitimate identity, with the all-zeros GUID as its first entry — it is
the unset/default value (and `SentenceGuid`'s output for an input with no mappable characters), so registering it would bless every
uninitialized field that happens to render it. A denied entry has the same name/guid/description shape but never a `sentence` (a denied
value is not minted for use), and its liveness rule is inverted: a `guids:` entry must be referenced somewhere, a `denied:` entry must be
referenced nowhere.

### The mint

`ConvertTo-Guid` (over the native type `Catzc.Base.QualityGates.SentenceGuid`) deterministically converts any sentence into a valid GUID
whose hex digits best-effort spell it: hex letters and digits pass through, the leet look-alike table maps (`o`→`0`, `i`/`l`→`1`, `z`→`2`,
`s`→`5`, `g`→`6`, `t`→`7`, `q`→`9`), and any other character renders as `0` — one character in is always one digit out, so a human decodes
the value positionally. Whitespace is the exception with a purpose: it skips to the GUID's next dash group, so each word lands in its own
segment. The result pads with zeros to 32 hex digits, and validity is structural — any 32 hex digits parse as a GUID — so every input yields
one. `sample test data` becomes `5a001e00-7e57-da7a-0000-000000000000`: a reader sees the value and reads the words back out of the dash
groups.

The mint is an authoring tool. A person (or an LLM) runs it once to produce a registry entry and the literal that goes into the fixture; the
automation never calls it to generate identity at runtime, because a runtime-minted GUID would be an unregistered GUID by construction.

### The gate

`Get-RepositoryGuids` scans every tracked text file and returns one `@{ file; line; guid }` record per occurrence. Tracked files are the
same universe a globset matches against; the related flow rule is
[ADR-FLOW-CD-GLOBS#4](../flow/durable-sha-globs.md#rule-adr-flow-cd-globs4). The `Test-ManagedGuids` quality gate, run by the managed-guid
integrity test, reports every found guid that is not registered and every registry entry not found — with the registry file itself excluded
from the scan so an entry cannot vouch for its own liveness. The scan reads every tracked text file under every named root of the repository
plus its own config, so it protects against the whole-repository `repository` globset, which covers both
([protected-globs](../repository/protected-globs.md#rule-adr-repo-protglob6)): repeat local runs skip until a tracked file anywhere in the
repository changes, and CI always scans. The same gate reports a scanned file, or the registry, outside `repository`.

### Division of ownership

Tokenization makes cspell the wrong enforcer for GUID identity: it splits on hyphens and letter/digit boundaries, so a GUID never survives
as one token — a blessed fragment from one registered GUID would silently bless the same fragment inside an unregistered one, and the
reverse "this entry is dead" direction is inexpressible. So the spelling layer ignores the GUID form entirely, and this gate owns it with
exact-match semantics.

## Decision

Every GUID literal in tracked text is a registered entry in `guids.yml` — external-facing values as-is, placeholders minted with
`ConvertTo-Guid` so the value spells its sentence — validated on load, enforced both directions by the repository-wide `Test-ManagedGuids`
quality gate, and invisible to cspell.

### How this is enforced

- **`GuidsConfig`** (the C# config type registered for `guids` in `configs.yml`) — validates the registry's shape, canonical guid form, guid
  uniqueness, and strict keys on every load.
- **`Test-ManagedGuids`** — the quality gate ([ADR-AUTO-TEST#35](test-automation.md#rule-adr-auto-test35)) over the repository-wide scan
  (`Get-RepositoryGuids`): every guid in tracked text is registered, none is denied, and every entry is referenced. The **managed-guid
  integrity test** (`Get-RepositoryGuids.Tests.ps1`) runs it, protected-globs-wrapped for the local inner loop.
- **`Assert-ManagedGuid` / `Test-ManagedGuid`** — the one shared lookup (`Resolve-ManagedGuid`) behind the throwing and boolean checks, for
  any code or operator that needs to assert a GUID against the table.
- **The cspell config** (`ignoreRegExpList`, in the source of the managed root `cspell.yml`) — keeps GUID fragments out of `Test-Spelling`,
  so the two quality gates cannot double-report.
- **Code review** — classifies a new entry (external-facing vs placeholder) and checks a placeholder was minted, not invented.

## Consequences

- A GUID in the tree is never anonymous: the registry names it, describes it, and — for minted placeholders — decodes it.
- A new GUID cannot enter the repository silently; registering it is a reviewed diff beside the change that introduces it.
- Placeholder values become self-describing (`a100a000-7e57-7e0a-07…` reads "alpha test tenant"), so fixtures are legible at the value
  itself, not only at the registry.
- Dead identities cannot accumulate: removing a GUID's last reference forces its entry out in the same change.
- The cost is one registry entry per GUID and the discipline to mint rather than invent — a small tax that buys an inventory of every
  identity the repository carries.
