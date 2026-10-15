---
catzc:
  derived:
    path: docs/adr/repository/file-meta.md
    kind: adr
    body_sha: "3421c67efc73"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-EXTEND#1
      - ADR-CONF-LOADING#5
      - ADR-REPO-FORMAT#5
      - ADR-REPO-FORMAT#6
---

# ADR: File meta — one block of derived facts, in the carrier each kind of file has

## Rules: ADR-REPO-FILEMETA

### Rule ADR-REPO-FILEMETA:1

Every in-scope tracked file may carry one **meta block**: the facts the tooling owns about the file, written into the file's carrier. A
Markdown file's carrier is the reserved front-matter key `catzc`, holding the file's derived facts under `derived` and its authored config
contributions under `config` ([markdown-config-contributions](../configuration/markdown-config-contributions.md#rule-adr-conf-mdcontrib1)).
A code file's carrier is its meta head ([code-file-meta](code-file-meta.md#rule-adr-repo-codemeta1)). The block is the only part of the file
the tooling owns: every other front-matter key belongs to the tool that reads it, and the tooling never reads, orders or rewrites one.

- [Decision](#decision)
- [One block, two carriers](#one-block-two-carriers)

### Rule ADR-REPO-FILEMETA:2

A **meta kind** is one entry of the meta-kind registry (`file-meta.yml`), validated by its own C# type, with every default declared once on
that type ([ADR-AUTO-DEFAULT#6](../automation/sensible-defaults.md#rule-adr-auto-default6)). An entry names the kind's id, its direction
(`imprint` writes derived facts into the file, `gather` reads config contributions out of it), the globs of files it applies to, the keys it
owns and their order, and, for a gather kind, the config it feeds. A kind that applies to every file, such as the path, takes the default
glob of all files, and the carrier registry decides which files carry a block at all. The globs tie a kind to a carrier: a kind for Markdown
files lists Markdown globs and a kind for code files lists code globs. Which kinds exist is data, never a list inside an engine.

- [The meta-kind registry](#the-meta-kind-registry)

### Rule ADR-REPO-FILEMETA:3

The `derived` part is imprinted by `Format-FileMeta` and is byte-identical on every run: keys in the registry's order, values in canonical
form, no timestamp and no run identifier. A hash is allowed only when it changes exactly when something a reader cares about changes. A
second run changes no file. The output is stable under the formatter of the file's language, so the formatter and the imprint never undo
each other ([ADR-REPO-FORMAT#5](uniform-formatting.md#rule-adr-repo-format5)).

- [Imprinted, never hand-edited](#imprinted-never-hand-edited)

### Rule ADR-REPO-FILEMETA:4

A module subscribes to a meta kind by shipping a function named for it, found by convention as `Assert-<Name>Config` is
([ADR-CONF-LOADING#5](../configuration/module-config-loading.md#rule-adr-conf-loading5)): `Get-<Kind>FileMetaFact` for an imprint kind and
`Get-<Kind>MarkdownConfigContribution` for a gather kind, or a function the entry names. `Test-FileMetaProcessors` fails a kind with no
function and a function no kind names. A new kind is a registry entry and a function file, never an edit to the engine
([ADR-AUTO-EXTEND#1](../automation/open-closed-architecture.md#rule-adr-auto-extend1)).

- [Subscribing a kind](#subscribing-a-kind)

### Rule ADR-REPO-FILEMETA:5

The scope of a kind is its globs, less the files `.gitattributes` marks `linguist-vendored`, `linguist-generated`, `catzc-fixture` or
`catzc-contract`, and those it marks `-catzc-meta`. For Markdown the globs match the file class of the Markdown title
([ADR-REPO-FORMAT#6](uniform-formatting.md#rule-adr-repo-format6)). A new exception is declared in the `.gitattributes` source, never in a
list of the gate's own. A `derived` key an author wrote is a finding the author fixes, never overwritten silently, and a `config` part is
validated against its kind and kept as written.

- [Scope](#scope)

### Rule ADR-REPO-FILEMETA:6

The pure parts, the C# types, the carrier parsers and renderers and the file scanner, live in modules below `Catzc.Base.Config`, one per
carrier, that declare only `Catzc.Base.Repository`, `Catzc.Base.Objects` (every type renders through its console text) and
`Catzc.Base.Asserts`. Those modules read no config: every declaration reaches them as a parameter. The registry, the processors and the
commands that read the registry live in a module above `Catzc.Base.Config`, which reads the registry through `Get-Config` and passes it
down. `Get-Config` calls the scanner with the globs from the config registry, so the reader never depends on the module that reads the
meta-kind registry ([controlling-module-dependencies](../automation/controlling-module-dependencies.md)).

- [Layers](#layers)

## Context

A file in this repository is more than its text. A Markdown agent definition declares a name, a description and its tools. An ADR sits in a
domain with a concern. A reference page belongs to a module. A C# type file and a PowerShell function file each belong to a module and a
place in its tree. Some of these facts are stated twice, once in the file and once in a registry that has to be kept in step, and some can
be computed from the file and the repository but are not written anywhere a reader could see them.

Two needs follow. Facts that can be computed belong in the file, written by a formatter, so a reader and a tool see them without running
anything. Values an author states belong where the thing is, and a config can read them from there
([markdown-config-contributions](../configuration/markdown-config-contributions.md)). Both need a place in the file that the tooling owns
without touching what other tools own, and that place differs by kind of file, because front matter is a Markdown convention and a code file
has comments.

## Decision

A file carries one meta block, with the carrier its kind of file has. For Markdown the carrier is one reserved front-matter key, `catzc`,
with two parts: `derived`, written by the formatter, and `config`, written by the author. For code the carrier is the meta head, with the
derived part only. Which kinds of fact and config exist is a registry. Who computes or reads each kind is a function a module ships.

### One block, two carriers

`One registry, a carrier per kind of file`

```yaml
---
name: example-agent
catzc:
  derived:
    path: .claude/agents/example-agent.md
    kind: agent
    body_sha: "3fa91c0d2b7e"
    adrs: []
  config:
    agents:
      example-agent:
        gates: [Test-AgentDefinitions]
---
```

`name` belongs to the agent tooling and is untouched. A tool that reads front matter keeps working, because the reserved key is one extra
top-level key it does not know. The two parts never mix: `derived` is imprinted and rewritten, `config` is authored and kept. The code
carrier, the form of a head in a C# or PowerShell file, is in [code-file-meta](code-file-meta.md). Which carrier each file class has, or why
it has none, is one registry, `file-carriers.yml`, so a gap in the coverage is a visible entry.

### The meta-kind registry

`Kinds are data`

The registry says what exists; the engine knows no kind by name. An entry is small: an id, a direction, globs, keys and their order, and a
target config for a gather kind. Adding a kind adds an entry, so the list of kinds is reviewed as data, in one file. One registry serves
every carrier, so there is one list of kinds to keep in step and one place a reader looks.

### Imprinted, never hand-edited

`The formatter owns derived`

A derived value is computed from the file and the repository, so a hand edit would only be overwritten, and a stale one would mislead. The
formatter writes the part in a fixed order and form, and the check fails when the file differs from what the formatter would write. No
timestamp is allowed, because a value that changes on every run makes every run a diff.

### Subscribing a kind

`The function is the subscription`

A module subscribes by adding a file. The convention names the function from the kind's id, as a config validator is named from its config.
The gate lists the orphans in both directions: a kind whose function is missing fails when the registry is read, and a function that matches
no kind is reported, so a rename cannot leave either side behind.

### Scope

`The same file classes as the title, and the code the registry names`

The meta block applies to the file classes whose content the repository authors, because the same classes are exempt for the same reasons:
vendored and generated files are not authored here, fixtures hold deliberately odd content, and contract assets are compared byte for byte.
One more attribute opts a single file out, for a file whose text is read verbatim by another tool.

### Layers

`Pure below the reader, wiring above it`

The reader of configs cannot depend on a module that reads configs. The carrier parsers, the renderers and the scanner take their inputs as
parameters and sit below the reader, where the reader can call them. The registry is a config and is read the usual way, by a module above
the reader that hands the declarations down.

### How this is enforced

- **`Format-FileMeta`** imprints the `derived` part and `Test-FileMeta` fails any difference, in scope and in form.
- **`Test-FileMetaProcessors`** fails a kind without its function and a function without a kind.
- **`Test-ModuleDependency`** keeps the layers apart ([ADR-AUTO-DEPM](../automation/controlling-module-dependencies.md)).

## Consequences

- A computable fact is in the file, where a reader sees it, and it is the same on every run, so it never adds noise to a diff.
- A fact an author states is written once, in the file of the thing, and the config that needs it gathers it from there.
- Another tool's front matter is never touched, so an agent or skill file keeps working unchanged.
- A new kind of fact or config is a registry entry and a function, reviewed as data and as one file of code.
- The formatter and the pure scanners are testable on strings alone, because they read no config and touch no file.
