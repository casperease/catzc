# ADR: Module model — how a deployable track's modules are found, shaped and ordered

## Rules: ADR-AUTO-MODULE

### Rule ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE

A module of a deployable track ([ADR-DSGN-TRACKTYPE-ONEROLE](../design/track-types.md#rule-adr-dsgn-tracktype-onerole)) is resolved through
the track that holds it, by one resolver, `Get-CatzcModule`. The track is the one the longest place names
([ADR-DSGN-TRACKTYPE-LONGESTPLACEWINS](../design/track-types.md#rule-adr-dsgn-tracktype-longestplacewins)); the module's root is a place of
that track plus the module's name; its module type is one the track type admits
([ADR-DSGN-MODTYPE-TRACKTYPEADMITSMODULETYPES](../design/module-types.md#rule-adr-dsgn-modtype-tracktypeadmitsmoduletypes)). The resolver
returns, for each module, its name, track, root, shape (a folder or one file), files, languages and engines, as one native type
([ADR-AUTO-TYPES-NATIVETYPEDMODEL](BCL/native-csharp-types.md#rule-adr-auto-types-nativetypedmodel)). No other command derives a module's
name, root, languages or engines from a path or a folder listing, and no command spells a track's root: it reads the track. A place whose
modules are internal declares `internal: true` in `module-types.yml` (public is the default on the type); the resolver returns those modules
only when asked to include internal ones, and never infers internal from where a place sits.

- [One resolver through the track](#one-resolver-through-the-track)

### Rule ADR-AUTO-MODULE-EXISTSBYLAYOUT

A module exists when its files stand in its **layout**; nothing registers it, and no descriptor file declares it. The layout is the one
table of folders inside a module and what each holds (public functions at the root, `private/`, `types/`, `configs/`, `assets/`, `tests/`),
declared once under each file language in `languages.yml`, with its default on the config type
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). A module's name, track, root, shape,
files, languages and order are derived from placement; its needs (`dependencies.yml`), packages (`files.yml`) and an engine override are the
only facts declared, and a module's existence is never declared. A file inside a module folder that the layout does not place is a finding.
The aspects ([ADR-DSGN-ASPECT-ASPECTSAREDERIVED](../design/module-aspects.md#rule-adr-dsgn-aspect-aspectsarederived)) read their live
patterns from the layout and every command that reads a module's folders reads the layout, except the loader that runs before the types
load, which a test holds to the layout.

- [Registration is placement](#registration-is-placement)

### Rule ADR-AUTO-MODULE-LANGUAGESFROMFILES

A module's languages are the file languages of its live files, and each must be one the track declares
([ADR-DSGN-TRACK-FILELANGUAGE](../design/tracks.md#rule-adr-dsgn-track-filelanguage)); a file in another language is a stack violation
([ADR-DSGN-TRACK-STACKVIOLATION](../design/tracks.md#rule-adr-dsgn-track-stackviolation)). Languages are modelled in general, whatever they
are: a track admits a language by declaring it, and the Go, Python and Bash rules say what each language's track holds beyond its modules.
The formatter, the checks and the test handler of a file language are declared once per language in `languages.yml`, and a command that
needs them reads them there ([ADR-PRIN-CONFIG](../principles/configure-not-program.md)).

- [Languages](#languages)

### Rule ADR-AUTO-MODULE-ENGINESUBSET

A module's execution engines are a subset of the closed set
([ADR-AUTO-ENGINE-THREEENGINES](execution-engines.md#rule-adr-auto-engine-threeengines)). A track declares the engines its modules run
under, and a module overrides the track's list only when it differs from it; a module that names none takes the track's, and a track that
names none leaves the choice open as `auto`
([ADR-AUTO-ENGINE-AUTONAMESNOENGINE](execution-engines.md#rule-adr-auto-engine-autonamesnoengine)). A black-box test of the module runs once
per engine the module names ([ADR-AUTO-ENGINE-STARTENVIRONMENT](execution-engines.md#rule-adr-auto-engine-startenvironment)).

- [Engines](#engines)

### Rule ADR-AUTO-MODULE-TOPOLOGICALORDER

The order of modules is the topological order of the declared graph
([ADR-AUTO-DEPM-UNIFIEDGRAPH](controlling-module-dependencies.md#rule-adr-auto-depm-unifiedgraph),
[ADR-AUTO-DEPM-GROUPAWAREINTEGRITY](controlling-module-dependencies.md#rule-adr-auto-depm-groupawareintegrity)): foundation first, ties
broken ordinally. One function sorts the graph, over module names, and every command that needs modules in dependency order calls it and
never sorts again. A load order is no dependency order, because a module declares its needs and never imports another.

- [One order](#one-order)

### Rule ADR-AUTO-MODULE-CHECKSBYLANGUAGE

A check and a test of a module are resolved by the file language, from the language registry, and never by a branch on a language in a
command: a new language adds a registry entry and its handlers ([ADR-AUTO-EXTEND](open-closed-architecture.md),
[ADR-PRIN-CONFIG](../principles/configure-not-program.md)). The build of a module into a bundle is the bundle's
([ADR-AUTO-BUNDLE-BUNDLEISBUILD](platform-bundle.md#rule-adr-auto-bundle-bundleisbuild)): it is code in the closed builder, not a handler,
and this rule does not cover it.

- [Handlers by language](#handlers-by-language)

### Rule ADR-AUTO-MODULE-NAMESPACEISTRACK

A module's namespace is the name of the track that holds it, derived from placement like the track itself, and never written into the
module's name. The modules of the `pwsh` track keep their `Catzc.Base.*`, `Catzc.Azure.*` and `Catzc.Tooling.*` names, and their namespace
is `pwsh`. This is the namespace of the module as an object; the C# namespace of its types is the module's name
([ADR-AUTO-TYPES-NAMESPACEISMODULE](BCL/native-csharp-types.md#rule-adr-auto-types-namespaceismodule)).

- [Namespace](#namespace)

### Rule ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE

A **language track** is a `modules` track of one language (`pwsh`, `python`, `go`, `bash`, a future `javascript`), and every language track
holds its modules the same way, pwsh being one language among the others: a module is a non-dot folder directly under the track's root,
named by the folder; the track's own test holder, `<root>/tests/<kebab>`, one folder per catzc module tested from outside, is declared
`except` on the folder place in `module-types.yml`, so it resolves to the track's own module, the root place, and never to a module named
`tests`; a module's own tests sit in its `tests/` folder, the shared layout row, and run through the same bridge as the holder's folders. No
command branches on a language or on a track-type id: the engine's track is the one whose `execution_engines` name the engine the resolver
runs in, the one the relocatable modules root holds; a laid-out track is one whose primary language owns a live layout row; and a new
language is registry entries, a track in `variants.yml`, a module type with its places, layout rows and a `tests` entry with its test-file
`pattern` in `languages.yml`, and one config of its own (`python.yml`, `go.yml`, `bash.yml`), never a branch.

- [Every language track alike](#every-language-track-alike)

## Context

`ADR-AUTO-MODULE` sits under [ADR-DSGN-TRACK](../design/tracks.md): it cites `ADR-DSGN-TRACK`,
[ADR-DSGN-TRACKTYPE](../design/track-types.md) and [ADR-DSGN-MODTYPE](../design/module-types.md) as the rules it specialises. A track is the
repository's root entity, a deployable track ([ADR-DSGN-TRACKTYPE-ONEROLE](../design/track-types.md#rule-adr-dsgn-tracktype-onerole)) holds
modules, and the module types say what each sort of module is. Those three decide what a track, a module and a module type are; this ADR
decides how the modules of a deployable track are found and what a reader can ask of one. It restates none of the three. It sits in the
`automation` domain because the domain order lets `automation` cite `design` and not the other way round.

A module that several commands each find for themselves, with a folder walk and a copy of the folder rules in each, is found differently by
each of them, and the copies drift apart. One resolver, built on the track and the layout, is the single place that answers what a module
is, so a reader asks it and a change to the folder rules is made once.

### One resolver through the track

The track is the first fact about a module: it says which root the module's folder sits under, which module types are admitted, and which
file languages and engines the module may use. A resolver that takes the track from `Get-Track` never spells a root, so a track whose place
changes is a data edit. The module type registry names the module a path is placed in; the resolver builds on it and adds what lies below
the module's root. The resolver's answer is identity only. A module's needs are declared in `dependencies.yml`, which a module above the
resolver owns, so the needs, the closure and the order are functions over module names, not members of the resolved type.

Whether a place holds internal modules is a declared fact of the place, not a rule read from the tree. A rule such as "a place nested below
the track's place is internal" makes a track whose places are split or moved change what the resolver returns, with nothing in the data
saying so. A flag on the place keeps the answer in config ([ADR-PRIN-CONFIG](../principles/configure-not-program.md)), so moving a place
never turns its modules public or internal by accident.

### Registration is placement

A person adds a module by putting correctly named files in the layout's folders, and removes it by deleting them. There is nothing else to
update, so there is nothing to forget. The layout is config with a sensible default, resolved in the one order of
[ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](sensible-defaults.md#rule-adr-auto-default-oneresolutionorder): the caller's value, the owning
module's configuration, then the default declared on the type. A consumer repository overlays only a difference
([ADR-AUTO-OVERLAY](consumer-overlay.md)). A file the layout does not place is reported, so a misplaced file is never silently not part of a
module. The existence of a module is the one fact no config states.

### Languages

The file languages are a registry keyed by extension ([ADR-DSGN-TRACK-FILELANGUAGE](../design/tracks.md#rule-adr-dsgn-track-filelanguage));
a module's languages are read from its files through it, so no module lists its own. Keeping the language axis general lets a track admit a
language by a line of config; the track's declared languages are what stops a stray one.

### Engines

A module is tested and run under the engines it names. Most modules need one engine; the few that ship POSIX scripts need more. Stating the
engines on the track and overriding them on the module keeps the common case to one line and the exception visible.

### One order

Every consumer that needs an order of modules wants the same one, the dependency order of the declared graph. Computing it in one place
keeps a change to the graph a single change.

### Handlers by language

Checks are declared per file language. A test handler per file language extends the same mechanism, so that the next language is an entry,
not a branch.

### Namespace

The track is already a fact the resolver returns for every module, so the namespace adds no declaration: it is the track, read the same way.
A name that also spelled the track would state one fact twice, and the copy in the name would go stale whenever a module's track changes.

### Every language track alike

The pwsh track carries the tooling, and for a while it was the only track that held modules: the other language tracks were each one holder
of black-box test projects, and three commands branched on the `modules` id to find "the" modules. That shape made the first module outside
pwsh impossible without a special case, and every later language would have repeated it. The model is generic on paper, a track declared
once, a type that admits module types, a module type with places, a layout per language, so the fix is to let it be generic in practice: the
language tracks take the same type, the same folder place and the same layout rows, and the one thing pwsh never had, a test holder at the
track root, is declared on the place as the track's own folder rather than carried by a track type of its own. What was specific to pwsh,
the relocatable modules root, is tied to the fact that makes it special, the engine its modules run under, so the resolver reads
`execution_engines` and never a type id. A third language is then a rehearsal the resolver's tests already run: a fixture track of another
name, with its folder place, its `except` and one layout row, resolves with no code change.

## Decision

Resolve every module of a deployable track through its track with one resolver
([ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE](#rule-adr-auto-module-deployabletrackmodule)); let placement in the layout register a module and
report what the layout does not place ([ADR-AUTO-MODULE-EXISTSBYLAYOUT](#rule-adr-auto-module-existsbylayout)); read languages from the
files and keep them within the track's declared languages ([ADR-AUTO-MODULE-LANGUAGESFROMFILES](#rule-adr-auto-module-languagesfromfiles));
declare engines on the track with a per-module override ([ADR-AUTO-MODULE-ENGINESUBSET](#rule-adr-auto-module-enginesubset)); sort the graph
once ([ADR-AUTO-MODULE-TOPOLOGICALORDER](#rule-adr-auto-module-topologicalorder)); resolve checks and tests by language
([ADR-AUTO-MODULE-CHECKSBYLANGUAGE](#rule-adr-auto-module-checksbylanguage)); take a module's namespace from its track
([ADR-AUTO-MODULE-NAMESPACEISTRACK](#rule-adr-auto-module-namespaceistrack)); and hold every language track alike, with its test holder
declared on the place and the engine's track read from its engines
([ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE](#rule-adr-auto-module-everylanguagetrackalike)).

### How this is enforced

- **The config types** (`LanguagesConfig`, `VariantsConfig`) fail the load on an unknown layout key, a layout row that names a folder twice,
  an engine outside the closed set, and a track or module that names an engine twice.
- **A resolver integrity test** checks that every module folder under every deployable track resolves, that its languages are within the
  track's, that every language has its handlers, and that the order is topological.
- **A loader test** compares the loader's own folder rules with the layout.
- **`Test-ModuleDependency`** checks the declared graph the order is computed from
  ([ADR-AUTO-DEPM-GROUPAWAREINTEGRITY](controlling-module-dependencies.md#rule-adr-auto-depm-groupawareintegrity)).
- **`Get-ChangeCheckPlan`** resolves the checks of a changed file from its language's `checks` list in `languages.yml`, so `Test-Change`
  runs a gate because the registry names it for the language, never because a command names the language
  ([ADR-AUTO-MODULE-CHECKSBYLANGUAGE](#rule-adr-auto-module-checksbylanguage)).
- **`Get-LanguageTestOutcomes`** runs a language's tests through the runner its `tests` entry in `languages.yml` names, and
  `Get-LanguageTestExecutable` resolves the tools that entry lists, so a new test language is a registry entry and its runner; the config
  type fails the load on an entry that names both tools and an engine, or neither, or no test-file `pattern`
  ([ADR-AUTO-MODULE-CHECKSBYLANGUAGE](#rule-adr-auto-module-checksbylanguage)).
- **`Get-CatzcModule -EngineTrack`** returns the modules of the track whose `execution_engines` name the running engine, the modules the
  importer loads and the dependency graph declares, and anchors that track alone on the relocatable modules root; **`ModulePlace`** reads
  `except` on a folder place and names no module for an excepted folder; **`Get-LanguageTestFolders`** reads the languages with a `tests`
  entry from the registry, each root from the language's own config and each pattern from the entry, and yields a module's own `tests/`
  folder beside the holder's; **`New-PythonProject`** and **`New-GoWorkspace`** make every module folder of their track a workspace member;
  and the resolver's tests resolve a third fixture language with no code change
  ([ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE](#rule-adr-auto-module-everylanguagetrackalike)).

## Consequences

- A new module needs only its files in the right folders; a wrongly placed file is reported by name.
- One resolver replaces four folder walks, so a track's root is read from the track and nowhere spelled.
- The layout, the aspect patterns and the build's shipped folders cannot drift, because they read one table.
- The cost is a resolver that sits low in the module graph (it needs the tracks, the languages and the engines), and a loader that cannot
  call it and is held to the layout by a test instead.
