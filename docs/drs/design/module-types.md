# Design: Module types — what a module is placed as

## Rules: DDR-MODTYPE

### Rule DDR-MODTYPE-MODULEISPLACEDUNIT

A **module** is a named unit placed in a track: a PowerShell module is a folder under `pwsh/` or one `psm1` file, a Bicep module is a
template folder or one reusable `bicep` file, and a holder track's module is the holder itself (the vendor settings, the ADO pipelines, the
GitHub workflows). A file in no module, such as a documentation page, has neither `module` nor `moduletype`.

- [Modules](#modules)

### Rule DDR-MODTYPE-MODULETYPEISSORT

A **module type** is the sort of module, named without the word module (`pwsh-folder`, `pwsh-psm1`, `bicep`, `pipeline`, `settings`,
`python`, `go`, `bash`), and the module-types registry (`module-types.yml`, `Catzc.Base.Variants`) declares it once: its definition and its
**places**, the paths where modules of the type are found and how a path there names its module (a folder, one file by extension, or the
place's root). `module` and `moduletype` are read from the registry and never guessed from a folder name.

- [Module types](#module-types)

### Rule DDR-MODTYPE-TRACKTYPEADMITS

Each track type **admits** a set of module types, declared on the track type ([DDR-TRACKTYPE-TYPESDECLAREDONCE][r1]), and a module's type
must be admitted by the type of the track that holds it: `modules` admits `pwsh-folder`, `pwsh-psm1`, `python`, `go` and `bash`, one module
type per language track, `infrastructure` admits `bicep`, `pipelines` admits `pipeline` (the track's vendor says which platform),
`vendor-settings` admits `settings`, and `vendored-code` admits the module types of the track it is nested in. A module of a type its track
does not admit is a load failure, so a second stack inside a track shows as a violation without reading the file
([DDR-TRACK-ONETECHSTACK](tracks.md#rule-ddr-track-onetechstack)).

- [Types and tracks](#types-and-tracks)

### Rule DDR-MODTYPE-DEPLOYABLEORHOLDERMODULE

A deployable track's module is a unit of delivery; a holder track's module is the holder itself, one module per track, so its `module` is
the track's name. A language track has, beside its folder modules, its own module, the root place named by the track, which holds what no
folder module holds: the test holder and the generated project files. A module's bundle (`catzc_bundle`) is read from the exporter registry
for a module of a deployable track and is left out for a holder's, so a head never lists a bundle for a file that is not bundled.

- [Types and tracks](#types-and-tracks)

## Context

### Modules

The word module is used for a PowerShell folder, a Bicep template, a tool's dot-folder and a Python project. They share one fact: each is a
unit with a name and a place. The module-types registry states that fact once per sort. The generic module model (members, languages,
engines, order) is a separate concern; this DDR fixes only a module's placement and type.

### Module types

Separating the sort (module type) from the track (track type) matters because a track can hold several sorts of module (`automation` holds
folder and `psm1` modules) and a sort can sit in more than one place (`pipeline` in two tracks, `settings` in several). Each of the two is
one declaration; the relation between them is the `admits` list, which is the only place the two meet.

### Types and tracks

Admission is the check that keeps a track one stack: the track type says what its tracks may contain, and the module type says what a module
is. A holder's single module keeps the head honest: the `settings` module of a `vendor-settings` track is the whole track, so a reader never
looks for a module folder where none exists.

## Decision

A module is a unit placed in a track; its type comes from the registry
([DDR-MODTYPE-MODULEISPLACEDUNIT](#rule-ddr-modtype-moduleisplacedunit),
[DDR-MODTYPE-MODULETYPEISSORT](#rule-ddr-modtype-moduletypeissort)); its track type must admit it
([DDR-MODTYPE-TRACKTYPEADMITS](#rule-ddr-modtype-tracktypeadmits)); a holder's module is the holder
([DDR-MODTYPE-DEPLOYABLEORHOLDERMODULE](#rule-ddr-modtype-deployableorholdermodule)).

### How this is enforced

- **`Test-TrackDeclaration`** fails a module type with a place in a track whose track type does not admit it.
- **The config types** fail the load on an unknown key and a module type without a definition or a place.
- **`Test-FileMeta`** compares `module`, `moduletype` and `catzc_bundle` in each head with the registry.

## Consequences

- One registry says what a module is; the file-meta decision record only says the head carries it.
- `pipeline` stays one module type: the platform is the track's vendor, so ADO and GitHub pipelines differ by a declared fact, not by a
  second type.
- The cost is one more declaration (the `admits` list on each track type), done by regeneration of the heads.

[r1]: track-types.md#rule-ddr-tracktype-typesdeclaredonce
