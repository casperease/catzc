---
catzc:
  derived:
    path: docs/adr/repository/file-meta.md
    kind: adr
    language: markdown
    filetype: md
    track: docs
    body_sha: cd6b8f442ae3
    defines:
      - ADR-REPO-FILEMETA#{1-12}
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-EXTEND#1
      - ADR-CONF-LOADING#5
      - ADR-REPO-COMMENTS#1
      - ADR-REPO-FORMAT#{5,6}
      - ADR-REPO-LINK#4
    links:
      - docs/adr/automation/controlling-module-dependencies.md
      - docs/adr/automation/open-closed-architecture.md#rule-adr-auto-extend1
      - docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6
      - docs/adr/configuration/markdown-config-contributions.md
      - docs/adr/configuration/markdown-config-contributions.md#rule-adr-conf-mdcontrib1
      - docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading5
      - docs/adr/repository/code-file-meta.md
      - docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta1
      - docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments1
      - docs/adr/repository/markdown-links.md#rule-adr-repo-link4
      - docs/adr/repository/uniform-formatting.md#rule-adr-repo-format5
      - docs/adr/repository/uniform-formatting.md#rule-adr-repo-format6
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
(`imprint` writes derived facts into the file, `gather` reads config contributions out of it), the files it applies to, the keys it owns and
their order, and, for a gather kind, the config it feeds. Globs live in one place: the registry's ordered `classes`, where a file is the
first class whose globs match it, or `other`. A kind selects files by class and language (`select`, entries of `classes` with at most one
`*` and `languages` from the file-language registry) and never by glob, and a kind that selects nothing applies to every file, such as the
path. A setting that names files does so by class too, and defaults to the classes its kind selects. The carrier registry decides which
files carry a block at all. Which kinds exist is data, never a list inside an engine.

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

The scope of a kind is the files it selects, less the files `.gitattributes` marks `linguist-vendored`, `linguist-generated`,
`catzc-fixture` or `catzc-contract`, and those it marks `-catzc-meta`. For Markdown the globs match the file class of the Markdown title
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

### Rule ADR-REPO-FILEMETA:7

