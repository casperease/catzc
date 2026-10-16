# ADR: Module model — how a deployable track's modules are found, shaped and ordered

## Rules: ADR-AUTO-MODULE

### Rule ADR-AUTO-MODULE:1

A module of a deployable track ([ADR-DSGN-TRACKTYPE#2](../design/track-types.md#rule-adr-dsgn-tracktype2)) is resolved through the track
that holds it, by one resolver, `Get-CatzcModule`. The track is the one the longest place names
([ADR-DSGN-TRACKTYPE#5](../design/track-types.md#rule-adr-dsgn-tracktype5)); the module's root is a place of that track plus the module's
name; its module type is one the track type admits ([ADR-DSGN-MODTYPE#3](../design/module-types.md#rule-adr-dsgn-modtype3)). The resolver
returns, for each module, its name, track, root, shape (a folder or one file), files, languages and engines, as one native type
([ADR-AUTO-TYPES#9](BCL/native-csharp-types.md#rule-adr-auto-types9)). No other command derives a module's name, root, languages or
engines from a path or a folder listing, and no command spells a track's root: it reads the track.

- [One resolver through the track](#one-resolver-through-the-track)

### Rule ADR-AUTO-MODULE:2

A module exists when its files stand in its **layout**; nothing registers it, and no descriptor file declares it. The layout is the one
table of folders inside a module and what each holds (public functions at the root, `private/`, `types/`, `configs/`, `assets/`,
`tests/`), declared once under each file language in `languages.yml`, with its default on the config type
([ADR-AUTO-DEFAULT#6](sensible-defaults.md#rule-adr-auto-default6)). A module's name, track, root, shape, files, languages and order are
derived from placement; its needs (`dependencies.yml`), packages (`files.yml`) and an engine override are the only facts declared, and a
module's existence is never declared. A file inside a module folder that the layout does not place is a finding. The aspects
([ADR-DSGN-ASPECT#2](../design/module-aspects.md#rule-adr-dsgn-aspect2)) read their live patterns from the layout and every command that
reads a module's folders reads the layout, except the loader that runs before the types load, which a test holds to the layout.

- [Registration is placement](#registration-is-placement)

### Rule ADR-AUTO-MODULE:3

A module's languages are the file languages of its live files, and each must be one the track declares
([ADR-DSGN-TRACK#6](../design/tracks.md#rule-adr-dsgn-track6)); a file in another language is a stack violation
([ADR-DSGN-TRACK#11](../design/tracks.md#rule-adr-dsgn-track11)). Languages are modelled in general, whatever they are: a track admits a
language by declaring it, and the Go, Python and Bash rules keep those languages to the test artifacts of the verification tracks. The
formatter, the checks and the test handler of a file language are declared once per language in `languages.yml`, and a command that needs
them reads them there ([ADR-PRIN-CONFIG](../principles/configure-not-program.md)).

- [Languages](#languages)

### Rule ADR-AUTO-MODULE:4

A module's execution engines are a subset of the closed set ([ADR-AUTO-ENGINE#1](execution-engines.md#rule-adr-auto-engine1)). A track
declares the engines its modules run under, and a module overrides the track's list only when it differs from it; a module that names none
takes the track's, and a track that names none leaves the choice open as `auto`
([ADR-AUTO-ENGINE#7](execution-engines.md#rule-adr-auto-engine7)). A black-box test of the module runs once per engine the module names
([ADR-AUTO-ENGINE#4](execution-engines.md#rule-adr-auto-engine4)).

- [Engines](#engines)

### Rule ADR-AUTO-MODULE:5

The order of modules is the topological order of the declared graph ([ADR-AUTO-DEPM#2](controlling-module-dependencies.md#rule-adr-auto-depm2),
[ADR-AUTO-DEPM#4](controlling-module-dependencies.md#rule-adr-auto-depm4)): foundation first, ties broken ordinally. One function sorts
the graph, over module names, and every command that needs modules in dependency order calls it and never sorts again. A load order is no
dependency order, because a module declares its needs and never imports another.

- [One order](#one-order)

### Rule ADR-AUTO-MODULE:6

A check and a test of a module are resolved by the file language, from the language registry, and never by a branch on a language in a
command: a new language adds a registry entry and its handlers
([ADR-AUTO-EXTEND](open-closed-architecture.md), [ADR-PRIN-CONFIG](../principles/configure-not-program.md)). The build of a module into a
bundle is the bundle's ([ADR-AUTO-BUNDLE#1](platform-bundle.md#rule-adr-auto-bundle1)): it is code in the closed builder, not a handler,
and this rule does not cover it.

- [Handlers by language](#handlers-by-language)

## Context

`ADR-AUTO-MODULE` sits under [ADR-DSGN-TRACK](../design/tracks.md): it cites `ADR-DSGN-TRACK`,
[ADR-DSGN-TRACKTYPE](../design/track-types.md) and [ADR-DSGN-MODTYPE](../design/module-types.md) as the rules it specialises. A track is
the repository's root entity, a deployable track ([ADR-DSGN-TRACKTYPE#2](../design/track-types.md#rule-adr-dsgn-tracktype2)) holds
modules, and the module types say what each sort of module is. Those three decide what a track, a module and a module type are; this ADR
decides how the modules of a deployable track are found and what a reader can ask of one. It restates none of the three. It sits in the
`automation` domain because the domain order lets `automation` cite `design` and not the other way round.

A module that several commands each find for themselves, with a folder walk and a copy of the folder rules in each, is found differently by
each of them, and the copies drift apart. One resolver, built on the track and the layout, is the single place that answers what a module
is, so a reader asks it and a change to the folder rules is made once.

### One resolver through the track

The track is the first fact about a module: it says which root the module's folder sits under, which module types are admitted, and which
file languages and engines the module may use. A resolver that takes the track from `Get-Track` never spells a root, so a track whose place
changes is a data edit. The module type registry names the module a path is placed in; the resolver builds on it and adds what lies below the
module's root. The resolver's answer is identity only. A module's needs are declared in `dependencies.yml`, which a module above the
resolver owns, so the needs, the closure and the order are functions over module names, not members of the resolved type.

### Registration is placement

A person adds a module by putting correctly named files in the layout's folders, and removes it by deleting them. There is nothing else to
update, so there is nothing to forget. The layout is config with a sensible default, resolved in the one order of
[ADR-AUTO-DEFAULT#6](sensible-defaults.md#rule-adr-auto-default6): the caller's value, the owning module's configuration, then the default
declared on the type. A consumer repository overlays only a difference
([ADR-AUTO-OVERLAY](consumer-overlay.md)). A file the layout does not place is reported, so a misplaced file is never silently not part of
a module. The existence of a module is the one fact no config states.

### Languages

The file languages are a registry keyed by extension ([ADR-DSGN-TRACK#6](../design/tracks.md#rule-adr-dsgn-track6)); a module's
languages are read from its files through it, so no module lists its own. Keeping the language axis general lets a track admit a language by
a line of config; the track's declared languages are what stops a stray one.

### Engines

A module is tested and run under the engines it names. Most modules need one engine; the few that ship POSIX scripts need more. Stating the
engines on the track and overriding them on the module keeps the common case to one line and the exception visible.

### One order

Every consumer that needs an order of modules wants the same one, the dependency order of the declared graph. Computing it in one place
keeps a change to the graph a single change.

### Handlers by language

Checks are declared per file language. A test handler per file language extends the same mechanism, so that the next language is an
entry, not a branch.

## Decision

Resolve every module of a deployable track through its track with one resolver
([ADR-AUTO-MODULE#1](#rule-adr-auto-module1)); let placement in the layout register a module and report what the layout does not place
([ADR-AUTO-MODULE#2](#rule-adr-auto-module2)); read languages from the files and keep them within the track's declared languages
([ADR-AUTO-MODULE#3](#rule-adr-auto-module3)); declare engines on the track with a per-module override
([ADR-AUTO-MODULE#4](#rule-adr-auto-module4)); sort the graph once ([ADR-AUTO-MODULE#5](#rule-adr-auto-module5)); and resolve checks and
tests by language ([ADR-AUTO-MODULE#6](#rule-adr-auto-module6)).

### How this is enforced

- **The config types** (`LanguagesConfig`, `VariantsConfig`) fail the load on an unknown layout key, a layout row that names a folder
  twice, an engine outside the closed set, and a track or module that names an engine twice.
- **A resolver integrity test** checks that every module folder under every deployable track resolves, that its languages are within the
  track's, that every language has its handlers, and that the order is topological.
- **A loader test** compares the loader's own folder rules with the layout.
- **`Test-ModuleDependency`** checks the declared graph the order is computed from ([ADR-AUTO-DEPM#4](controlling-module-dependencies.md#rule-adr-auto-depm4)).

## Consequences

- A new module needs only its files in the right folders; a wrongly placed file is reported by name.
- One resolver replaces four folder walks, so a track's root is read from the track and nowhere spelled.
- The layout, the aspect patterns and the build's shipped folders cannot drift, because they read one table.
- The cost is a resolver that sits low in the module graph (it needs the tracks, the languages and the engines), and a loader that cannot
  call it and is held to the layout by a test instead.
