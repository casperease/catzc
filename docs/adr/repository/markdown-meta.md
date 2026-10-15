# docs/adr/repository/markdown-meta.md

`ADR: Markdown meta — one reserved block of derived facts and authored config in a file's front matter`

## Rules: ADR-REPO-MDMETA

### Rule ADR-REPO-MDMETA:1

Every in-scope tracked Markdown file may carry one **meta block**: the reserved front-matter key `catzc`, holding the file's derived facts
under `derived` and its authored config contributions under `config`
([markdown-config-contributions](../configuration/markdown-config-contributions.md#rule-adr-conf-mdcontrib1)). The block is the only
front-matter key the tooling owns. Every other front-matter key belongs to the tool that reads it, and the tooling never reads, orders or
rewrites one.

- [Decision](#decision)
- [One reserved key](#one-reserved-key)

### Rule ADR-REPO-MDMETA:2

A **meta kind** is one entry of the meta-kind registry (`markdown-meta.yml`), validated by its own C# type, with every default declared once
on that type ([ADR-AUTO-DEFAULT#6](../automation/sensible-defaults.md#rule-adr-auto-default6)). An entry names the kind's id, its direction
(`imprint` writes derived facts into the file, `gather` reads config contributions out of it), the globs of files it applies to, the keys it
owns and their order, and, for a gather kind, the config it feeds. Which kinds exist is data, never a list inside an engine.

- [The meta-kind registry](#the-meta-kind-registry)

### Rule ADR-REPO-MDMETA:3

The `derived` part is imprinted by `Format-MarkdownMeta` and is byte-identical on every run: keys in the registry's order, values in
canonical form, no timestamp and no run identifier. A hash is allowed only as a hash of the file's body, so it changes exactly when the
file changes. A second run changes no file. The output is prettier-stable ([ADR-REPO-FORMAT#5](uniform-formatting.md#rule-adr-repo-format5)),
so the formatter and prettier never undo each other.

- [Imprinted, never hand-edited](#imprinted-never-hand-edited)

### Rule ADR-REPO-MDMETA:4

A module subscribes to a meta kind by shipping a function named for it, found by convention as `Assert-<Name>Config` is
([ADR-CONF-LOADING#5](../configuration/module-config-loading.md#rule-adr-conf-loading5)): `Get-<Kind>MarkdownMetaFact` for an imprint kind
and `Get-<Kind>MarkdownConfigContribution` for a gather kind, or a function the entry names. `Test-MarkdownMetaProcessors` fails a kind
with no function and a function no kind names. A new kind is a registry entry and a function file, never an edit to the engine
([ADR-AUTO-EXTEND#1](../automation/open-closed-architecture.md#rule-adr-auto-extend1)).

- [Subscribing a kind](#subscribing-a-kind)

### Rule ADR-REPO-MDMETA:5

The scope is the file class of the Markdown title ([ADR-REPO-FORMAT#6](uniform-formatting.md#rule-adr-repo-format6)): every tracked `.md`
file except those `.gitattributes` marks `linguist-vendored`, `linguist-generated`, `catzc-fixture` or `catzc-contract`, and those it
marks `-catzc-meta`. A new exception is declared in the `.gitattributes` source, never in a list of the gate's own. A `derived` key an
author wrote is a finding the author fixes, never overwritten silently, and a `config` part is validated against its kind and kept as
written.

- [Scope](#scope)

### Rule ADR-REPO-MDMETA:6

The pure parts, the C# types, the block parser and renderer and the file scanner, live in a module below `Catzc.Base.Config` that declares
only `Catzc.Base.Repository` and `Catzc.Base.Asserts`. That module reads no config: every declaration reaches it as a parameter. The
registry, the processors and the commands that read the registry live in a module above `Catzc.Base.Config`, which reads the registry
through `Get-Config` and passes it down. `Get-Config` calls the scanner with the globs from the config registry, so the reader never
depends on the module that reads the meta-kind registry
([controlling-module-dependencies](../automation/controlling-module-dependencies.md)).

- [Layers](#layers)

## Context

A Markdown file in this repository is more than prose. An agent definition declares a name, a description and its tools. An ADR sits in a
domain with a concern. A reference page belongs to a module. Some of these facts are stated twice, once in the file and once in a
registry that has to be kept in step, and some can be computed from the file and the repository but are not written anywhere a reader
could see them.

Two needs follow. Facts that can be computed belong in the file, written by a formatter, so a reader and a tool see them without running
anything. Values an author states belong where the thing is, and a config can read them from there
([markdown-config-contributions](../configuration/markdown-config-contributions.md)). Both need a place in the file that the tooling owns
without touching what other tools own.

## Decision

A file's front matter carries one reserved key, `catzc`, with two parts: `derived`, written by the formatter, and `config`, written by the
author. Which kinds of fact and config exist is a registry. Who computes or reads each kind is a function a module ships.

### One reserved key

`A namespace that cannot collide`

```yaml
---
name: example-agent
catzc:
  derived: { kind: agent, body_sha: 3fa91c0d2b7e }
  config: { agents: { example-agent: { gates: [Test-AgentDefinitions] } } }
---
```

`name` belongs to the agent tooling and is untouched. A tool that reads front matter keeps working, because the reserved key is one extra
top-level key it does not know. The two parts never mix: `derived` is imprinted and rewritten, `config` is authored and kept.

### The meta-kind registry

`Kinds are data`

The registry says what exists; the engine knows no kind by name. An entry is small: an id, a direction, globs, keys and their order, and a
target config for a gather kind. Adding a kind adds an entry, so the list of kinds is reviewed as data, in one file.

### Imprinted, never hand-edited

`The formatter owns derived`

A derived value is computed from the file and the repository, so a hand edit would only be overwritten, and a stale one would mislead. The
formatter writes the part in a fixed order and form, and the check fails when the file differs from what the formatter would write. No
timestamp is allowed, because a value that changes on every run makes every run a diff.

### Subscribing a kind

`The function is the subscription`

A module subscribes by adding a file. The convention names the function from the kind's id, as a config validator is named from its
config. The gate lists the orphans in both directions: a kind whose function is missing fails when the registry is read, and a function that
matches no kind is reported, so a rename cannot leave either side behind.

### Scope

`The same files as the title`

The meta block applies to the files whose title is their path, because the same classes are exempt for the same reasons: vendored and
generated files are not authored here, fixtures hold deliberately odd content, and contract assets are compared byte for byte. One more
attribute opts a single file out.

### Layers

`Pure below the reader, wiring above it`

The reader of configs cannot depend on a module that reads configs. The block parser, the renderer and the scanner take their inputs as
parameters and sit below the reader, where the reader can call them. The registry is a config and is read the usual way, by a module above
the reader that hands the declarations down.

### How this is enforced

- **`Format-MarkdownMeta`** imprints the `derived` part and `Test-MarkdownMeta` fails any difference, in scope and in form.
- **`Test-MarkdownMetaProcessors`** fails a kind without its function and a function without a kind.
- **`Test-ModuleDependency`** keeps the two layers apart ([ADR-AUTO-DEPM](../automation/controlling-module-dependencies.md)).

## Consequences

- A computable fact is in the file, where a reader sees it, and it is the same on every run, so it never adds noise to a diff.
- A fact an author states is written once, in the file of the thing, and the config that needs it gathers it from there.
- Another tool's front matter is never touched, so an agent or skill file keeps working unchanged.
- A new kind of fact or config is a registry entry and a function, reviewed as data and as one file of code.
- The formatter and the pure scanner are testable on strings alone, because they read no config and touch no file.
