---
catzc:
  immutable:
    with_body_sha: "4316b55080b9"
    repo_status: clean
    path: docs/adr/design/module-types.md
    folder: docs/adr/design
    name: module-types
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-DSGN-MODTYPE#{1-4}
    cites:
      - ADR-DSGN-TRACK#3
      - ADR-DSGN-TRACKTYPE#4
    links:
      - docs/adr/design/track-types.md#rule-adr-dsgn-tracktype4
      - docs/adr/design/tracks.md#rule-adr-dsgn-track3
---

# ADR: Module types — what a module is placed as

## Rules: ADR-DSGN-MODTYPE

### Rule ADR-DSGN-MODTYPE:1

A **module** is a named unit placed in a track: a PowerShell module is a folder under `automation` or one `psm1` file, a Bicep module is a
template folder or one reusable `bicep` file, and a holder track's module is the holder itself (the vendor settings, the ADO pipelines, the
GitHub workflows). A file in no module, such as a documentation page, has neither `module` nor `moduletype`.

- [Modules](#modules)

### Rule ADR-DSGN-MODTYPE:2

A **module type** is the sort of module, named without the word module (`pwsh-folder`, `pwsh-psm1`, `bicep`, `pipeline`, `settings`,
`python`, `go`, `bash`), and the module-types registry (`module-types.yml`, `Catzc.Base.Variants`) declares it once: its definition and its
**places**, the paths where modules of the type are found and how a path there names its module (a folder, one file by extension, or the
place's root). `module` and `moduletype` are read from the registry and never guessed from a folder name.

- [Module types](#module-types)

### Rule ADR-DSGN-MODTYPE:3

Each track type **admits** a set of module types, declared on the track type
([ADR-DSGN-TRACKTYPE#4](track-types.md#rule-adr-dsgn-tracktype4)), and a module's type must be admitted by the type of the track that holds
it: `modules` admits `pwsh-folder` and `pwsh-psm1`, `infrastructure` admits `bicep`, `pipelines` admits `pipeline` (the track's vendor says
which platform), `vendor-settings` admits `settings`, `vendored-code` admits the module types of the track it is nested in, and
`verification` admits `python`, `go` and `bash`. A module of a type its track does not admit is a load failure, so a second stack inside a
track shows as a violation without reading the file ([ADR-DSGN-TRACK#3](tracks.md#rule-adr-dsgn-track3)).

- [Types and tracks](#types-and-tracks)

### Rule ADR-DSGN-MODTYPE:4

A deployable track's module is a unit of delivery; a holder track's module is the holder itself, one module per track, so its `module` is
the track's name. A module's bundle (`catzc_bundle`) is read from the exporter registry for a module of a deployable track and is left out
for a holder's, so a head never lists a bundle for a file that is not bundled.

- [Types and tracks](#types-and-tracks)

## Context

### Modules

The word module is used for a PowerShell folder, a Bicep template, a tool's dot-folder and a Python project. They share one fact: each is a
unit with a name and a place. The module-types registry states that fact once per sort. The generic module model (members, languages,
engines, order) is a separate concern; this ADR fixes only a module's placement and type.

### Module types

Separating the sort (module type) from the track (track type) matters because a track can hold several sorts of module (`automation` holds
folder and `psm1` modules) and a sort can sit in more than one place (`pipeline` in two tracks, `settings` in several). Each of the two is
one declaration; the relation between them is the `admits` list, which is the only place the two meet.

### Types and tracks

Admission is the check that keeps a track one stack: the track type says what its tracks may contain, and the module type says what a module
is. A holder's single module keeps the head honest: the `settings` module of a `vendor-settings` track is the whole track, so a reader never
looks for a module folder where none exists.

## Decision

A module is a unit placed in a track; its type comes from the registry ([ADR-DSGN-MODTYPE#1](#rule-adr-dsgn-modtype1),
[ADR-DSGN-MODTYPE#2](#rule-adr-dsgn-modtype2)); its track type must admit it ([ADR-DSGN-MODTYPE#3](#rule-adr-dsgn-modtype3)); a holder's
module is the holder ([ADR-DSGN-MODTYPE#4](#rule-adr-dsgn-modtype4)).

### How this is enforced

- **`Test-TrackDeclaration`** fails a module type with a place in a track whose track type does not admit it.
- **The config types** fail the load on an unknown key and a module type without a definition or a place.
- **`Test-FileMeta`** compares `module`, `moduletype` and `catzc_bundle` in each head with the registry.

## Consequences

- One registry says what a module is; the file-meta ADR only says the head carries it.
- `pipeline` stays one module type: the platform is the track's vendor, so ADO and GitHub pipelines differ by a declared fact, not by a
  second type.
- The cost is one more declaration (the `admits` list on each track type), done by regeneration of the heads.