A file the automation composes whole — a root-config copy, a generator's output, a `.gitkeep` — carries the **generated-file head** instead
of an imprinted block. Its writer composes the content bare and writes the head through the one head function, in the carrier the file's
class has. The head holds the same facts as an imprinted block, `path`, `kind` and `subkind` (the role the file-kinds registry names for the
file, which the writer reads and passes down), `language`, `filetype`, `track`, `module` and `moduletype` (the module-types registry's type of the module the file is placed in), each left
out for a file that has none, and
what only a composed file has: `generator` (the repository-relative path of the file that defines the command that composed the file) and
`source` (the authored file or files it comes from). A generated file is told from an authored one by its `generator`, never by a kind of
its own. No writer hand-words a banner, and the drift check compares the head with the rest of the content. The imprint engine leaves these
files alone ([ADR-REPO-FILEMETA#5](#rule-adr-repo-filemeta5)), since the writer owns every byte of them. A comment page is the one generated
item whose block the engine imprints, and it names its writer the same way: the `generator` kind of the registry gives it the path of the
comment exporter.

- [Generated files](#generated-files)

### Rule ADR-REPO-FILEMETA:8

A JSON file has no comments, so its carrier is an ignored top-level property that the carrier registry names (`//`, or `$comment` for a JSON
Schema): the first property of the object, holding the same `catzc` block as text. A file class with a sidecar carrier, such as a diagram,
keeps its block in the Markdown file beside it, which is in the scope on its own, so the imprint only checks that the sidecar exists. A file
without one is a visible finding, or an `exclude` entry of its carrier with the reason.

- [Property and sidecar carriers](#property-and-sidecar-carriers)

### Rule ADR-REPO-FILEMETA:9

The derived part of a Markdown file says what the file defines and what it points at, and the two never mix. An ADR lists under `defines`
the rules its own headings declare, each spelled as a citation, `ADR-<CODE>#<n>`, and its `adrs` lists only the registered rules it cites
from elsewhere, so a rule's own text is never a citation of itself and a placeholder named in prose is none either. Every Markdown file
lists under `links` each link that leaves it, whatever its form (relative, repository-rooted, absolute URL, image, reference definition or
autolink), spelled once as a repository-relative path with its anchor or as the absolute URL, sorted and without duplicates. A link that
stays inside the file, an anchor in it, the file itself or its own comment page, is internal and is not listed.

- [What a Markdown file defines and points at](#what-a-markdown-file-defines-and-points-at)

### Rule ADR-REPO-FILEMETA:10

The head is a map of facts about its own file, so it holds as few links to other files as possible, and only those that cost to derive and
truly define a relationship. The derived part of a code file points at its **relatives** in one map, `relatives`, of at most two relations
with fixed names: `page` (its comment page, [ADR-REPO-COMMENTS#1](comments-in-docs.md#rule-adr-repo-comments1)) and `test` (the Pester file
that tests it). A relative stays inside the file's own module or its docs section, never in another module, so modules relate to each other
by name and never through a file path (encapsulation), and only the code side points: a test or a page knows its code by its name, so no pair
is recorded twice. The relations and the rules that fill them are the `relatives` kind's settings in `file-meta.yml`, so a new relation is a
registry entry, never a new mechanism. A relation holds a repository-relative path that exists on disk, and a relation with no file is left
out. No file carries a pointer of its own in its code: the head is the one place a code file names its relatives.

- [Relatives](#relatives)

### Rule ADR-REPO-FILEMETA:11

The **kind** of a file is the role it plays, such as a test, a function, a config or a decision record, and never its language, track or
module, which are facts of their own. A **subkind** narrows a kind, such as a gate among the functions, and a **file type** is the extension
of the file's name, which tells the sorts of file inside one language apart. The kinds, their one-sentence definitions and the globs that
select them are one registry, `file-kinds.yml`, local to catzc and global to every file: the first kind whose globs match a path names it,
a path no kind selects is `other`, a meta kind selects files by their kind and subkind and never by glob, and a consumer extends the
registry with a config fragment. A provided contract pins the kind and subkind names.

- [File kinds](#file-kinds)

### Rule ADR-REPO-FILEMETA:12

A **module type** says what sort of module a file is placed in, and the module-types registry says where the modules of each type are
found and how a path in that place names its module: a PowerShell module is a folder under automation or one psm1 file, a settings module
is a tool's dot-folder, a pipeline module is the folder that holds pipelines, and a Python, Go or Bash module is its track folder. The head
holds `module` and `moduletype` from the registry for a file placed in a module, and neither for a file placed in none, and it holds
`bundle`, the smallest built bundle that holds the module, from the exporter registry, so the head never carries a list of its own.

- [Module types](#module-types)

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
    kind: claude-agent
    body_sha: "3fa91c0d2b7e"
  config:
    agents:
      example-agent:
        gates: [Test-AgentDefinitions]
---
```

A fact with no value, an empty list or an empty string, is the default of its key and is left out, so an absent key reads as the empty
value. `name` belongs to the agent tooling and is untouched. A tool that reads front matter keeps working, because the reserved key is one
extra top-level key it does not know. The two parts never mix: `derived` is imprinted and rewritten, `config` is authored and kept. The code
carrier, the form of a head in a C# or PowerShell file, is in [code-file-meta](code-file-meta.md). Which carrier each file class has, or why
it has none, is one registry, `file-carriers.yml`, so a gap in the coverage is a visible entry.

### The meta-kind registry

`Kinds are data`

The registry says what exists; the engine knows no kind by name. An entry is small: an id, a direction, the classes and languages it
selects, keys and their order, and a target config for a gather kind. The globs are written once, in the ordered classes, so a set of files
is spelled in one place however many kinds read it. Adding a kind adds an entry, so the list of kinds is reviewed as data, in one file. One
registry serves every carrier, so there is one list of kinds to keep in step and one place a reader looks.

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

### Generated files

`The writer owns the head, the engine stays out`

A generated file is rewritten whole on every run, and the drift check compares it with what its writer would compose now. If an imprint step
wrote the head afterwards, the two would disagree on every run, so the writer writes the head itself, with the same function every writer
calls. The head says how to regenerate the file: which command composed it and which authored files it comes from, so a reader who finds a
generated file knows where to edit. The carrier is the file class's own, named by the root-config entry or found from the file language, and
no banner is hand-worded, because a banner would be a second statement of what the head says.

### Property and sidecar carriers

`JSON keeps the block in a property, a diagram beside it`

JSON has no comment syntax, and a leading `//` block makes it invalid, so the block is a property a reader of the data ignores. The property
holds the block as text, so one parser serves it as it serves a comment head, and a JSON Schema, whose `$comment` must be a string, takes
the same form. A diagram is a binary picture, so its description beside it is the place a reader looks and the block lives there.

### What a Markdown file defines and points at

`Declared rules, cited rules and outgoing links, each in its own key`

A rule an ADR declares and a rule it cites answer different questions: which decisions does this file own, and which decisions does it rest
on. Listing both under one key would make every ADR depend on itself, so the declared rules have their own key and the citations leave them
out. The links answer a third question, what the file points at, in a spelling that does not depend on where the link was written, so a
reader or a tool can find every file that points at a given page without parsing Markdown. Code links in comments only ever point into the
ADRs ([ADR-REPO-LINK#4](markdown-links.md#rule-adr-repo-link4)), which `adrs` already lists, so the key belongs to Markdown. A link that
stays inside the file tells a reader nothing about where the file leads, so it is left out.

### Relatives

`A code file names the few files that belong to it, in the head`

A code file has two companions a reader wants one step away, and both cost to find: the page that holds its moved comments, and the test
that proves it. Writing each as a link in the code would put a pointer in every file and a line to keep in step with the companion. The
head already holds derived facts, so the companions are one more, a map with a fixed name per kind of companion, and no more than the
ones that truly define a relationship, so the head stays a map of facts about its own file. A companion that the file's name already gives,
such as the code a test covers, is not recorded from the test's side. The registry holds the list of relations and the path rule of each,
and a relation whose file does not exist is not written, so an entry in the head is always a working pointer.

### File kinds

`A file's kind is its role, and one registry names every kind`

A file has a language, a track, a module and a role, and each is a fact of its own. Folding the language into the role, a Python script
and a PowerShell script as two kinds, makes the same fact twice and a head that disagrees with itself. So the kind says only what the file
is for: a test, a function, a config, a decision record. The registry holds each kind with a one-sentence definition and the globs that
select it, in the order they are checked, with the subkinds of a kind written under it, and it is the one place a glob for a file's role
is written. It is local to catzc and global to every file, so a head, a comment scope and a gate all say the same thing about a file, and
a consumer extends it with a config fragment instead of editing it. A provided contract pins the names, so a tool that reads a head may
rely on them.

### Module types

`A module is placed by its type, and one registry says where`

A module is not one thing in this repository: a PowerShell module is a folder or one file, a tool's settings are a dot-folder, the
pipelines are a folder, and a Python, Go or Bash project is its track. Each is a module type, and the registry says per type where its
modules are found and how a path in that place names its module, so `module` and `moduletype` are read from the registry and never
guessed from a folder name. A file in no such place, such as a documentation page, has neither. The bundle a module ships in is read from
the exporter registry, so the head says whether a module is in a built bundle without a second list.

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
