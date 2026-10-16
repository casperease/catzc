---
catzc:
  immutable:
    with_body_sha: dc551b9dd238
    repo_status: clean
    path: docs/adr/principles/configure-not-program.md
    folder: docs/adr/principles
    name: configure-not-program
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-PRIN-CONFIG#{1-5}
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-CONF-LOADING#4
---

# Principle: Configure, don't program — one mechanism per kind, one config entry per instance

## Rules: ADR-PRIN-CONFIG

### Rule ADR-PRIN-CONFIG:1

Behaviour that varies by instance — a language, a tool, a target, an environment, a file class — is a config entry. Code implements one
mechanism for each kind of thing, never one function for each instance of it.

- [Mechanisms and instances](#mechanisms-and-instances)

### Rule ADR-PRIN-CONFIG:2

Adding an instance of a kind the repository already handles is a config change. When it takes new code beyond a new engine adapter, the
mechanism is missing or wrong: fix the mechanism, then add the instance as configuration.

- [Mechanisms and instances](#mechanisms-and-instances)
- [Engines are the exception that proves it](#engines-are-the-exception-that-proves-it)

### Rule ADR-PRIN-CONFIG:3

Every setting has a sensible default, declared once on its config type. A config file states only what deviates from the default, so the
shortest config is the common case and every line in it is a decision someone made.

- [Defaults carry the common case](#defaults-carry-the-common-case)

### Rule ADR-PRIN-CONFIG:4

An exception is a declared config entry, next to the instance it concerns, carrying its reason and validated by the config type. It is never
a branch in code, a hard-coded list inside a command, or a convention known only to its author.

- [Exceptions are entries](#exceptions-are-entries)

### Rule ADR-PRIN-CONFIG:5

A design question about one instance is answered by the default. Raise a question only about the default itself or about a missing mechanism
— never ask whether an instance is worth supporting, because supporting it costs one config entry.

- [Questions the default answers](#questions-the-default-answers)

## Context

Catzc does everything as code (ADR-PRIN-EAC), and most of that code is not programming: it is configuring. The modules are mechanisms — read
a registry, resolve a setting, run an engine over a set of files, render a root file — and the repository's behaviour is what their
`configs/*.yml` registries say. A new language, tool, timeout, root file or pipeline is meant to arrive as a few lines of YAML, checked by
the config type that loads it (ADR-CONF-LOADING), with the sensible default covering everything the lines leave out.

The failure this principle prevents is gradual. Each new instance looks small enough to code directly: one more `Format-<Language>` command,
one more `if` for a special file, one more hard-coded list in a quality check. Each one is reasonable alone; together they turn a registry
into a scattering of functions that each restate the same behaviour slightly differently, that drift, and that a reader has to visit one by
one to learn what the repository does. Worse, coding per instance makes every instance a cost decision ("is XML worth a formatter for four
files?"), so coverage becomes a series of trade-offs instead of a default.

### Mechanisms and instances

A **mechanism** is the code that does one kind of work: format files, install a tool, bound a call with a timeout, render a root file. An
**instance** is one case of that kind: formatting Go, installing `uv`, the limit for `pwsh`, `.editorconfig`. The rule of thumb:

- the kinds are few and change rarely — they are code, one function each, with tests;
- the instances are many and change often — they are entries in the kind's registry, validated at load, with no code of their own.

For formatting, the kind is "format the files of a language with its engine". The registry is `languages.yml`, whose entry for a language
names its formatter engine; one formatting command reads it, and the quality gate that checks formatting and the editor's per-language
formatter settings read the same entries. Adding JSON is `json: { formatter: prettier }`, not a `Format-Json` function.

### Engines are the exception that proves it

Some instances need something genuinely new: a formatter engine nothing in the repository runs yet, a package manager with its own command
line. That is new code, but it is new **mechanism** — an engine adapter — written once and then reused by every instance that names it. The
test is whether the second instance of the same engine needs code too; under this principle it never does.

### Defaults carry the common case

A setting resolves through the caller's value, then the module's configuration, then the default declared on the config type
(ADR-AUTO-DEFAULT#6). This principle adds the authoring discipline on top: a registry entry states only its deviations. An entry that
repeats the default is noise that hides the entries that matter, and a default that is restated in many entries can no longer be changed in
one place.

### Exceptions are entries

A real exception — a binary file class with nothing to format, a fixture kept malformed on purpose, a tool that needs a longer limit — is a
declared entry with its reason, where the type can validate it and a reviewer can see it. The alternatives all hide the exception: a branch
in a function is found only by reading the function, a list inside a quality check is a second registry, and a convention known only to its
author is no rule at all.

### Questions the default answers

When the mechanism and its default exist, a question about one instance is already answered: the instance gets the default, and an
exception, if there is one, is an entry. Questions that remain are about the default itself ("should every text language name a formatter?")
or about a mechanism that does not exist yet ("nothing runs `bicep format`"). Asking per instance whether support is worth it treats
configuration as programming, and leaves the repository with uneven coverage decided case by case.

### Rejected alternatives

- **One function per instance** (`Format-Yaml`, `Format-Json`, `Format-Bicep`, …). Each copy restates the shared behaviour — scope, dry run,
  result, announcement — and the copies drift. The registry stops being the one place that says what is supported.
- **A hard-coded list in the consumer** (a `ValidateSet` of formatter names, a switch over languages). The list is a second registry that
  must be kept in step by hand.
- **Configuration that can program** (script blocks or expressions in YAML). It hides code where it is neither analysed nor tested; a
  setting that needs logic is a sign the mechanism is missing (ADR-PRIN-CONFIG#2).

## Decision

Catzc is configured, not programmed. Each kind of work has one mechanism in code; each instance of it is a registry entry with a sensible
default declared once on the config type; an exception is a declared entry with its reason; and a question about one instance is answered by
the default, not decided case by case.

### How this is enforced

- **Strict config types** validate every registry at load and reject unknown keys (ADR-CONF-LOADING#4), so an instance's behaviour is
  limited to what the mechanism supports, and an exception is a typed key with a required reason.
- **Integrity tests** check that the consumers read the registry instead of keeping their own list: for example, that every formatter a
  language names is one the formatting mechanism provides.
- **Code review** rejects a new per-instance function, a hard-coded instance list, or a branch for one instance, against this ADR, and asks
  for the mechanism or the config entry instead.

## Consequences

- Supporting a new instance is a config change, reviewed as a diff of a few YAML lines, with nothing new to test beyond the mechanism.
- Coverage is uniform: every instance gets the default, so gaps are visible as declared exceptions rather than hidden as functions nobody
  wrote.
- The registries are the documentation of what the repository does; reading `languages.yml` tells you how every language is formatted.
- The cost is up-front design: the first instance of a new kind must wait for its mechanism, instead of being coded directly and generalised
  later.
