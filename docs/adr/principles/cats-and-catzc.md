---
catzc:
  immutable:
    repo_status: clean
    path: docs/adr/principles/cats-and-catzc.md
    folder: docs/adr/principles
    name: cats-and-catzc
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
---

# ADR-CATS: cats and catzc

## Rules: ADR-CATS

### Rule ADR-CATS:1

**catzc** is the source-level name of the system: the `Catzc.*` module prefix, the C# `Catzc.*` namespaces, the `Catzc.` type-accelerator
prefix, and the literal product token in code, configuration keys, contract paths and precise references. Code and the facts the tooling
writes say catzc.

- [Two names, two audiences](#two-names-two-audiences)
- [The inner namespace](#the-inner-namespace)

### Rule ADR-CATS:2

**cats** is the product's name to a person: the executor for bash and zsh, the word in prose, docs and conversation ("ask cats"), the
human-friendly form of the whole system. Where a sentence addresses a person rather than a compiler, it says cats.

- [Two names, two audiences](#two-names-two-audiences)
- [The friendly form](#the-friendly-form)

### Rule ADR-CATS:3

A module sourced from outside this repository, by a consumer or another team, is named in the cats form; the `Catzc.*` prefix stays the
inner namespace of the modules this repository ships. The two forms tell a reader at a glance which side of the repository boundary a
module comes from.

- [The inner namespace](#the-inner-namespace)
- [Across the boundary](#across-the-boundary)

### Rule ADR-CATS:4

Either name may stand in for the other where the audience is mixed: a pwsh entry point may say cats, a sentence to a person may name a
`Catzc.*` module when it means that module. Neither replaces the other in its own home: no `Cats.*` module, no catzc in a user-facing
sentence that has a cats form.

- [Used across each other on purpose](#used-across-each-other-on-purpose)

### Rule ADR-CATS:5

The folder names follow the source-level name: the consumer overlay root and this repository's own config-fragment root are `.catzc/`.
`.cats/` is never written and never read; there is one folder name, with no alias (ADR-PRIN-ONELIVE#2).

- [The folders](#the-folders)
- [How this is enforced](#how-this-is-enforced)

## Context

One system, two audiences. A compiler, a module loader and a config reader need one exact token that never changes and never collides:
that is catzc, reserved and a little awkward on purpose. A person reading a doc, typing a command in a shell or asking a question needs a
word that is easy to say and friendly to read: that is cats. The system is one; the names differ because the readers differ.

Letting the two names drift, or picking one for everything, costs either side. One name for everything is either a code token in every
sentence or a friendly word in every namespace, and a name that is at once an identifier and a nickname is reliably misspelled in one of
its roles. Two names with no rule are a source of variability ([reduce-variability](reduce-variability.md)): the same thing is spoken of
in two ways with no reason a reader can learn. The rule that each name has a home, and that the homes are allowed to meet, removes the
variability without losing either audience.

### Two names, two audiences

catzc names the system to code. cats names the system to a person. The test for which name a line takes is who reads it: a compiler, a
loader or a resolver reads catzc; a person reads cats.

### The inner namespace

Everything this repository ships is in the catzc namespace: the `Catzc.<Area>.<Name>` module folders, the C# namespaces and the
`Catzc.` type accelerators, the `catzc` head block in every tracked file's front matter and the `catzc_bundle` key, the `contracts/catzc/`
contract paths. Code that is sourced from outside the repository carries the cats form, so the namespace itself says where a module comes
from.

### The friendly form

cats is the root executor for bash and zsh and the word for the product in prose. It is the cute form, and it is deliberate: a product
people like to name gets named, and a name that reads well in a sentence keeps docs honest and conversations short. Where a pwsh entry
point speaks to a person, it may use the same word.

### Across the boundary

A consumer who writes a module against the toolset is outside the inner namespace; the cats form marks that. A reader who sees a
`Catzc.*` name knows the module is shipped by this repository and ruled by its ADRs; a reader who sees the cats form knows it came from
somewhere else and is ruled by the contracts at the boundary ([api-contracts](../repository/api-contracts.md)).

### Used across each other on purpose

The two names are not synonyms and not rivals; they are used across each other where the audiences overlap. A pwsh entry point that a
person calls by hand may say cats. A sentence to a person that means one module names it `Catzc.Base.Docs`, because that is its name.
What never happens is the swap in the name's own home: a module is never `Cats.*`, and prose never says catzc where cats would do.

### The folders

The consumer overlay root and this repository's own config-fragment root are `.catzc/`, with the track below it (`.catzc/<track>/`). A
folder name is read by a resolver, not a person, so it takes the source-level name; the alias once proposed for the friendly form is
withdrawn, because one path with two spellings is two sources of truth ([one-living-version](one-living-version.md)).

## Decision

Two names, each with a home, allowed to meet where the audience is mixed, and never swapped in its own home. The folders take the
source-level name only. The glossary carries both terms, defined by the rules above, so every doc uses them as the rules say.

## Consequences

- The CLAUDE.md terminology section cites ADR-CATS#1 and ADR-CATS#2 for its two entries.
- The config-defaults work takes `.catzc/` as the one fragment and overlay root, with no alias to read or test.
- The layers vocabulary leaves cats and catzc to this ADR; pwsh and automation are ruled there.

## How this is enforced

- `Test-Glossary` holds the terms cats and catzc to their defining rules and flags the avoided phrasing for the folder
  ([controlled-vocabulary](../repository/controlled-vocabulary.md)).
- The overlay and fragment resolvers read `.catzc/` only; a `.cats/` folder is unknown to them.
