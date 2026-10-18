# ADR: Track types — what a track owns, and where tracks are declared

## Rules: ADR-DSGN-TRACKTYPE

### Rule ADR-DSGN-TRACKTYPE:1

A **track type** is the sort of cluster a track is, and it is one of a closed set, each with a one-sentence definition: `modules`,
`infrastructure`, `pipelines`, `vendor-settings`, `vendored-code`, `contracts`, `documentation`, `verification` and `unordered`.
Configuration is no track type: it is a file role (the `config` kind), static files kept in the repository inside a module or inside a
vendor-settings track, and it follows its owner. A track has exactly one type. A new tech-stack that ships (a `services` or `frontend`
track, [ADR-DSGN-TRACK#3](tracks.md#rule-adr-dsgn-track3)) adds its type to the set in the same change that opens the track, never before
it.

- [Track types](#track-types)

### Rule ADR-DSGN-TRACKTYPE:2

A track type has one **role**. A **deployable track** (`modules`, `infrastructure`, and the future `services` and `frontend`) _owns_
deployable-units: collections of the track's modules that the repository delivers through CI/CD
([ADR-DSGN-TRACK#5](tracks.md#rule-adr-dsgn-track5)). A **holder track** (every other type) _is_ a module more than it owns modules: it
holds one vendor's or one tool's files for this repository, or one purpose's, and it ships nothing of its own. The role is declared on the
track type, never on the track.

- [Deployable and holder tracks](#deployable-and-holder-tracks)

### Rule ADR-DSGN-TRACKTYPE:3

A track may name the **vendor** that reads its files: the platform or tool, from a closed set declared once with a definition each (`azure`,
`ado`, `github`, `claude`, `cspell`, `vscode`; a new vendor is an entry). A vendor is never mixed into another vendor's track, and one
vendor may have several tracks (`github` has a `pipelines` track and a `vendor-settings` track; `claude` may split its settings from its
tooling kit). The ADO pipelines (`pipelines/`, vendor `ado`) and the GitHub workflows (`.github/workflows`, vendor `github`) are two tracks
of one type, `pipelines`, because each is read by a different platform and bound to a different pipeline model. The settings of each tool
the repository configures are one `vendor-settings` track per vendor (`.claude`, `.cspell`, the `.github` files that are not workflows, and
`.vscode` once git tracks a file in it). The `infrastructure` track has vendor `azure`. `vendor` is the platform that reads a file and never
the third party that wrote it.

- [Vendors](#vendors)

### Rule ADR-DSGN-TRACKTYPE:4

A track is **declared once**, in the `tracks` map of `variants.yml` (`Catzc.Base.Variants`, the repo-wide variants), as its name, its type,
its places (the paths it covers), its vendor when it has one ([ADR-DSGN-TRACKTYPE#3](#rule-adr-dsgn-tracktype3)) and its file languages
([ADR-DSGN-TRACK#6](tracks.md#rule-adr-dsgn-track6)). The track types are declared once, in `track-types.yml` of the same module, each with
its definition, its role ([ADR-DSGN-TRACKTYPE#2](#rule-adr-dsgn-tracktype2)) and the module types it admits
([ADR-DSGN-MODTYPE#3](module-types.md#rule-adr-dsgn-modtype3)). No other file lists a track, a track type or a place: a command, a gate and
a globset read them through `Get-Track`.

- [Where the declarations live](#where-the-declarations-live)

### Rule ADR-DSGN-TRACKTYPE:5

A file belongs to the track with the **longest place** that contains it, so a narrower place wins over a wider one: a file under
`.github/workflows` is in the GitHub `pipelines` track, and the rest of `.github` is in the GitHub `vendor-settings` track. Two places of
different tracks that are equally long and both contain a file, a place that no file resolves to, and a tracked file in no track that is not
a root file are load failures. The answer to "which track holds this file" is therefore one value, computed.

- [Where the declarations live](#where-the-declarations-live)

### Rule ADR-DSGN-TRACKTYPE:6

A file's head carries `track`, `tracktype` and, when the track has one, `vendor`, all read from the declaration and never guessed from a
folder name, and each left out for a root file. `tracktype` and `vendor` are head keys that the provided head schema and its sample list. A
file head never carries the track's role, places or languages: a reader looks those up by the track's name.

- [Where the declarations live](#where-the-declarations-live)

### Rule ADR-DSGN-TRACKTYPE:7

A track of **vendored code** holds code written by a third party that the repository does not author, such as `pwsh/.vendor` and
`bash/.vendor`. It is nested under another track's root and gets its files by the longest place
([ADR-DSGN-TRACKTYPE#5](#rule-adr-dsgn-tracktype5)), so the track beside it never holds them. Its files are never live
([ADR-DSGN-TRACK#11](tracks.md#rule-adr-dsgn-track11)).

- [Vendored code](#vendored-code)

## Context

The repository holds more than code to deploy. Its `automation` and `infrastructure` trees are collections of modules that CI/CD delivers;
its `pipelines/` and `.github/workflows` trees are the repository's own pipeline definitions for two different platforms; its dot-folders
configure the tools that read them; its `.vendor` folders hold code written elsewhere. Calling all of these "root folders" hides the
difference that matters: which tracks produce a deliverable, and which only hold a vendor's configuration or a third party's code. A name
for the type of track, declared once, makes that difference a fact a gate can check.

### Track types

`modules` holds PowerShell and C# modules; `infrastructure` holds Bicep templates and reusable Bicep modules; `pipelines` holds pipeline
definitions, Azure DevOps or GitHub Actions by vendor; `vendor-settings` holds the settings of one tool the repository configures;
`vendored-code` holds code written by a third party; `contracts` holds the repository's boundary contracts, in both directions;
`documentation` holds the ADRs, references and guides; `verification` holds the black-box test projects (Go, Python, Bash); `unordered` is
where imports land ([ADR-DSGN-TRACK#17](tracks.md#rule-adr-dsgn-track17)). Configuration is a file role, not a type: `configs/*.yml` belongs
to its module's track and `settings.json` to its vendor-settings track.

### Deployable and holder tracks

The line between deployable and holder follows the delivery model, not the folder. A deployable track has modules that are built, verified
and promoted as units, so it carries aspects ([ADR-DSGN-ASPECT](module-aspects.md)), globsets and a pipeline per deployable-unit. A holder
track carries none of that: its files are read by a platform or a tool, and its only checks are that they are well-formed and in the right
place. A holder is therefore small, and a vendor change touches only its holder.

### Vendors

A vendor is the platform or tool that reads a track's files, and it is a fact of the track, not of the folder name. Pipelines show why: the
ADO and GitHub definitions are the same sort of thing read by two platforms, so they share a type and differ by vendor, where two types
would make the sort of thing look like two things. Settings show the other side: four tools with four sets of files are four tracks of one
type, so a change to one tool's settings never re-keys another's. The word has one meaning here; the third party that wrote a vendored file
is not its vendor.

### Where the declarations live

A track and a track type are data, not code ([ADR-PRIN-CONFIG](../principles/configure-not-program.md)): a new track is an entry, a new type
is an entry plus the handler its role needs, and neither is a branch in a command. The declaration sits with the variants because a track is
a repository-wide variant, and the types sit beside it so the closed set and the tracks are validated together at load by the config types.

### Vendored code

Code written by a third party has its own upstream and update path, and none of its files is the repository's to change in place. Giving it
a track of its own keeps the neighbouring track's checks, aspects and counts about code the repository writes, and the longest-place rule
gives it its files without a list of exclusions.

## Decision

Name the type of a track and declare it once. A track is a cluster of module contents ([ADR-DSGN-TRACK#1](tracks.md#rule-adr-dsgn-track1))
with one of a closed set of types ([ADR-DSGN-TRACKTYPE#1](#rule-adr-dsgn-tracktype1)), and a vendor when one platform reads it
([ADR-DSGN-TRACKTYPE#3](#rule-adr-dsgn-tracktype3)). A deployable track owns deployable-units and a holder track is a module of one vendor,
one tool or one purpose ([ADR-DSGN-TRACKTYPE#2](#rule-adr-dsgn-tracktype2)). The `tracks` map and `track-types.yml` are the only
declarations ([ADR-DSGN-TRACKTYPE#4](#rule-adr-dsgn-tracktype4)); the longest place resolves each file
([ADR-DSGN-TRACKTYPE#5](#rule-adr-dsgn-tracktype5)); the head says `track`, `tracktype` and `vendor`
([ADR-DSGN-TRACKTYPE#6](#rule-adr-dsgn-tracktype6)).

### How this is enforced

- **The config types** (`VariantsConfig`, `TrackTypesConfig`) fail the load on a track without a place or a type, a place two tracks share,
  a place under `out/`, an unknown key, a role outside the closed set, and a track type that admits a module type twice.
- **`Test-TrackDeclaration`** reads the tracks, the track types, the vendors and the module types together and fails a track whose type or
  vendor is not declared, and a track type that admits a module type no registry declares.
- **`Test-WorldMap`** fails a tracked file in no track and a stack violation ([ADR-DSGN-TRACK#11](tracks.md#rule-adr-dsgn-track11)); its
  rows are the tracks.
- **`Test-FileMeta`** compares `track`, `tracktype` and `vendor` in each head with the declaration.

## Consequences

- "Is this track a deliverable or a holder?" is a declared fact, so a gate treats a holder's files without aspects, globsets or a
  deployable-unit and does not guess.
- A vendor change (the GitHub workflows) is a change to one track and never re-keys the ADO pipelines.
- Code the repository writes and code it vendors are counted, checked and shipped apart.
- The cost is one more declaration per track, and a longest-place rule that a reviewer has to read when a place is narrowed.
