# ADR: File meta — one block of derived facts, in the carrier each kind of file has

## Rules: ADR-REPO-FILEMETA

### Rule ADR-REPO-FILEMETA-HEADPOLICY

A file carries one **meta block** exactly as its **head policy** says: `required`, `optional` or `forbidden`, set per file class in the
meta-kind registry, with the defaults declared once on the policy's type
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). By default a tracked
generated file and a file whose front matter another tool reads, such as an agent or capability definition, are `required`, an authored file
is `forbidden`, and a file git does not track is `optional`. A file whose block disagrees with its policy, absent where required or present
where forbidden, is a finding. The block holds the facts the tooling owns about the file, written into the file's carrier. A Markdown file's
carrier is the reserved front-matter key `catzc`, holding the file's place facts under `immutable`, its outgoing edges under `edges`
([ADR-REPO-FILEMETA-FILEISNODE](#rule-adr-repo-filemeta-fileisnode)) and its authored config contributions under `config`
([markdown-config-contributions](../configuration/markdown-config-contributions.md#rule-adr-conf-mdcontrib-configcontribution)). The key
sits at the top level, or, where another tool validates the top level of the front matter and leaves one key of its own free for foreign
data, nests under that key at the key path the carrier registry declares (`key`, such as `metadata.catzc` for a capability); the block's own
key is `catzc` either way, and a parent key written as a flow mapping or a scalar is the author's to open up, never rewritten. A code file's
carrier is its meta head ([code-file-meta](code-file-meta.md#rule-adr-repo-codemeta-codefilehead)). The block is the only part of the file
the tooling owns: every other front-matter key belongs to the tool that reads it, and the tooling never reads, orders or rewrites one.

- [Decision](#decision)
- [One block, two carriers](#one-block-two-carriers)

### Rule ADR-REPO-FILEMETA-METAKIND

A **meta kind** is one entry of the meta-kind registry (`file-meta.yml`), validated by its own C# type, with every default declared once on
that type ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). An entry
names the kind's id, its direction (`imprint` writes derived facts into the file, `gather` reads config contributions out of it), the files
it applies to, the keys it owns and their order, and, for a gather kind, the config it feeds. Globs live in one place: the registry's
ordered `classes`, where a file is the first class whose globs match it, or `other` (ADR-REPO-FILEMETA-ROLE). A kind selects files by class
and language (`select`, entries of `classes` with at most one `*` and `languages` from the file-language registry) and never by glob, and a
kind that selects nothing applies to every file, such as the path. A setting that names files does so by class too, and defaults to the
classes its kind selects. The carrier registry decides which files carry a block at all. Which kinds exist is data, never a list inside an
engine.

- [The meta-kind registry](#the-meta-kind-registry)

### Rule ADR-REPO-FILEMETA-IMPRINTEDPARTS

The `immutable` and `edges` parts are imprinted by `Format-FileMeta` and are byte-identical on every run: keys in the registry's order,
values in canonical form, no timestamp and no run identifier. A hash is allowed only when it changes exactly when something a reader cares
about changes, and only a generated tracked file carries one: `with_body_sha` is required there and written by the file's writer, or
imprinted on a generated page whose class the `body-sha` kind selects, such as the ADR index and the glossary. An authored page carries no
body hash; a hash an author keeps in the `config` part is the author's, left alone and never maintained. A second run changes no file. The
output is stable under the formatter of the file's language, so the formatter and the imprint never undo each other
([ADR-REPO-FORMAT-GENERATEDARTIFACTSFORMATTED](uniform-formatting.md#rule-adr-repo-format-generatedartifactsformatted)).

- [Imprinted, never hand-edited](#imprinted-never-hand-edited)

### Rule ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION

A module subscribes to a meta kind by shipping a function named for it, found by convention as `Assert-<Name>Config` is
([ADR-CONF-LOADING-POWERSHELLVALIDATOR](../configuration/module-config-loading.md#rule-adr-conf-loading-powershellvalidator)):
`Get-<Kind>FileMetaFact` for an imprint kind and `Get-<Kind>MarkdownConfigContribution` for a gather kind, or a function the entry names.
`Test-FileMetaProcessors` fails a kind with no function and a function no kind names. A new kind is a registry entry and a function file,
never an edit to the engine ([ADR-AUTO-EXTEND-ADDNOTEDIT](../automation/open-closed-architecture.md#rule-adr-auto-extend-addnotedit)).

- [Subscribing a kind](#subscribing-a-kind)

### Rule ADR-REPO-FILEMETA-KINDSCOPE

The scope of a kind is the files it selects, less the files `.gitattributes` marks `linguist-vendored`, `linguist-generated`,
`catzc-fixture` or `catzc-contract`, and those it marks `-catzc-meta`. For Markdown the globs match the file class of the Markdown title
([ADR-REPO-FORMAT-MARKDOWNTITLE](uniform-formatting.md#rule-adr-repo-format-markdowntitle)). A new exception is declared in the
`.gitattributes` source, never in a list of the gate's own. A key an author wrote under `immutable` or `edges` is a finding the author
fixes, never overwritten silently, and a `config` part is validated against its kind and kept as written.

- [Scope](#scope)

### Rule ADR-REPO-FILEMETA-PUREPARTS

The pure parts, the C# types, the carrier parsers and renderers and the file scanner, live in modules below `Catzc.Base.Config`, one per
carrier, that declare only `Catzc.Base.Repository`, `Catzc.Base.Objects` (every type renders through its console text) and
`Catzc.Base.Asserts`. Those modules read no config: every declaration reaches them as a parameter. The registry, the processors and the
commands that read the registry live in a module above `Catzc.Base.Config`, which reads the registry through `Get-Config` and passes it
down. `Get-Config` calls the scanner with the globs from the config registry, so the reader never depends on the module that reads the
meta-kind registry ([controlling-module-dependencies](../automation/controlling-module-dependencies.md)).

- [Layers](#layers)

### Rule ADR-REPO-FILEMETA-COMPOSEDFILES

A file the automation composes whole — a root-config copy, a generator's output, a `.gitkeep` — carries the **generated-file head** instead
of an imprinted block. Its writer composes the content bare and writes the head through the one head function, in the carrier the file's
class has. The head holds the same facts as an imprinted block, `repo_status` (always `locked`, since the file's source is the truth and is
edited instead), `path`, `role` and `subkind` (the role the file-kinds registry names for the file, which the writer reads and passes down),
`language`, `filetype`, `track`, `module` and `moduletype` (the module-types registry's type of the module the file is placed in), each left
out for a file that has none, and what only a composed file has: `generator` (the repository-relative path of the file that defines the
command that composed the file) and `source` (the authored file or files it comes from). The head opens with `with_body_sha`, the hash of
the content below it, whatever the file's language and carrier, so a tracked generated file says which text its writer composed and the
drift check compares the stamp with the hash of the content below it before it compares the content. A generated file is told from an
authored one by its writer's entry in the writer registry (`generated-files.yml`) and its `linguist-generated` attribute, never by a kind of
its own and never by its head ([ADR-REPO-FILEMETA-NOREADBACK](#rule-adr-repo-filemeta-noreadback)). No writer hand-words a banner. The
imprint engine leaves these files alone ([ADR-REPO-FILEMETA-KINDSCOPE](#rule-adr-repo-filemeta-kindscope)), since the writer owns every byte
of them. A comment page is no generated file: it is an authored file
([ADR-REPO-COMMENTS-PAGEISAUTHORED](comments-in-docs.md#rule-adr-repo-comments-pageisauthored)), so the head policy gives it no head.

- [Generated files](#generated-files)

### Rule ADR-REPO-FILEMETA-PROVENANCEINHEAD

A generator puts its provenance in the head and nowhere else: the `generator`, the `source` and the `warning`, the one string "Do Not Edit,
this file is generated" that every generated head carries, declared once as the default of the head's config type (`GeneratedHeadConfig`,
[ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)) and written in the
file's own carrier. The body below the head is the content alone: no "generated from" line, no link to the source and no "edit the source"
note, since each would be a second statement of what the head says.

- [Generated files](#generated-files)

### Rule ADR-REPO-FILEMETA-JSONCARRIER

A JSON file has no comments, so its carrier is an ignored top-level property that the carrier registry names (`//`, or `$comment` for a JSON
Schema): the first property of the object, holding the same `catzc` block as text. A file class with a sidecar carrier, such as a diagram,
keeps its block in the Markdown file beside it, which is in the scope on its own, so the imprint only checks that the sidecar exists. A file
without one is a visible finding, or an `exclude` entry of its carrier with the reason.

- [Property and sidecar carriers](#property-and-sidecar-carriers)

### Rule ADR-REPO-FILEMETA-MARKDOWNEDGES

The edges of a Markdown file say what the file defines and what it points at, and the two never mix. An ADR lists under the edge `defines`
the rules its own headings declare, each spelled as a citation, `ADR-<CODE>#<n>`, and its edge `cites` lists only the registered rules it
cites from elsewhere, so a rule's own text is never a citation of itself and a placeholder named in prose is none either. Every Markdown
file lists under the edge `links` each link that leaves it, whatever its form (relative, repository-rooted, absolute URL, image, reference
definition or autolink), spelled once as a repository-relative path with its anchor or as the absolute URL, sorted and without duplicates. A
link that stays inside the file, an anchor in it, the file itself or its own comment page, is internal and is not listed.

- [What a Markdown file defines and points at](#what-a-markdown-file-defines-and-points-at)

### Rule ADR-REPO-FILEMETA-FEWLINKS

The head is a map of facts about its own file, so it holds as few links to other files as possible, and only those that cost to derive and
truly define a relationship. The edges of a code file point at its **relatives**, at most two edges with fixed names: `page` (its comment
page, [ADR-REPO-COMMENTS-ONELINEOFINSIGHT](comments-in-docs.md#rule-adr-repo-comments-onelineofinsight)) and `test` (the Pester file that
tests it). A relative stays inside the file's own module or its docs section, never in another module, so modules relate to each other by
name and never through a file path (encapsulation), and only the code side points: a test or a page knows its code by its name, so no pair
is recorded twice. The edges and the rules that fill them are the `relative-edges` kind's settings in `file-meta.yml`, so a new edge is a
registry entry, never a new mechanism. An edge holds a repository-relative path that exists on disk, and an edge with no file is left out.
No file carries a pointer of its own in its code: the head is the one place a code file names its relatives.

- [Relatives](#relatives)

### Rule ADR-REPO-FILEMETA-ROLE

The **role** of a file is the part it plays, such as a test, a function, a config or a decision record, and never its language, track or
module, which are facts of their own; a head writes it as `role`. A **subkind** narrows a role, such as a gate among the functions, and a
**file type** is the extension of the file's name, which tells the sorts of file inside one language apart. The path of a file under its
module (the whole path for a file in no module) is made of exactly three parts, written as `folder` (optional, left out for a file directly
in the module), `name` (the file's name without its file type, in kebab case) and `filetype`, and reading them asserts that they build the
path back, so a path made of anything else stops the run. The roles, their one-sentence definitions and the globs that select them are the
entries of one registry, `file-kinds.yml`, local to catzc and global to every file: the first entry whose globs match a path names its role,
a path no entry selects is `other`, an earlier entry that takes most of a later entry's files is an overlap the registry lists on purpose, a
meta kind selects files by their role and subkind and never by glob, and a consumer extends the registry with a config fragment. A provided
contract pins the role and subkind names.

- [File kinds](#file-kinds)

### Rule ADR-REPO-FILEMETA-MODULEFACTS

The head holds `module` and `moduletype` for a file placed in a module, as the module-types registry declares them
([ADR-DSGN-MODTYPE-MODULETYPEISSORT](../design/module-types.md#rule-adr-dsgn-modtype-moduletypeissort)), and neither for a file placed in
none, and it holds `catzc_bundle`, the smallest bundle of the catzc exporter (the one bundler there is) that holds the module, from the
exporter registry, so the head never carries a list of its own. It also holds `tracktype` and `vendor` from the track's declaration
([ADR-DSGN-TRACKTYPE-HEADREADSDECLARATION](../design/track-types.md#rule-adr-dsgn-tracktype-headreadsdeclaration)).

- [Module types](#module-types)

### Rule ADR-REPO-FILEMETA-FILEISNODE

A file is a node, and its meta block says two things about it, each in a part of its own. `immutable` holds the **place facts**: what the
repository's own configuration makes of the file's location, its `path` and the parts of it, its `role`, `language`, `track`, `module` and
the rest, each read from a registry and never from the file's text. `edges` holds what the file itself declares or points at, each one an
**edge**, a named relation leaving the file to a rule code, a file or a URL, such as `defines`, `cites`, `links`, `page` and `test`. Both
parts are imprinted and never written by hand, and both are fixed by the file: a place fact until the file moves or a registry changes, an
edge until the file's text changes. An edge is written on its source only, so the target holds no copy, and an edge is named for the
relation, never for the type of its target. In a generated file of any language
([ADR-REPO-FILEMETA-COMPOSEDFILES](#rule-adr-repo-filemeta-composedfiles)), and in a generated page the engine imprints, `immutable` opens
with `with_body_sha`, the hash of the body below the head, so the stamp says which text the writer composed. An authored file, page or code,
carries no hash ([ADR-REPO-FILEMETA-IMPRINTEDPARTS](#rule-adr-repo-filemeta-imprintedparts),
[ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY](code-file-meta.md#rule-adr-repo-codemeta-computablefactsonly)). Every block and every generated head
also holds `repo_status`, the part of the file's repository status that the file itself decides: `locked` for a generated file, whose source
is the truth and is edited instead, and `clean` for an authored one. The states only git knows, edited, staged, committed and pushed, and
`ready` (tracked and unchanged) are never written into the file, since the write would change them; `Get-RepoStatus` computes them on demand
from git, read-only. A kind of the registry names the part it writes, `immutable` by default and `edges` for a relation.

- [Place facts and edges](#place-facts-and-edges)

### Rule ADR-REPO-FILEMETA-NOREADBACK

No command reads an imprinted fact back. A gate, a generator or a resolver that needs a place fact or an edge of a file derives it from the
registries, git, the disk and the file's body, so stripping every block changes no verdict, and every command works the same on a file with
a block and on one without. The imprint is the one reader of `immutable` and `edges`, and it reads them only to compare them with what it
would write. A key another tool owns is read by that tool alone.

- [A head shows the facts, never holds them](#a-head-shows-the-facts-never-holds-them)
- [Head policy](#head-policy)

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
with three parts: `immutable` and `edges`, written by the formatter, and `config`, written by the author. For code the carrier is the meta
head, with the two imprinted parts only. Which kinds of fact and config exist is a registry. Who computes or reads each kind is a function a
module ships.

### One block, two carriers

`One registry, a carrier per kind of file`

```yaml
---
name: example-agent
catzc:
  immutable:
    with_body_sha: 3fa91c0d2b7e
    path: .claude/agents/example-agent.md
    role: claude-agent
  edges:
    links:
      - docs/adr/repository/agent-definitions.md
  config:
    agents:
      example-agent:
        gates: [Test-AgentDefinitions]
---
```

A fact with no value, an empty list or an empty string, is the default of its key and is left out, so an absent key reads as the empty
value. `name` belongs to the agent tooling and is untouched. A tool that reads front matter keeps working, because the reserved key is one
extra top-level key it does not know. A tool that rejects a top-level key it does not know, as an editor's skill validator does, still
leaves one key free for foreign data, `metadata`, so for that file class the registry nests the block there (`key: metadata.catzc`): the
block keeps its own key and its three parts, the tooling writes the parent key when the file lacks it and leaves every sibling under it
alone, and a parent written as a flow mapping cannot take a nested block, which is a finding for the author, never a rewrite. The parts
never mix: `immutable` and `edges` are imprinted and rewritten, `config` is authored and kept. The code carrier, the form of a head in a C#
or PowerShell file, is in [code-file-meta](code-file-meta.md). Which carrier each file class has, or why it has none, is one registry,
`file-carriers.yml`, so a gap in the coverage is a visible entry.

### The meta-kind registry

`Kinds are data`

The registry says what exists; the engine knows no kind by name. An entry is small: an id, a direction, the classes and languages it
selects, keys and their order, and a target config for a gather kind. The globs are written once, in the ordered classes, so a set of files
is spelled in one place however many kinds read it. Adding a kind adds an entry, so the list of kinds is reviewed as data, in one file. One
registry serves every carrier, so there is one list of kinds to keep in step and one place a reader looks.

### Imprinted, never hand-edited

`The formatter owns immutable and edges`

An imprinted value is computed from the file and the repository, so a hand edit would only be overwritten, and a stale one would mislead.
The formatter writes the part in a fixed order and form, and the check fails when the file differs from what the formatter would write. No
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
generated file knows where to edit, and it carries the one warning, so a reader is told not to edit the file in the same words everywhere.
The carrier is the file class's own, named by the root-config entry or found from the file language, and no banner is hand-worded, because a
banner would be a second statement of what the head says.

### Property and sidecar carriers

`JSON keeps the block in a property, a diagram beside it`

JSON has no comment syntax, and a leading `//` block makes it invalid, so the block is a property a reader of the data ignores. The property
holds the block as text, so one parser serves it as it serves a comment head, and a JSON Schema, whose `$comment` must be a string, takes
the same form. A diagram is a binary picture, so its description beside it is the place a reader looks and the block lives there.

### Place facts and edges

`The node's place from the repository's configuration, the node's edges from its own text`

A file has two kinds of derived fact, and they answer different questions. Where does the repository put this file, and what does it make of
that place: its folder, its name, its role, its language, its track and its module, all read from registries the repository configures, so
the same file in another repository would carry other values. And what does this file itself say it is related to: the rules it declares,
the rules it cites, the files it links, the page that holds its comments, the test that proves it, all read from the file and fixed by its
text. The first is a property of the node, the second a set of directed, named edges leaving it. Keeping them apart lets a reader ask "which
files are in this module" of one part and "which files point at this page" of the other, and lets a generated file's body hash sit at the
head of the place facts as the stamp of the text its writer composed. An edge is named for the relation, so a new relation is a new name and
a registry entry, and the target of an edge is spelled the same way wherever it is read.

### What a Markdown file defines and points at

`Declared rules, cited rules and outgoing links, each in its own edge`

A rule an ADR declares and a rule it cites answer different questions: which decisions does this file own, and which decisions does it rest
on. Listing both under one key would make every ADR depend on itself, so the declared rules have their own key and the citations leave them
out. The links answer a third question, what the file points at, in a spelling that does not depend on where the link was written, so a
reader or a tool can find every file that points at a given page without parsing Markdown. Code links in comments only ever point into the
ADRs ([ADR-REPO-LINK-ONEWAY](markdown-links.md#rule-adr-repo-link-oneway)), which `cites` already lists, so the edge belongs to Markdown. A
link that stays inside the file tells a reader nothing about where the file leads, so it is left out.

### Relatives

`A code file names the few files that belong to it, in the head`

A code file has two companions a reader wants one step away, and both cost to find: the page that holds its moved comments, and the test
that proves it. Writing each as a link in the code would put a pointer in every file and a line to keep in step with the companion. The head
already holds derived facts, so the companions are two more edges, one fixed name per kind of companion, and no more than the ones that
truly define a relationship, so the head stays a map of facts about its own file. A companion that the file's name already gives, such as
the code a test covers, is not recorded from the test's side. The registry holds the list of edges and the path rule of each, and an edge
whose file does not exist is not written, so an entry in the head is always a working pointer.

### File kinds

`A file's role is one fact, and one registry names every role`

A file has a language, a track, a module and a role, and each is a fact of its own. Folding the language into the role, a Python script and
a PowerShell script as two roles, makes the same fact twice and a head that disagrees with itself. So the role says only what the file is
for: a test, a function, a config, a decision record. The registry holds each role with a one-sentence definition and the globs that select
it, in the order they are checked, with the subkinds of a role written under it, and it is the one place a glob for a file's role is
written. It is local to catzc and global to every file, so a head and every gate say the same thing about a file, and a consumer extends it
with a config fragment instead of editing it. A provided contract pins the names, so a tool that reads a head may rely on them.

### Module types

`A module is placed by its type, and one registry says where`

What a module is and how its type is declared are in [module-types](../design/module-types.md); the head only carries the result. A file in
no module, such as a documentation page, has neither `module` nor `moduletype`. The catzc bundle a module ships in is read from the exporter
registry, so the head says whether a module is in a built bundle without a second list.

### A head shows the facts, never holds them

`The repository knows the facts; the head is their picture`

Every fact in a block is computed from something else: a registry, git, the disk or the file's own text. A command that reads the fact out
of the block instead trusts a copy that is right only when the file was last imprinted, so its verdict depends on when a formatter ran.
Deriving the fact every time gives one answer whether the file has a block, a stale block or none, and that is what lets the policy add or
remove blocks freely. The imprint reads the block only to say that it differs from what it would write.

### Head policy

`A head where a reader needs one, none where it only repeats`

A block is worth its bytes where a reader cannot easily derive what it says. A generated file names the command that writes it and the
source to edit instead, and stamps the body its writer composed, so a tracked generated file requires one. A file whose front matter another
tool reads, such as an agent definition the editor loads, cannot work without its front matter, so it requires one too. An authored file's
facts are all derivable, so a block on it is a second statement that can drift and adds a diff to every move, and it carries none. The
policy is one setting per file class with its default declared once, so a repository that wants blocks on its authored files changes a
setting, never code.

### How this is enforced

- **`Format-FileMeta`** imprints the `immutable` and `edges` parts and `Test-FileMeta` fails any difference, in scope and in form.
- **`Test-FileMetaProcessors`** fails a kind without its function and a function without a kind.
- **`Test-FileKindReachability.Tests.ps1`** (`Catzc.Base.Globs`) fails a kind no tracked file reaches, and a kind mostly shadowed by an
  earlier one that the registry's `overlaps` does not pair it with (ADR-REPO-FILEMETA-ROLE).
- **`Test-ModuleDependency`** keeps the layers apart ([ADR-AUTO-DEPM](../automation/controlling-module-dependencies.md)).

## Consequences

- A computable fact is in the file, where a reader sees it, and it is the same on every run, so it never adds noise to a diff.
- A fact an author states is written once, in the file of the thing, and the config that needs it gathers it from there.
- Another tool's front matter is never touched, so an agent or skill file keeps working unchanged.
- A new kind of fact or config is a registry entry and a function, reviewed as data and as one file of code.
- The formatter and the pure scanners are testable on strings alone, because they read no config and touch no file.
