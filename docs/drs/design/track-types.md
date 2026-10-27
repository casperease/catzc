# Design: Track types — what a track owns, and where tracks are declared

## Rules: DDR-TRACKTYPE

### Rule DDR-TRACKTYPE-CLOSEDSETOFTYPES

A **track type** is the sort of cluster a track is, and it is one of a closed set, each with a one-sentence definition: `modules`,
`infrastructure`, `pipelines`, `vendor-settings`, `vendored-code`, `contracts`, `documentation`, `unordered` and `output`. The `output`
track, `out/`, is ignored by git yet operated on like any other: the tools write their reports, renders and builds there and read them back,
and its build destination is none, so it ships nothing. Configuration is no track type: it is a file role (the `config` kind), static files
kept in the repository inside a module or inside a vendor-settings track, and it follows its owner. A track has exactly one type. A new
tech-stack that ships (a `services` or `frontend` track, [DDR-TRACK-ONETECHSTACK](tracks.md#rule-ddr-track-onetechstack)) adds its type to
the set in the same change that opens the track, never before it.

- [Track types](#track-types)

### Rule DDR-TRACKTYPE-ONEROLE

A track type has one **role**. A **deployable track** (`modules`, `infrastructure`, and the future `services` and `frontend`) _owns_
deployable-units: collections of the track's modules that the repository delivers through CI/CD
([DDR-TRACK-DEPLOYABLEUNIT](tracks.md#rule-ddr-track-deployableunit)). A **holder track** (every other type) _is_ a module more than it owns
modules: it holds one vendor's or one tool's files for this repository, or one purpose's, and it ships nothing of its own. The role is
declared on the track type, never on the track.

- [Deployable and holder tracks](#deployable-and-holder-tracks)

### Rule DDR-TRACKTYPE-OPTIONALVENDOR

A track may name the **vendor** whose tool it holds: a tool, core, plugin or external dependency that the repository vendors
([DDR-VENDOR-ISVENDORED](vendoring.md#rule-ddr-vendor-isvendored)), from a closed set declared once with a definition each (a new vendor is
an entry). A vendor is named by its tool, a short form is fine, and it is never mixed into another vendor's track. One vendor may have
several tracks, and the tracks of one type but of two vendors stay two: the ado pipelines and the GitHub workflows are two tracks of one
type, `pipelines`, because each is bound to a different pipeline model. The settings of each tool the repository configures are one
`vendor-settings` track per vendor, and every `.vendor` folder and every vendor's settings sit under the one vendor umbrella
([DDR-VENDOR-ONEUMBRELLA](vendoring.md#rule-ddr-vendor-oneumbrella)). `vendor` is the tool the repository vendors, never the platform that
reads a file. The name of a vendor's track follows [DDR-TRACKTYPE-NAMEFROMMEMBERS](#rule-ddr-tracktype-namefrommembers).

- [Vendors](#vendors)

### Rule DDR-TRACKTYPE-NAMEFROMMEMBERS

A track's **name** is its definitive name in `variants.yml`, in the repository's normal form for names: `snake` segments joined by `.`, one
segment per level, the minimal path. A vendor's track starts with the vendor, `vendor_<vendor>`, and takes one more segment, `.<part>`,
naming what its members hold whenever the vendor has more than one track or one kind of tool: `.vscode` is `vendor_vscode` and `.cspell` is
`vendor_cspell`; `.claude` is `vendor_ai.claude`, the AI vendor's Claude part; `.github`, `.gitignore` and git's other root dotfiles are
`vendor_git.root_configs`; the vendored code under a language's track is `modules` of that language, so `pwsh/.vendor` is
`vendor_pwsh.modules` and `bash/.vendor` is `vendor_bash.modules`; the type declarations under `.typescript` are `vendor_typescript.types`;
the Bicep infrastructure is `vendor_azure.bicep`; and a vendor's pipeline definitions are `vendor_<vendor>.pipelines`,
`vendor_ado.pipelines` and `vendor_github.pipelines`. A track with no vendor is named by the place it covers, without a leading dot: `pwsh`,
`docs`, `contracts`, `unordered`. The name is computed from the members, so two tracks never share one, and a track whose members move is
renamed with every caller in the same change.

- [Vendors](#vendors)

### Rule DDR-TRACKTYPE-TYPESDECLAREDONCE

A track is **declared once**, in the `tracks` map of `variants.yml` (`Catzc.Base.Variants`, the repo-wide variants), as its name, its type,
its places (the paths it covers), its vendor when it has one ([DDR-TRACKTYPE-OPTIONALVENDOR](#rule-ddr-tracktype-optionalvendor)) and its
file languages ([DDR-TRACK-FILELANGUAGE](tracks.md#rule-ddr-track-filelanguage)). The track types are declared once, in `track-types.yml` of
the same module, each with its definition, its role ([DDR-TRACKTYPE-ONEROLE](#rule-ddr-tracktype-onerole)) and the module types it admits
([DDR-MODTYPE-TRACKTYPEADMITS](module-types.md#rule-ddr-modtype-tracktypeadmits)). No other file lists a track, a track type or a place: a
command, a gate and a globset read them through `Get-Track`.

- [Where the declarations live](#where-the-declarations-live)

### Rule DDR-TRACKTYPE-LONGESTPLACEWINS

A file belongs to the track with the **longest member** that contains it, so a narrower member wins over a wider one: a file under
`.github/workflows` is in the `vendor_github.pipelines` track, and the rest of `.github` is in the `vendor_git.root_configs` track. Two
members of different tracks that are equally long and both contain a file, a member that no file resolves to, and a tracked file in no track
that is not a root file are load failures. The answer to "which track holds this file" is therefore one value, computed.

- [Where the declarations live](#where-the-declarations-live)

### Rule DDR-TRACKTYPE-FACTSFROMDECLARATION

A file's `track`, `tracktype` and, when the track has one, `vendor` are read from the declaration on demand, through `Get-Track`, never
guessed from a folder name and never read from a file's head, and a root file has none. No head shows `track`, `tracktype`, `vendor` or the
track's role, places or languages: a reader asks `Get-Track` for them.

- [Where the declarations live](#where-the-declarations-live)

### Rule DDR-TRACKTYPE-VENDOREDCODE

A track of **vendored code** holds code written by a third party that the repository does not author, such as `pwsh/.vendor` and
`bash/.vendor`. It is nested under another track's root and gets its files by the longest place
([DDR-TRACKTYPE-LONGESTPLACEWINS](#rule-ddr-tracktype-longestplacewins)), so the track beside it never holds them. Its files are never live
([DDR-TRACK-STACKVIOLATION](tracks.md#rule-ddr-track-stackviolation)).

- [Vendored code](#vendored-code)

## Context

The repository holds more than code to deploy. Its `pwsh` and `infrastructure` trees are collections of modules that CI/CD delivers; its
`.ado/pipelines` and `.github/workflows` trees are the repository's own pipeline definitions for two different platforms; its dot-folders
configure the tools that read them; its `.vendor` folders hold code written elsewhere. Calling all of these "root folders" hides the
difference that matters: which tracks produce a deliverable, and which only hold a vendor's configuration or a third party's code. A name
for the type of track, declared once, makes that difference a fact a gate can check.

### Track types

`modules` holds the modules of one language's track, PowerShell with the C# it hosts, Python, Go or Bash, each track with its own test
holder of black-box tests, and what ships of it is what `files.yml` packages; `infrastructure` holds Bicep templates and reusable Bicep
modules; `pipelines` holds pipeline definitions, Azure DevOps or GitHub Actions by vendor; `vendor-settings` holds the settings of one tool
the repository configures; `vendored-code` holds code written by a third party; `contracts` holds the repository's boundary contracts, in
both directions; `documentation` holds the decision records, references and guides; `unordered` is where imports land
([DDR-TRACK-UNORDEREDTRACK](tracks.md#rule-ddr-track-unorderedtrack)). Configuration is a file role, not a type: `configs/*.yml` belongs to
its module's track and `settings.json` to its vendor-settings track.

### Deployable and holder tracks

The line between deployable and holder follows the delivery model, not the folder. A deployable track has modules that are built, verified
and promoted as units, so it carries aspects ([DDR-ASPECT](module-aspects.md)), globsets and a pipeline per deployable-unit. A holder track
carries none of that: its files are read by a platform or a tool, and its only checks are that they are well-formed and in the right place.
A holder is therefore small, and a vendor change touches only its holder.

### Vendors

A vendor ([DDR-VENDOR](vendoring.md)) is a fact of the track, not of the folder name. Pipelines show why: the ADO and GitHub definitions are
the same sort of thing bound to two pipeline models, so they share a type and differ by vendor, where two types would make the sort of thing
look like two things. Settings show the other side: four tools with four sets of files are four tracks of one type, so a change to one
tool's settings never re-keys another's.

### Where the declarations live

A track and a track type are data, not code ([PDR-CONFIG](../principles/configure-not-program.md)): a new track is an entry, a new type is
an entry plus the handler its role needs, and neither is a branch in a command. The declaration sits with the variants because a track is a
repository-wide variant, and the types sit beside it so the closed set and the tracks are validated together at load by the config types.

### Vendored code

Code written by a third party has its own upstream and update path, and none of its files is the repository's to change in place. Giving it
a track of its own keeps the neighbouring track's checks, aspects and counts about code the repository writes, and the longest-place rule
gives it its files without a list of exclusions.

## Decision

Name the type of a track and declare it once. A track is a cluster of module contents
([DDR-TRACK-ISPLACEDCLUSTER](tracks.md#rule-ddr-track-isplacedcluster)) with one of a closed set of types
([DDR-TRACKTYPE-CLOSEDSETOFTYPES](#rule-ddr-tracktype-closedsetoftypes)), and a vendor when one platform reads it
([DDR-TRACKTYPE-OPTIONALVENDOR](#rule-ddr-tracktype-optionalvendor)). A deployable track owns deployable-units and a holder track is a
module of one vendor, one tool or one purpose ([DDR-TRACKTYPE-ONEROLE](#rule-ddr-tracktype-onerole)). The `tracks` map and `track-types.yml`
are the only declarations ([DDR-TRACKTYPE-TYPESDECLAREDONCE](#rule-ddr-tracktype-typesdeclaredonce)); the longest place resolves each file
([DDR-TRACKTYPE-LONGESTPLACEWINS](#rule-ddr-tracktype-longestplacewins)); a file's `track`, `tracktype` and `vendor` are asked of the
declaration and never shown in a head ([DDR-TRACKTYPE-FACTSFROMDECLARATION](#rule-ddr-tracktype-factsfromdeclaration)).

### How this is enforced

- **The config types** (`VariantsConfig`, `TrackTypesConfig`) fail the load on a track without a place or a type, a place two tracks share,
  a place under `out/`, an unknown key, a role outside the closed set, and a track type that admits a module type twice.
- **`Test-TrackDeclaration`** reads the tracks, the track types, the vendors and the module types together and fails a track whose type or
  vendor is not declared, and a track type that admits a module type no registry declares.
- **`Test-WorldMap`** fails a tracked file in no track and a stack violation
  ([DDR-TRACK-STACKVIOLATION](tracks.md#rule-ddr-track-stackviolation)); its rows are the tracks.
- **`Test-FileMeta`** fails a head that holds a key the head policy does not call for, `track`, `tracktype` and `vendor` among them.

## Consequences

- "Is this track a deliverable or a holder?" is a declared fact, so a gate treats a holder's files without aspects, globsets or a
  deployable-unit and does not guess.
- A vendor change (the GitHub workflows) is a change to one track and never re-keys the ADO pipelines.
- Code the repository writes and code it vendors are counted, checked and shipped apart.
- The cost is one more declaration per track, and a longest-place rule that a reviewer has to read when a place is narrowed.
