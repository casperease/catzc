---
catzc:
  derived:
    path: docs/adr/repository/controlled-vocabulary.md
    kind: adr
    language: markdown
    filekind: md
    track: docs
    body_sha: e303a0153364
    defines:
      - ADR-REPO-VOCAB#{1-8}
    adrs:
      - ADR-AUTO-TEST#9
    links:
      - docs/adr/automation/sensible-defaults.md
      - docs/adr/automation/spell-out-names.md
      - docs/adr/automation/zero-ceremony-poka-yoke.md
      - docs/adr/configuration/module-config-loading.md
      - docs/adr/design/module-aspects.md
      - docs/adr/index.md#authoring-conventions
      - docs/adr/principles/everything-as-code.md
      - docs/adr/process/process-terms.md
      - docs/adr/repository/domain-language-separation.md
---

# ADR: Controlled vocabulary — one definition per term, opt-in glossary sources

## Rules: ADR-REPO-VOCAB

### Rule ADR-REPO-VOCAB:1

A **defined term** has exactly one meaning, fixed by exactly one ADR rule whose normative summary bolds it (`A **<term>** is …`). A term
used with a private or shifting meaning, or defined a second time elsewhere, is a defect — the same way an undeclared identifier is.

- [One term, one rule](#one-term-one-rule)

### Rule ADR-REPO-VOCAB:2

A **glossary source** is a module's `configs/glossary.yml`; it registers that module's defined terms, and using one is opt-in. Nothing is
checked against a term until a source declares it. A source's `options:` are parameters with sensible defaults — which checks its terms take
part in, where and on which text surfaces its avoided phrasings are scanned — and a source overrides only what differs.

- [Opt-in sources](#opt-in-sources)

### Rule ADR-REPO-VOCAB:3

Every glossary source is in the repository, and so is everything it refers to: the defining rule is an ADR under `docs/adr/`, a realization
pattern and a scan glob are repo-relative, a contrast or relation target is another defined term. A source never holds a URL, and external
vocabulary (DORA) enters only through its in-repository reference and the ADR that cites it.

- [Everything in the repository](#everything-in-the-repository)

### Rule ADR-REPO-VOCAB:4

Similar terms are contrasted. A concept that names a similar term explains, in one sentence, how it differs; the contrast is reciprocal, so
both terms carry an explanation of the difference.

- [Contrasts](#contrasts)

### Rule ADR-REPO-VOCAB:5

An avoided phrasing is named together with its replacement. Within a source's scope, prose that uses an avoided phrasing is a defect; a
_mention_ — the phrase inside backticks or quotes — is exempt, so the vocabulary can talk about itself.

- [Avoided phrasings](#avoided-phrasings)

### Rule ADR-REPO-VOCAB:6

A concept declares how it exists in the repository (`realized_by`). A concept realized in code — a folder, file pattern, tag, config key,
type, function, or artifact — has at least one enforcer citing its defining rule; a `prose-only` concept says so explicitly and carries no
pattern.

- [Realized concepts are enforced](#realized-concepts-are-enforced)

### Rule ADR-REPO-VOCAB:7

The repository's conventions and decision records — its ADRs and the rules they state — are its **domain rules**, also called ADR rules.
Prose names them that way; an informal stand-in such as "house rules" is an avoided phrasing (ADR-REPO-VOCAB#5).

- [Domain rules](#domain-rules)

### Rule ADR-REPO-VOCAB:8

A term that names a family declares its **forms** — the words that may qualify its head word. Within a source's scope, any other qualified
use, and the head word used as a verb, is a defect; the bare head word is always allowed, and a mention is exempt (ADR-REPO-VOCAB#5). The
general words **source**, **layer**, **facet**, and **scope** are such families too: each takes only its declared forms, and its verb forms
("sourced", "layered", "faceted", "scoped") stay ordinary English (`verbs: true`).

- [Qualified forms](#qualified-forms)

## Context

The repository already controls its words at the spelling level: `terminology.yml` approves every token, and `Test-Terminology` and the
spell-checker keep that list honest ([spell-out-names](../automation/spell-out-names.md)). Spelling is not meaning. A correctly spelled word
can still carry several meanings — "suite" names every test in the repository, a tier, a category, a run mode, a gate's own tests, and a
pipeline payload, all in the same tree — and nothing in a spelling list can tell those apart.

Meaning is fixed in prose. [process-terms](../process/process-terms.md) is the model: one article that pins the flow vocabulary so the other
process ADRs can reason with it. But prose alone leaves three things unchecked: which rule defines a term, whether other text drifts to a
different word for it, and whether the concept a term names is enforced anywhere. This ADR turns the glossary discipline into a controlled
vocabulary those three questions can be asked of mechanically.

### One term, one rule

A definition belongs to an ADR, because an ADR owns decisions and their rationale ([index](../index.md#authoring-conventions)). The glossary
does not restate the definition; it points at the one rule that holds it (`defined_by`) and adds a one-line summary for readers and
messages. Anchoring every term on one rule makes the definition findable and makes a second definition detectable — two rules that both bold
the same term as its definition is the contradiction the rule forbids.

### Opt-in sources

`Opt-in sources with sensible defaults`

A glossary source is a module's `configs/glossary.yml`, so the module that owns a concept owns its vocabulary, and the folder convention is
the registration ([zero-ceremony-poka-yoke](../automation/zero-ceremony-poka-yoke.md)). A module without a source contributes no terms and
has nothing checked on its behalf. Within a source, `options:` sets the checks its terms take part in (`checks`), where its avoided
phrasings are scanned (`scope`, `exclude`), and which kinds of text are read there (`surfaces`). Every option has a default that suits most
sources, so most sources carry no options at all ([sensible-defaults](../automation/sensible-defaults.md)). The default excludes — the DORA
research text, generated output, vendored code — are always kept, because external language is not this repository's to correct.

### Everything in the repository

A glossary is part of the codebase it governs, and it is versioned, reviewed, and checked like the rest of it
([everything-as-code](../principles/everything-as-code.md)). A URL would make a definition depend on something that can change or vanish
without a commit, and would make the checks depend on the network. So a definition is an in-repository ADR rule, every pattern and glob is
repo-relative, and outside vocabulary arrives through the repository's own reference material.

### Contrasts

`Contrasts make neighbouring terms distinct`

Most confusion is between near neighbours, not distant words: a test suite and a test run, a release candidate and a deployable unit. A
definition read alone rarely settles which is meant. A contrast — one sentence on how this concept differs from a named neighbour — does,
and requiring it on both sides keeps the pair from drifting apart in one direction only.

### Avoided phrasings

`Avoided phrasings name their replacement`

A phrasing that blurs a defined term is listed as avoided, with the wording to use instead, so a violation always carries its fix. The rule
is about _use_, not _mention_: the ADR that defines a term, the glossary itself, and guidance that says "avoid `X`" all need to write the
avoided phrase, and they do so inside backticks or quotes.

### Qualified forms

`One word, its declared forms, nothing else`

An avoided phrasing catches only what someone thought to list. A word that names a family — `gate`, which is any flow decision point and,
qualified, one kind of it — drifts the other way: every new check, guard, or verb use borrows it, until "gate" names five things and none
precisely. Declaring the family's forms closes the set. `gate` takes `quality`, `CI`, `AT`, `RC`, `RBC`, `release`, `manual`, `PR`, `merge`,
`commit`, `approval`, `production`, and `push`; anything else is reworded — a check inside a quality gate is a **check**, a precondition is
a **guard**, and the verb becomes what the gate does ("blocks", "decides whether … proceeds"). Function words that only point at or count
the noun ("the gate", "each gate", "two gates") are not qualifiers, so they are always allowed.

Two of the general families are easy to confuse. A **layer** is a level in a stack: one sits on or contains the next (language under
PowerShell under installer; a fileset inside a module). A **facet** is one of several parallel views of, or checks on, the same thing: none
sits above another (a build's `Types`, `Load`, `Parity`, and `Manifest` facets; a module's disk and session facets). The parts a unit's
files partition into are **aspects** ([ADR-DSGN-ASPECT](../design/module-aspects.md)); a facet is never one of them.

### Realized concepts are enforced

A term that names something in code — a folder convention, a tag, a type — is only as reliable as the check behind it. `realized_by` records
where the concept lives, and a realized concept needs an enforcer citing its defining rule, found through the same rule-citation link that
`Show-Cats` reports. A pure vocabulary term (a flow measure, a principle) is `prose-only`: it has nothing in code to enforce, and saying so
is explicit rather than an absence.

### Domain rules

The vocabulary starts with the name of the rules themselves. A convention here is a decision with a rationale and a citation code, recorded
in an ADR and checked where it can be — not a habit of the house. Calling the conventions **domain rules**, or ADR rules when the source
matters, keeps that link visible in every conversation and review, and gives the glossary a first concept that is used everywhere and
realized nowhere in code (`prose-only`).

## Decision

Defined terms are registered in opt-in, in-repository glossary sources (`configs/glossary.yml`), one per owning module. Each concept points
at the one ADR rule that defines it, declares how it is realized, contrasts itself with its similar terms, and lists its avoided phrasings
with their replacements. A source's options default sensibly, and a source overrides only what differs.

### How this is enforced

- **`Catzc.Base.Docs.GlossaryConfig`** is the glossary source's type, registered for the `glossary` config in
  `Catzc.Base.Config/configs/configs.yml`, so every source is validated when it is read (`Get-Config -Config glossary -Module <owner>`). It
  checks the source's own shape: the allowed keys, the term, key, domain, and citation forms, a known realization kind with a pattern
  exactly when the kind is not `prose-only` (ADR-REPO-VOCAB#6), a replacement for every avoided phrase and no avoided phrase that is a
  defined term (ADR-REPO-VOCAB#5), an explanation for every contrast (ADR-REPO-VOCAB#4), repo-relative globs and no URL anywhere
  (ADR-REPO-VOCAB#3), and the option defaults (ADR-REPO-VOCAB#2). Every violation is reported in one throw.

- **`Get-GlossarySourceViolations`** (`Catzc.Base.Docs`) checks the facts that span more than one source, over every source
  `Get-GlossarySources` discovers (`Get-Config -Config glossary -ListOwners`): a term or machine key declared by two sources and a domain
  that `adrs.yml` does not declare (ADR-REPO-VOCAB#1), a contrast or relation target that no source defines and a source that git does not
  track (ADR-REPO-VOCAB#3), a contrast that is not reciprocal (ADR-REPO-VOCAB#4), and an avoided phrase that is another source's term
  (ADR-REPO-VOCAB#5). It names the source path and the term in one message per violation.

- **`Get-GlossaryAnchorViolations`** (`Catzc.Base.Docs`) checks that every term is anchored on its defining rule: its `defined_by` names a
  rule of an indexed ADR, and that rule's normative summary bolds the term (ADR-REPO-VOCAB#1). Only the normative summary counts — bold text
  in the ADR body, in the rule's linked bullets, or inside a code span never anchors a term.

- **`Get-GlossaryDefinitionViolations`** (`Catzc.Base.Docs`) checks that no rule other than the defining one defines the term a second time
  — a normative summary that says `**<term>** is` (ADR-REPO-VOCAB#1). A rule that merely bolds the term is not a definition, and ADR bodies
  are never read.

- **`Get-GlossaryEnforcementViolations`** (`Catzc.Base.Docs`) checks that every concept realized in code has an enforcer: an analyzer rule
  or a test that cites its defining rule, found through the same rule-citation link `Show-Cats` reports (ADR-REPO-VOCAB#6). A `prose-only`
  concept is exempt.

- **`Get-GlossaryPhrasingViolations`** (`Catzc.Base.Docs`) checks that prose avoids the avoided phrasings (ADR-REPO-VOCAB#5): in the tracked
  files a source's `scope` matches and its `exclude` does not, on the surfaces its `surfaces` name — markdown prose outside fenced code,
  and, read through the PowerShell parser, comments, comment-based help, and the static text of messages (`throw`, the `Write-*` writers,
  `-ErrorText`, `-Because`). A phrase matches case-insensitively, as whole words, across line breaks; a mention in backticks or quotes is
  exempt. Each use is reported as `<file>:<line> says "<phrase>" — say "<say>" (<defined_by>)`.

- **`Get-GlossaryFormViolations`** (`Catzc.Base.Docs`) checks that every concept with `forms:` is qualified only by them (ADR-REPO-VOCAB#8),
  on the same files and surfaces as the phrasing check: a "`<word> <head>`" or "`<word>-<head>`" whose word is neither a declared form nor a
  function word, and the head word's verb forms. Each use is reported as
  `<file>:<line> says "<use>" — "<term>" takes only: <forms> (<defined_by>)`.

- Each of these checks reads only the concepts of sources whose `checks` option includes it (`anchored`, `single`, `avoid`, `enforced`,
  `forms`), so a source that opts out of a check is not checked by it (ADR-REPO-VOCAB#2).

- **`Test-Glossary`** (`Catzc.Base.Docs`) runs every check, G1 to G6, over every source, writes one report under `out/test-glossary/`, and
  fails once with every issue. An L2 integrity test runs every check over the real tree, so every rule here is checked mechanically; it is
  L2 because the source and phrasing checks ask git which files are tracked (ADR-AUTO-TEST#9).

- **`Build-Glossary`** (`Catzc.Base.Docs`) projects every source into one readable page, `docs/adr/glossary.md`: per ADR domain, each term
  with its definition, a link to its defining rule, its realization, relations, contrasts, and avoided phrasings. The page is a derived
  artifact like the ADR index — committed so GitHub has it, and rebuilt on import — and an L1 integrity test fails when it drifts from the
  sources.

## Consequences

- A defined term has one findable home — its defining rule — and a reader meets the same meaning in every ADR, help text, and message.
- Near-neighbour terms come with their differences spelled out, so the common confusions are answered where the terms are defined.
- A blurring phrasing carries its replacement, so fixing one is a mechanical edit rather than a judgement call.
- Vocabulary control is opt-in per module: a module with no glossary source pays nothing, and a source that needs less — a scope that is
  narrower, or fewer checks — says so in its options.
- The cost is a second artifact beside the ADR for every defined term — a glossary entry — and the discipline of recording contrasts in both
  directions.

## Related

- [process-terms](../process/process-terms.md) (`ADR-PROC-LEANTERMS`) — the flow vocabulary; the model this ADR generalizes to every domain.
- [spell-out-names](../automation/spell-out-names.md) (`ADR-AUTO-SPELL`) — the spelling-level registry (`terminology.yml`), which controls
  tokens, not meanings.
- [domain-language-separation](domain-language-separation.md) (`ADR-REPO-LANG`) — which identities belong in which language zone; this ADR
  fixes what the words themselves mean.
- [module-config-loading](../configuration/module-config-loading.md) (`ADR-CONF-LOADING`) — how a module's `configs/glossary.yml` is
  discovered and validated.
