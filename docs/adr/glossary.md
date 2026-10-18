---
catzc:
  immutable:
    with_body_sha: "6bbc182f7e3c"
    with_inputs_sha: "9a84fd5ed4e34731f39573d33998343a219c9690d0ff167d61728c3022b5a853"
    repo_status: locked
    path: docs/adr/glossary.md
    role: glossary
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
    generator: pwsh/Catzc.Base.Docs/Build-Glossary.ps1
---

# docs/adr/glossary.md

Glossary: the controlled vocabulary

Every defined term of the repository, generated from the glossary sources (each module's `configs/glossary.yml`) by `Build-Glossary` — edit
a source, never this page. A term's meaning is fixed by the one ADR rule that defines it
([controlled-vocabulary](repository/controlled-vocabulary.md)); this page collects them, with how each differs from its neighbours and the
phrasings to avoid. `Test-Glossary` checks the sources.

## thesis

### adjacent store

The one legitimate second store — a repository or service, such as a GitOps repository, with its own history, driven one way from the
trunk's pipelines and never edited beside it.

- **Defined by:** [ADR-THES-ONETRUTH-REPOSITORYISCONFIGURATIONRECORD](thesis/one-source-of-truth.md#rule-adr-thes-onetruth-repositoryisconfigurationrecord)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [source of truth](#source-of-truth): The source of truth is the record everything is driven from; an adjacent store is a one-way
    projection of it, never a second record.

### pin

An explicit version, controlled by the consumer, of a dependency that crosses the repository boundary inward, stitched into an immutable
artifact at build time.

- **Defined by:** [ADR-THES-ONETRUTH-PRODUCTMONOREPOSITORY](thesis/one-source-of-truth.md#rule-adr-thes-onetruth-productmonorepository)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [provided contract](#provided-contract): A provided contract is the promise catzc keeps to a consumer; a pin is the consumer's explicit
    choice of the version that promise holds for.
  - [trunk](#trunk): Inside the trunk everything is at HEAD, with no version; a pin is the one form of synchronisation, at the repository
    boundary.

### product mono-repository

One repository that several teams contribute to for one product, bounded into tracks and deployable-units by path filters; catzc is one.

- **Defined by:** [ADR-THES-ONETRUTH-PRODUCTMONOREPOSITORY](thesis/one-source-of-truth.md#rule-adr-thes-onetruth-productmonorepository)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [trunk](#trunk): The trunk is the one mainline of a product mono-repository, where everything is at HEAD; the product mono-repository is
    the repository as a whole, with its tracks and deployable-units.

### query surface

The tooling's Get-* cmdlets, each of which also emits its answer as data (JSON), through which every question about the system's state is
answered.

- **Defined by:** [ADR-THES-ONETRUTH-TRUTHISQUERYABLE](thesis/one-source-of-truth.md#rule-adr-thes-onetruth-truthisqueryable)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`

### source of truth

The one store whose content decides what is true about the delivered system — for catzc, the repository, changed through one change process.

- **Defined by:** [ADR-THES-ONETRUTH-ONESTOREDECIDES](thesis/one-source-of-truth.md#rule-adr-thes-onetruth-onestoredecides)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [adjacent store](#adjacent-store): An adjacent store is a second store driven one way from the trunk's pipelines, a projection of the
    truth; the source of truth is the record it is driven from.
  - [source](#source): A source, always qualified, names where one thing comes from; the source of truth is the one store that decides what
    is true about the delivered system.

### trunk

The one mainline of a product mono-repository, where everything is at HEAD — no internal versions, and a shared change lands in one commit
with all its consumers.

- **Defined by:** [ADR-THES-ONETRUTH-PRODUCTMONOREPOSITORY](thesis/one-source-of-truth.md#rule-adr-thes-onetruth-productmonorepository)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [pin](#pin): A pin is an explicit version at the repository boundary; inside the trunk nothing is pinned, and everything is at HEAD.
  - [product mono-repository](#product-mono-repository): A product mono-repository is the repository as a whole, with its tracks and
    deployable-units; the trunk is its one mainline.

## principles

### cats

The product's name to a person — the executor outside pwsh, and the word in prose, docs and conversation.

- **Defined by:** [ADR-PRIN-CATS-CATSISPERSONNAME](principles/cats-and-catzc.md#rule-adr-prin-cats-catsispersonname)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [catzc](#catzc): catzc is the source-level name every module, namespace and path carries; cats is the friendly form a person reads and
    says.

### catzc

The source-level name of the system — the Catzc.* module prefix, the C# namespaces, the type-accelerator prefix, and the product token in
code and precise references.

- **Defined by:** [ADR-PRIN-CATS-CATZCISSOURCENAME](principles/cats-and-catzc.md#rule-adr-prin-cats-catzcissourcename)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [cats](#cats): cats is the same system named to a person; catzc is its name to code and to the facts the tooling writes.

| Avoid          | Say instead |
| -------------- | ----------- |
| `.cats folder` | .catzc/     |

## design

### cell

One row crossed with one column of a map — the world map's tracked files of one track in one file language, or the value-chain map's ADRs of
one row of the value-chain stack in one value-chain concern.

- **Defined by:** [ADR-DSGN-TRACK-CELL](design/tracks.md#rule-adr-dsgn-track-cell)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [lit cell](#lit-cell): A lit cell is a cell a highlight selects; a cell is any intersection, lit or not.
  - [stack violation](#stack-violation): A stack violation is a cell holding a live file outside its track's file languages; a cell is any
    intersection, allowed or not.
  - [value-chain map](#value-chain-map): The value-chain map is a whole grid; a cell is one intersection of it, holding the ADRs of one row
    in one value-chain concern.
  - [world map](#world-map): The world map is a whole grid; a cell is one intersection of it, holding the files of one track in one file
    language.

### deployable track

A track whose type owns deployable-units — collections of its modules that the repository delivers through CI/CD.

- **Defined by:** [ADR-DSGN-TRACKTYPE-ONEROLE](design/track-types.md#rule-adr-dsgn-tracktype-onerole)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [deployable-unit](#deployable-unit): A deployable-unit is what ships; a deployable track is the track that owns it.
  - [holder track](#holder-track): A holder track is itself a module and ships nothing of its own; a deployable track owns deployable-units.

### deployable-unit

What ships — a whole track or a reduced composition — bound one-to-one to its pipeline.

- **Defined by:** [ADR-DSGN-TRACK-DEPLOYABLEUNIT](design/tracks.md#rule-adr-dsgn-track-deployableunit)
- **Realized by:** config-key `pwsh/Catzc.Base.Globs/configs/globs.yml`
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [bundle](#bundle): A bundle is one build of the toolset; a deployable-unit is what ships from the mono-repository, whichever way it is
    built.
  - [deployable track](#deployable-track): A deployable track is the track that owns deployable-units; a deployable-unit is what ships.
  - [release candidate](#release-candidate): A release candidate is one commit's tagged, immutable build of a deployable-unit; a
    deployable-unit is the composition that ships, whichever commit is built.
  - [track](#track): A track is a cluster of module contents; a deployable-unit is what ships, composed from a whole track or a reduced part
    of one.

### file language

The language a tracked file is written in, named by its extension — PowerShell, C#, YAML, Bicep, Markdown, Python; a track's tech-stack is a
set of them.

- **Defined by:** [ADR-DSGN-TRACK-FILELANGUAGE](design/tracks.md#rule-adr-dsgn-track-filelanguage)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [contract language](#contract-language): The contract language is a notation inside one YAML file, the one a command contract is written
    in; a file language is the kind of text a whole file holds, named by its extension.
  - [file type](#file-type): A file type is the single extension of one file; a file language groups the extensions of one kind of text.
  - [implementation language](#implementation-language): An implementation language is a file language a command is written in; a file
    language is any language the registry names by extension.
  - [language zone](#language-zone): A language zone is one of the design, test, and live registers of identities; a file language is the
    kind of text one file holds.
  - [role](#role): A role is the part a file plays, what it is for; a file language is the sort of text it holds.
  - [track](#track): A track is a root folder and the concern it holds; a file language is the kind of text one file holds, wherever it
    lives.
  - [unlisted file](#unlisted-file): An unlisted file is a tracked file no file language names — no extension, or one no entry lists; a file
    language is a registered kind of text, named by its extensions.

### holder track

A track that is itself a module more than it owns modules — one vendor's, one tool's or one purpose's files, shipping nothing of its own.

- **Defined by:** [ADR-DSGN-TRACKTYPE-ONEROLE](design/track-types.md#rule-adr-dsgn-tracktype-onerole)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [deployable track](#deployable-track): A deployable track owns deployable-units delivered through CI/CD; a holder track holds files a
    platform or tool reads.

### import

Bringing an outside repository into this one with its full history, at one landing address.

- **Defined by:** [ADR-DSGN-TRACK-UNORDEREDTRACK](design/tracks.md#rule-adr-dsgn-track-unorderedtrack)
- **Realized by:** function `Import-RepositoryWithHistory`
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [importer](#importer): The importer brings catzc's modules into a session; an import brings an outside repository's files and history
    into this repository.

### landing address

The folder `.unordered/<name>` an import lands at, named by a short kebab word unique among the addresses.

- **Defined by:** [ADR-DSGN-TRACK-UNORDEREDTRACK](design/tracks.md#rule-adr-dsgn-track-unorderedtrack)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [landing zone](#landing-zone): A landing zone is the Azure network and guardrails a workload lands in; a landing address is the folder
    an import lands at.

### lit cell

A cell a highlight selects — on the world map the cells of the files an ADR code or a file set names, on the value-chain map the cells an
ADR sits in.

- **Defined by:** [ADR-DSGN-TRACK-LITCELL](design/tracks.md#rule-adr-dsgn-track-litcell)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [cell](#cell): A cell is any intersection of a map; a lit cell is one a highlight selects.
  - [stack violation](#stack-violation): A stack violation is a finding about a cell's files; a lit cell is a selection, made by a
    highlight, that never judges the cell.

### module

A named unit placed in a track — a folder or one file, found by where its files stand — resolved through its track.

- **Defined by:** [ADR-DSGN-MODTYPE-MODULEISPLACEDUNIT](design/module-types.md#rule-adr-dsgn-modtype-moduleisplacedunit)
- **Realized by:** type `Catzc.Base.Modules.Module`
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [module type](#module-type): A module type is the sort of module found at a place; a module is one unit of that sort.
  - [track](#track): A track is the cluster of module contents and the concern it holds; a module is one named unit placed in it.

### module type

The sort of module, named by the module-types registry, which says where modules of each type are found and how a path in that place names
its module.

- **Defined by:** [ADR-DSGN-MODTYPE-MODULETYPEISSORT](design/module-types.md#rule-adr-dsgn-modtype-moduletypeissort)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [layout](#layout): A layout says what a module's own folders hold; a module type says where modules of a sort are found.
  - [module](#module): A module is one named unit placed in a track; a module type is the sort of module found at a place, one of a closed
    set.
  - [track](#track): A track is the cluster of module contents and the concern it holds; a module type is the sort of module found at a
    place inside or across tracks.
  - [track type](#track-type): A track type is the sort of cluster a track is; a module type is the sort of module placed in it.

### occupant

The one commit an always-on environment holds, deployed there as its release candidate — named by its environment.

- **Defined by:** [ADR-DSGN-LIFE-ONECOMMITPERENVIRONMENT](design/commit-lifecycle.md#rule-adr-dsgn-life-onecommitperenvironment)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [release candidate](#release-candidate): A release candidate is the artifact, the same bytes wherever it is deployed; an occupant is the
    commit one environment holds.

| Avoid               | Say instead                           |
| ------------------- | ------------------------------------- |
| `current occupant`  | occupant (the <environment> occupant) |
| `current occupants` | occupants                             |
| `resident commit`   | occupant                              |

### place

A path a track declares it covers — a root folder, a path inside one, or a tool's root folder; the longest place that contains a file names
its track.

- **Defined by:** [ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER](design/tracks.md#rule-adr-dsgn-track-trackisplacedcluster)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [track](#track): A track is the cluster of module contents; a place is one path the track covers.

### root file

A tracked file no track holds — at the repository root itself, or under out/ — the world map's own row.

- **Defined by:** [ADR-DSGN-TRACK-ROOTFILE](design/tracks.md#rule-adr-dsgn-track-rootfile)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [track](#track): A track is a root folder and every file under it; a root file is a tracked file outside every track.
  - [unlisted file](#unlisted-file): An unlisted file is a tracked file outside every file language, whatever its track; a root file is one
    outside every track, whatever its file language.

### run mode

How the toolset is loaded, source mode from a repository root or build mode from a built package; exactly two exist.

- **Defined by:** [ADR-DSGN-RUNMODE-TWORUNMODES](design/run-modes.md#rule-adr-dsgn-runmode-tworunmodes)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [importer](#importer): The importer decides which modules, languages and engines a session loads; a run mode says where it reads the
    modules from.

### sorting

Moving a file from its landing address to its module or track with `git mv`, so its history follows.

- **Defined by:** [ADR-DSGN-TRACK-UNORDEREDTRACK](design/tracks.md#rule-adr-dsgn-track-unorderedtrack)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`

### stack violation

A world-map cell holding a live file whose file language its track does not declare — the second tech-stack ADR-DSGN-TRACK-ONETECHSTACK
forbids.

- **Defined by:** [ADR-DSGN-TRACK-STACKVIOLATION](design/tracks.md#rule-adr-dsgn-track-stackviolation)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [cell](#cell): A cell is any intersection of the world map; a stack violation is a cell that breaks its track's tech-stack.
  - [lit cell](#lit-cell): A lit cell is selected by a highlight and says nothing about the stack; a stack violation is a finding, marked
    whatever the highlight.
  - [value-chain stack](#value-chain-stack): The value-chain stack orders decisions, not files; a stack violation is a world-map cell
    outside its track's tech-stack.

### staging slot

System.Collections.Specialized.OrderedDictionary

- **Defined by:** [ADR-DSGN-LIFE-ONECOMMITPERENVIRONMENT](design/commit-lifecycle.md#rule-adr-dsgn-life-onecommitperenvironment)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`

### track

A named, on-disk cluster of module contents — the tracked files of one concern, selected by the places the track declares, and of one track
type.

- **Defined by:** [ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER](design/tracks.md#rule-adr-dsgn-track-trackisplacedcluster)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [deployable-unit](#deployable-unit): A deployable-unit is what ships, composed from a whole track or a reduced part of one; a track is
    the cluster of module contents itself.
  - [file language](#file-language): A file language is the kind of text a file holds, named by its extension; a track is the cluster the
    file lives in, and its tech-stack is a set of file languages.
  - [module](#module): A module is one named unit placed in a track; a track is the cluster of module contents and the concern it holds.
  - [module type](#module-type): A module type is the sort of module found at a place; a track is a cluster of places and the concern it
    holds.
  - [place](#place): A place is one path a track covers; a track is the cluster of module contents, whatever places select it.
  - [role](#role): A role is the part a file plays, wherever it lives; a track is the cluster the file lives in.
  - [root file](#root-file): A root file is a tracked file no track holds, at the repository root or under out/; a track is a cluster of
    places and every file under them.
  - [track type](#track-type): A track type is the sort of cluster a track is, one of a closed set; a track is the named cluster itself.
  - [value-chain concern](#value-chain-concern): A value-chain concern is where along delivery a decision acts; a track is a concern of the
    repository, the cluster where files live.
  - [verification track](#verification-track): A verification track is one type of track — test-only, shipping nothing; a track is any
    cluster of module contents.

### track type

The sort of cluster a track is, one of a closed set — modules, infrastructure, pipelines, vendor-settings, vendored-code, contracts,
documentation, verification, or unordered.

- **Defined by:** [ADR-DSGN-TRACKTYPE-CLOSEDSETOFTYPES](design/track-types.md#rule-adr-dsgn-tracktype-closedsetoftypes)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [module type](#module-type): A module type is the sort of module placed in a track; a track type is the sort of track, and admits module
    types.
  - [role](#role): A role is the part a file plays; a track type is the sort of cluster the file lives in.
  - [track](#track): A track is the named cluster of module contents; a track type is the sort it is, declared once for every track of that
    sort.

### unlisted file

A tracked file no file language names — no extension, or one no entry lists — the world map's own column.

- **Defined by:** [ADR-DSGN-TRACK-UNLISTEDFILE](design/tracks.md#rule-adr-dsgn-track-unlistedfile)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [file language](#file-language): A file language is a registered kind of text, named by its extensions; an unlisted file is a tracked
    file whose extension none of them lists.
  - [root file](#root-file): A root file is a tracked file outside every track; an unlisted file is a tracked file outside every file
    language, whatever its track.

### unordered track

The track at `.unordered` where imports land; the unordered part of the repository is whatever is still under it, and nothing reads or falls
back to it.

- **Defined by:** [ADR-DSGN-TRACK-UNORDEREDTRACK](design/tracks.md#rule-adr-dsgn-track-unorderedtrack)
- **Realized by:** config-key `pwsh/Catzc.Base.Variants/configs/variants.yml`
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`

### value-chain concern

Where along delivery an ADR acts — automation, build, quality-control, release, deploy, or access — a default per ADR domain, an override
per ADR.

- **Defined by:** [ADR-DSGN-TRACK-VALUECHAINCONCERN](design/tracks.md#rule-adr-dsgn-track-valuechainconcern)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [track](#track): A track is a root concern, the root folder where files live; a value-chain concern is where along delivery a decision
    acts.
  - [value-chain stack](#value-chain-stack): The value-chain stack is the rows, how general a decision is; a value-chain concern is a
    column, where along delivery it acts.

### value-chain map

The ADRs drawn as the value-chain stack crossed with the value-chain concerns, computed from adrs.yml — where a decision sits in the value
chain.

- **Defined by:** [ADR-DSGN-TRACK-VALUECHAINMAP](design/tracks.md#rule-adr-dsgn-track-valuechainmap)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [cell](#cell): A cell is one intersection of the value-chain map, holding the ADRs of one row in one value-chain concern; the map is the
    grid.
  - [world map](#world-map): The world map crosses tracks with file languages and says where a decision's files sit; the value-chain map
    says where along delivery the decision acts.

### value-chain stack

The ordered rows a decision sits on, from the axioms down to the vendor — PRIN, DSGN, AUTO, PIPE, CLOUD; each ADR domain declares one.

- **Defined by:** [ADR-DSGN-TRACK-VALUECHAINSTACK](design/tracks.md#rule-adr-dsgn-track-valuechainstack)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [stack violation](#stack-violation): A stack violation is a world-map cell outside its track's tech-stack, a set of file languages; the
    value-chain stack orders decisions, not files.
  - [value-chain concern](#value-chain-concern): A value-chain concern is a column, where along delivery an ADR acts; the value-chain stack
    is the rows, how general the decision is.

### vendor

The platform or tool that reads a track's files, from a closed set declared once — never the third party that wrote them.

- **Defined by:** [ADR-DSGN-TRACKTYPE-OPTIONALVENDOR](design/track-types.md#rule-adr-dsgn-tracktype-optionalvendor)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [vendored code](#vendored-code): Vendored code is written by a third party and the repository does not author it; a vendor is the
    platform that reads a track's files.

### vendored code

Code written by a third party that the repository does not author, held in a track of its own nested under another track's root.

- **Defined by:** [ADR-DSGN-TRACKTYPE-VENDOREDCODE](design/track-types.md#rule-adr-dsgn-tracktype-vendoredcode)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [vendor](#vendor): A vendor is the platform that reads a track's files; vendored code is code written by a third party.

### verification track

A test-only track — it verifies the core from outside, ships nothing, and is out of every bundle by construction; go is the first.

- **Defined by:** [ADR-DSGN-TRACK-ONETRACKTYPE](design/tracks.md#rule-adr-dsgn-track-onetracktype)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Languages/configs/glossary.yml`
- **Kind of:** [track](#track)
- **Contrasts:**
  - [track](#track): A track is any root concern; a verification track is the test-only class that ships nothing.

### world map

The repository drawn as tracks crossed with file languages, plus a row for the root files and a column for the unlisted files — every
tracked file in exactly one cell.

- **Defined by:** [ADR-DSGN-TRACK-WORLDMAP](design/tracks.md#rule-adr-dsgn-track-worldmap)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [cell](#cell): A cell is one row crossed with one column; the world map is the whole grid of them, computed from the registries and the
    git index.
  - [value-chain map](#value-chain-map): The value-chain map says where along delivery a decision acts; the world map crosses tracks with
    file languages and says where its files sit.

## flow

### gate

A check whose verdict decides whether work may proceed — automated (a quality gate, the CI gate) or human (RC, RBC).

- **Defined by:** [ADR-FLOW-CD-GATEDEFINED](flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd-gatedefined)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Forms:** `quality gate`, `CI gate`, `AT gate`, `RC gate`, `RBC gate`, `BVT gate`, `release gate`, `manual gate`, `PR gate`,
  `merge gate`, `commit gate`, `approval gate`, `production gate`, `push gate`, and the bare `gate`
- **Contrasts:**
  - [quality gate](#quality-gate): A quality gate is one automated check of the repository; a gate is any decision point, human or
    automated.

### release candidate

The immutable, tagged artifact a CI component builds from one commit — versioned, never rebuilt, promotable toward production.

- **Defined by:** [ADR-FLOW-CD-RELEASECANDIDATE](flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd-releasecandidate)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [deployable-unit](#deployable-unit): A deployable-unit is the composition that ships, whichever commit is built; a release candidate is
    one commit's tagged, immutable build of it.
  - [occupant](#occupant): An occupant is the commit an environment holds; a release candidate is the artifact built from it, the same bytes
    wherever it is deployed.
  - [published artifact](#published-artifact): A published artifact is any file handed across a stage boundary; a release candidate is the
    tagged build that gets promoted.
  - [test run](#test-run): A test run executes tests; a release candidate is the artifact a release-candidate test run verifies.
  - [test suite](#test-suite): A test suite is the declared selection of tests that verifies a change; a release candidate is the artifact
    under test.

| Avoid                     | Say instead                |
| ------------------------- | -------------------------- |
| `release-candidate suite` | release-candidate test run |

## automation

### all tests

Every test in the repository — every test file of every module, at every tier and category; what a test run selects at its defaults.

- **Defined by:** [ADR-AUTO-TEST-ALLTESTS](automation/test-automation.md#rule-adr-auto-test-alltests)
- **Realized by:** function `Test-Automation`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [test run](#test-run): A test run executes one selection of tests, possibly all; all tests is every test in the repository, at rest.
  - [test suite](#test-suite): A test suite is a named selection, usually a few modules up to a tier; all tests is every test there is.

| Avoid               | Say instead |
| ------------------- | ----------- |
| `the test suite`    | all tests   |
| `pester suite`      | all tests   |
| `pester test suite` | all tests   |
| `full suite`        | all tests   |

### auto

System.Collections.Specialized.OrderedDictionary

- **Defined by:** [ADR-AUTO-ENGINE-AUTONAMESNOENGINE](automation/execution-engines.md#rule-adr-auto-engine-autonamesnoengine)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Engines/configs/glossary.yml`
- **Contrasts:**
  - [execution engine](#execution-engine): An execution engine is one of pwsh, bash and zsh; auto is a value that leaves the choice among
    them open.

### automation

The abstract, the commands and behaviours the repository offers and the doctrine that governs them, independent of language, shell and
folder; the ADR domain, the value-chain row and the concern carry the name.

- **Defined by:** [ADR-AUTO-LAYERS-AUTOMATIONISABSTRACT](automation/layers.md#rule-adr-auto-layers-automationisabstract)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [importer](#importer): The importer brings a mix of languages, engines and modules into a session; automation is what the loaded modules
    offer.

| Avoid                   | Say instead                                             |
| ----------------------- | ------------------------------------------------------- |
| `automation folder`     | the pwsh track folder (pwsh/)                           |
| `automation track`      | pwsh track                                              |
| `automation modules`    | pwsh modules / catzc modules                            |
| `automation layer`      | automation (the abstract) / the pwsh modules (the code) |
| `powershell automation` | pwsh modules / PowerShell code                          |

### bash test folder

The folder `<root>/tests/<module>/` under the Bash root — one per catzc module, named for it in kebab case, holding its black-box `.bats`
tests, which call catzc through `importer.sh` and `cats`.

- **Defined by:** [ADR-AUTO-BASH-ONEBASHROOT](automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-onebashroot)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Languages/configs/glossary.yml`

### build verification test

The BVT — the verification that precedes every promotion and every creation of release artifacts, and that the commit gate runs.

- **Defined by:** [ADR-AUTO-TEST-BUILDVERIFICATIONTEST](automation/test-automation.md#rule-adr-auto-test-buildverificationtest)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [quality gate](#quality-gate): A quality gate is one check inside the BVT; the BVT is the verification that runs them together, before a
    promotion and in the commit gate.

### bundle

The toolset's build, one installable, versioned Catzc package of one named bundle, built from a profile of the exporter registry.

- **Defined by:** [ADR-AUTO-BUNDLE-BUNDLEISBUILD](automation/platform-bundle.md#rule-adr-auto-bundle-bundleisbuild)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [deployable-unit](#deployable-unit): A deployable-unit is what ships from the mono-repository, composed from a whole track or part of
    one; a bundle is one build of the toolset.

### category

A test's kind, logic or integrity — one mandatory tag saying whether it runs on fixtures or reads the shipped assets.

- **Defined by:** [ADR-AUTO-TEST-ONECATEGORY](automation/test-automation.md#rule-adr-auto-test-onecategory)
- **Realized by:** tag `logic|integrity`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [tier](#tier): A tier says what a test may touch and when it runs; a category says what it reads (logic or integrity).

| Avoid             | Say instead         |
| ----------------- | ------------------- |
| `integrity suite` | the integrity tests |

### command

One public function of the module system, the unit a contract describes, written in one implementation language.

- **Defined by:** [ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION](automation/layers.md#rule-adr-auto-layers-commandispublicfunction)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [command contract](#command-contract): A command contract is the asset that states a command's call interface at the boundary; the
    command is the function that implements it.

### config fragment

A file in an overlay that states only the keys of one config that differ, merged onto the bundled config before its type validates the
result.

- **Defined by:** [ADR-AUTO-OVERLAY-CONFIGFRAGMENT](automation/consumer-overlay.md#rule-adr-auto-overlay-configfragment)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Config/configs/glossary.yml`
- **Contrasts:**
  - [posture](#posture): A posture is what one config key does when no file states it; a config fragment is a file that changes a few keys
    of a shipped config.

### engine start environment

The CATZC_ENGINE variables a test runner sets so a black-box test starts the engine from them and never from a hardcoded command, the
engine's name, its executable, its importer entry and its start arguments.

- **Defined by:** [ADR-AUTO-ENGINE-STARTENVIRONMENT](automation/execution-engines.md#rule-adr-auto-engine-startenvironment)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Engines/configs/glossary.yml`

| Avoid                | Say instead              |
| -------------------- | ------------------------ |
| `black-box contract` | engine start environment |

### execution engine

System.Collections.Specialized.OrderedDictionary

- **Defined by:** [ADR-AUTO-ENGINE-THREEENGINES](automation/execution-engines.md#rule-adr-auto-engine-threeengines)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Engines/configs/glossary.yml`
- **Contrasts:**
  - [auto](#auto): auto is a value that leaves the engine open; an execution engine is the pwsh, bash or zsh it resolves to.
  - [posix engine](#posix-engine): A POSIX engine is an execution engine whose importer entry is importer.sh; an execution engine is any one
    of them, pwsh included.
  - [pwsh](#pwsh): pwsh is one of the three execution engines and the name the PowerShell track takes from it; an execution engine is any of
    the three.

### go test module

The folder `<root>/tests/<module>/` under the Go root — one Go module per catzc module, named for it in kebab case, holding its black-box Go
tests.

- **Defined by:** [ADR-AUTO-GO-ONEGOROOT](automation/go/go-test-artifacts.md#rule-adr-auto-go-onegoroot)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Languages/configs/glossary.yml`

### implementation language

The file language a command's source is written in, one whose languages.yml entry sets executable, which are PowerShell with its hosted C#,
Bash, Python and Go.

- **Defined by:** [ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION](automation/layers.md#rule-adr-auto-layers-commandispublicfunction)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [contract language](#contract-language): The contract language is the notation a command's call interface is stated in; an
    implementation language is the file language the command's source is written in.
  - [file language](#file-language): A file language is any language the registry names by extension; an implementation language is one a
    command is written in.

| Avoid                 | Say instead             |
| --------------------- | ----------------------- |
| `automation language` | implementation language |

### importer

The one way catzc enters a session, one entry per execution engine at the repository root, which decides the mix of languages, engines and
modules the session loads.

- **Defined by:** [ADR-AUTO-IMPORTER-ONEENTRY](automation/importer.md#rule-adr-auto-importer-oneentry)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [automation](#automation): Automation is what the loaded modules offer; the importer is what brings a mix of languages, engines and
    modules into a session.
  - [import](#import): An import brings an outside repository's files and history into this repository; the importer brings catzc's modules
    into a session.
  - [run mode](#run-mode): A run mode says where the importer reads the modules from; the importer decides which modules, languages and
    engines load.

### layout

The one table of folders inside a module and what each holds, declared once under each file language and read by every command that reads a
module's folders.

- **Defined by:** [ADR-AUTO-MODULE-EXISTSBYLAYOUT](automation/module-model.md#rule-adr-auto-module-existsbylayout)
- **Realized by:** config-key `pwsh/Catzc.Base.Languages/configs/languages.yml`
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [module type](#module-type): A module type says where modules of a sort are found; a layout says what a module's own folders hold.

### materialization

When a knowledge resource comes into being and how long it holds, on-demand (made when asked, held for the call or the session) or commit
(made at commit, keyed by the scoped sha of its inputs, never changing).

- **Defined by:** [ADR-AUTO-MATERIAL-MATERIALIZATION](automation/materialization.md#rule-adr-auto-material-materialization)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [meta head](#meta-head): A meta head is the leading comment that holds a file's facts; materialization is the property of a resource
    that a generated file's body_sha makes visible there.

| Avoid               | Say instead       |
| ------------------- | ----------------- |
| `cached at commit`  | a commit resource |
| `materialized view` | a commit resource |

### phase

A test run's scheduling stage — parallel and greedy files share one pool, serial runs last — chosen per file by the serial/greedy tags.

- **Defined by:** [ADR-AUTO-TEST-ONESCHEDULINGPOOL](automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)
- **Realized by:** tag `serial|greedy`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Forms:** `parallel phase`, `serial phase`, `greedy phase`, `worker phase`, `execution phase`, `run phase`, `test phase`, and the bare
  `phase`
- **Contrasts:**
  - [tier](#tier): A tier is what a test may touch; a phase is when its file runs within a run (parallel, greedy, serial).

### posix engine

System.Collections.Specialized.OrderedDictionary

- **Defined by:** [ADR-AUTO-ENGINE-IMPORTERENTRY](automation/execution-engines.md#rule-adr-auto-engine-importerentry)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Engines/configs/glossary.yml`
- **Contrasts:**
  - [execution engine](#execution-engine): An execution engine is any one of the shells the code runs under; the POSIX engines are those of
    them that load importer.sh.

### posture

What a config key does when its file states nothing, one of three, defaulted to the type's constant, empty and still valid, or required, so
the type's constructor throws naming the key and where to add it.

- **Defined by:** [ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Config/configs/glossary.yml`
- **Contrasts:**
  - [config fragment](#config-fragment): A config fragment is a file that changes a few keys of a shipped config; a posture is what one key
    does when no file states it.

### published artifact

A file one stage produces and a later stage downloads and consumes — carried by ArtifactRef, anchored on its artifact root.

- **Defined by:** [ADR-AUTO-PATH-PUBLISHEDARTIFACT](automation/path-representation.md#rule-adr-auto-path-publishedartifact)
- **Realized by:** type `Catzc.Base.Objects.ArtifactRef`
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [contract asset](#contract-asset): A contract asset is a checked-in file that states what the repository boundary requires, frozen with
    its unit's release; a published artifact is a file one stage produces and a later stage consumes within a run.
  - [release candidate](#release-candidate): A release candidate is the tagged build that gets promoted; a published artifact is any file
    handed across a stage boundary.

### pwsh

The name of the PowerShell track and of the engine that runs it; the PowerShell product itself is called PowerShell in prose.

- **Defined by:** [ADR-AUTO-LAYERS-TOOLSRUNTHROUGHENGINE](automation/layers.md#rule-adr-auto-layers-toolsrunthroughengine)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [execution engine](#execution-engine): pwsh is one of the three execution engines, and the name the PowerShell track takes from it.

### python test folder

The folder `<root>/tests/<module>/` under the Python root — one per catzc module, named for it in kebab case, holding its black-box Python
tests; each is a member of the one generated uv workspace.

- **Defined by:** [ADR-AUTO-PY-ONEPYTHONROOT](automation/python/python-test-artifacts.md#rule-adr-auto-py-onepythonroot)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Languages/configs/glossary.yml`

### quality gate

A gate checking one property of the whole repository automatically — one Test-<subject> function that reports through
Write-QualityGateReport and throws once with every issue.

- **Defined by:** [ADR-AUTO-TEST-QUALITYGATE](automation/test-automation.md#rule-adr-auto-test-qualitygate)
- **Realized by:** function `Write-QualityGateReport`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Kind of:** [gate](#gate)
- **Contrasts:**
  - [build verification test](#build-verification-test): The BVT is the verification that runs every quality gate together; a quality gate
    is one check inside it.
  - [gate](#gate): A gate is any decision point, human or automated; a quality gate is one automated check of the repository.

| Avoid            | Say instead                                     |
| ---------------- | ----------------------------------------------- |
| `analyzer suite` | the analyzer quality gate (Test-ScriptAnalyzer) |

### test

The smallest unit of verification that passes or fails on its own — counted by every report row, rule citation, skip, and timing; in pwsh
one Pester It.

- **Defined by:** [ADR-AUTO-TEST-TEST](automation/test-automation.md#rule-adr-auto-test-test)
- **Realized by:** function `It`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Part of:** [test block](#test-block)
- **Contrasts:**
  - [test block](#test-block): A test block groups tests and carries their shared tags and setup; a test is one It that passes or fails.

### test file

One file of tests that discovery maps to one catzc module — the unit a test run schedules, never split; in pwsh a Verb-Noun.Tests.ps1 under
tests/.

- **Defined by:** [ADR-AUTO-TEST-TESTFILE](automation/test-automation.md#rule-adr-auto-test-testfile)
- **Realized by:** file-pattern `pwsh/*/tests/**/*.Tests.ps1`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [test block](#test-block): A test block is a Describe or Context inside a test file; a test file is the file that holds them.

| Avoid                 | Say instead             |
| --------------------- | ----------------------- |
| `cross-cutting suite` | cross-cutting test file |

### test run

One invocation of Test-Automation, Test-CatzcBuild, or Invoke-TestFile over a selection of test files, in one location, with one report.

- **Defined by:** [ADR-AUTO-TEST-TESTRUN](automation/test-automation.md#rule-adr-auto-test-testrun)
- **Realized by:** artifact `out/test-*/*/run.json`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [all tests](#all-tests): All tests is every test in the repository, at rest; a test run executes one selection of them, possibly all.
  - [release candidate](#release-candidate): A release candidate is the artifact a release-candidate test run verifies; a test run executes
    tests.
  - [test suite](#test-suite): A test suite is a declared selection at rest; a test run executes a selection, a test suite or an ad-hoc one.

| Avoid          | Say instead                                      |
| -------------- | ------------------------------------------------ |
| `source suite` | source run                                       |
| `build suite`  | build run                                        |
| `build suites` | build runs                                       |
| `both suites`  | both runs (the source run and the build run)     |
| `two suites`   | two test runs (the source run and the build run) |

### test suite

A named, declared selection of tests that runs as one unit — a globset's verify scope in globs.yml (modules up to a tier), run with
Test-Automation -Suite.

- **Defined by:** [ADR-AUTO-TEST-TESTSUITE](automation/test-automation.md#rule-adr-auto-test-testsuite)
- **Realized by:** config-key `pwsh/Catzc.Base.Globs/configs/globs.yml`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [all tests](#all-tests): All tests is every test there is; a test suite is a named selection, usually a few modules up to a tier.
  - [release candidate](#release-candidate): A release candidate is the artifact under test; a test suite is the declared selection of tests
    that verifies a change.
  - [test run](#test-run): A test run executes a selection, a test suite or an ad-hoc one; a test suite is the declared selection at rest.
  - [tier](#tier): A tier is one level a single test carries; a test suite selects whole modules up to a top tier.

### testing in production

The L4 tier — tests of the released system itself, after final approval, that observe it and create nothing of their own.

- **Defined by:** [ADR-AUTO-TEST-TESTINGINPRODUCTION](automation/test-automation.md#rule-adr-auto-test-testinginproduction)
- **Realized by:** tag `L4`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [vertical test](#vertical-test): A vertical test crosses the local-tool or outside-state ring around the code; testing in production
    checks the released system.

### tier

A test's level, L0 to L4 — one mandatory tag that sets what the test may touch and when it runs.

- **Defined by:** [ADR-AUTO-TEST-TWOMANDATORYTAGS](automation/test-automation.md#rule-adr-auto-test-twomandatorytags)
- **Realized by:** tag `L0|L1|L2|L3|L4`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [category](#category): A category says what a test reads (logic or integrity); a tier says what it may touch and when it runs.
  - [phase](#phase): A phase is when a test's file runs within a run (parallel, greedy, serial); a tier is what the test may touch.
  - [test suite](#test-suite): A test suite is a declared selection of modules up to a top tier; a tier is one level a single test carries.
  - [vertical test](#vertical-test): A vertical test is an L2 or L3 test that cuts from its ring through to the core; a tier names the ring,
    any test has one.

| Avoid           | Say instead                |
| --------------- | -------------------------- |
| `l2 suite`      | the L2 tests / the L2 tier |
| `l2 test suite` | the L2 tests / the L2 tier |
| `l3 suites`     | the L3 tests / the L3 tier |

### vertical test

An L2 or L3 test that cuts from an outer ring of the test onion (local tools; outside state) through to the core, the code alone.

- **Defined by:** [ADR-AUTO-TEST-ONIONOFRINGS](automation/test-automation.md#rule-adr-auto-test-onionofrings)
- **Realized by:** tag `L2|L3`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [testing in production](#testing-in-production): Testing in production checks the released system after final approval; a vertical test
    crosses a ring around the code.
  - [tier](#tier): A tier names a test's outermost ring and every test has one; a vertical test is an L2 or L3 test, one that crosses a
    ring.

## pwsh

### test block

A Describe or Context in a test file — a named group of tests whose tags and setup apply to everything inside it.

- **Defined by:** [ADR-PWSH-PESTER-TESTISIT](pwsh/pester-testing.md#rule-adr-pwsh-pester-testisit)
- **Realized by:** function `Describe|Context`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Part of:** [test file](#test-file)
- **Contrasts:**
  - [test](#test): A test is one It that passes or fails; a test block groups tests and carries their shared tags and setup.
  - [test file](#test-file): A test file is the *.Tests.ps1 file; a test block is a Describe or Context inside it.

## configuration

### config contribution

One config value, a key path and its value, that an author states in the config part of a tracked Markdown file's meta block and that the
config reader gathers into the config that opted in to it.

- **Defined by:** [ADR-CONF-MDCONTRIB-CONFIGCONTRIBUTION](configuration/markdown-config-contributions.md#rule-adr-conf-mdcontrib-configcontribution)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`

## azure

### break-glass login

The one SQL login beside a server's Entra ID admin group, its password a Key Vault reference to foundation's vault.

- **Defined by:** [ADR-AZ-LZ-SQLENTRAADMINS](azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`

### caf tags

The six tag keys every resource carries — workload, environment, owner, cost-center, criticality, data-classification; cost-center is
required by policy.

- **Defined by:** [ADR-AZ-CAF-NAME-DEFINETAGGINGREQUIREMENTS](azure/caf/naming-and-tagging.md#rule-adr-az-caf-name-definetaggingrequirements)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`

### cloud adoption framework

Microsoft's guidance for preparing an Azure estate; its landing-zone design principles and design areas are recorded as vendor
recommendation in docs/adr/azure/caf/, one rule per recommendation.

- **Defined by:** [ADR-AZ-LZ-LANDINGZONE](azure/landing-zones.md#rule-adr-az-lz-landingzone)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`
- **Contrasts:**
  - [well-architected framework](#well-architected-framework): The Cloud Adoption Framework shapes the landing zone; the Well-Architected
    Framework shapes the workload in it.

### environment class

Production or non-production — the split that policy enforcement, database SKUs, backups, and budgets are set by.

- **Defined by:** [ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`

### hub

The landing zone of a shared subscription — the network every spoke of its tier peers to, holding the private DNS zones.

- **Defined by:** [ADR-AZ-LZ-HUBANDSPOKE](azure/landing-zones.md#rule-adr-az-lz-hubandspoke)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`
- **Contrasts:**
  - [spoke](#spoke): A spoke is a customer subscription's landing zone, peered to its hub; a hub is a shared subscription's, listing its
    spokes.

### landing zone

The network, guardrails, and cost control a workload lands in — the CAF application landing zone, deployed once per subscription at
subscription scope by the discovery template.

- **Defined by:** [ADR-AZ-LZ-LANDINGZONE](azure/landing-zones.md#rule-adr-az-lz-landingzone)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`
- **Contrasts:**
  - [landing address](#landing-address): A landing address is the folder an import lands at under the unordered track; a landing zone is the
    Azure network and guardrails a workload lands in.

### management group

An Azure container above subscriptions for policy and access; this repository deploys no management group and nothing at that level.

- **Defined by:** [ADR-AZ-LZ-LANDINGZONE](azure/landing-zones.md#rule-adr-az-lz-landingzone)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`

### pillar

One of the Well-Architected Framework's five qualities — reliability, security, cost optimization, operational excellence, performance
efficiency — each one ADR in docs/adr/azure/waf/.

- **Defined by:** [ADR-AZ-LZ-EVERYPILLAR](azure/landing-zones.md#rule-adr-az-lz-everypillar)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`

### slot

A Bicep configuration slot — one config file of a template (`<env>[-<slot>].yml`), deploying one subscription's resource group.

- **Defined by:** [ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`
- **Forms:** `Bicep slot`, `base slot`, `configuration slot`, `root slot`, `template slot`, `indexed slot`, `special slot`, `optional slot`,
  `customer slot`, `platform slot`, `env slot`, `core slot`, `subfolder slot`, `target slot`, `region slot`, and the bare `slot`

### spoke

The landing zone of a customer subscription — peered to the hub of its tier, holding the subnet its workloads' private endpoints use.

- **Defined by:** [ADR-AZ-LZ-HUBANDSPOKE](azure/landing-zones.md#rule-adr-az-lz-hubandspoke)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`
- **Contrasts:**
  - [hub](#hub): A hub is a shared subscription's landing zone, listing its spokes; a spoke is a customer subscription's, peered to its hub.

### subscription vending

Onboarding a subscription by pull request — its azure.yml entry, its range in network.yml, and one config per template; the subscription
itself is created outside the repository.

- **Defined by:** [ADR-AZ-CAF-RESORG-SUBSCRIPTIONVENDINGPROCESS](azure/caf/resource-organization.md#rule-adr-az-caf-resorg-subscriptionvendingprocess)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`

### well-architected framework

Microsoft's checklist of a workload's quality in five pillars; each checklist item is a rule in docs/adr/azure/waf/, numbered as Microsoft
numbers it.

- **Defined by:** [ADR-AZ-LZ-EVERYPILLAR](azure/landing-zones.md#rule-adr-az-lz-everypillar)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`
- **Contrasts:**
  - [cloud adoption framework](#cloud-adoption-framework): The Well-Architected Framework shapes the workload; the Cloud Adoption Framework
    shapes the landing zone it lands in.

## repository

### capability

One `.claude/skills/<domain>-<job>/SKILL.md` file a robot preloads through its `skills` list — at most the roof's lines, with a model floor
declared once in its metadata.

- **Defined by:** [ADR-REPO-AGENTS-CAPABILITYFILE](repository/agent-definitions.md#rule-adr-repo-agents-capabilityfile)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`

### code link

An ADR citation in a code comment, written as a repository-rooted markdown link whose text is the citation code.

- **Defined by:** [ADR-REPO-LINK-KINDBYFILE](repository/markdown-links.md#rule-adr-repo-link-kindbyfile)
- **Realized by:** function `Format-Links`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [markdown link](#markdown-link): A markdown link lives in a .md file and is relative to it; a code link lives in a comment of a
    non-markdown file and is repository-rooted.

### command contract

A provided contract asset, <module>/<Verb-Noun>.command.yml in a unit's version folder, that states one command's call interface in the
contract language; a command is public exactly when one names it.

- **Defined by:** [ADR-REPO-CMDCONTRACT-COMMANDCONTRACT](repository/command-contracts.md#rule-adr-repo-cmdcontract-commandcontract)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [command](#command): A command is the function that implements the interface; a command contract is the asset that states it at the
    boundary.
  - [contract asset](#contract-asset): A contract asset is any file of the five kinds; a command contract is the kind that states a
    command's call interface and is compared with the command's source.

### comment page

The Markdown page under docs/references that holds a file's long comments verbatim, one numbered section per comment.

- **Defined by:** [ADR-REPO-COMMENTS-ONELINEOFINSIGHT](repository/comments-in-docs.md#rule-adr-repo-comments-onelineofinsight)
- **Realized by:** function `Export-Comments`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`

### contract

A binding interface at the repository boundary, held under contracts/ in either direction — provided or depended-on — and proven by its
owning module's tests.

- **Defined by:** [ADR-REPO-CONTRACT-BINDINGINTERFACE](repository/api-contracts.md#rule-adr-repo-contract-bindinginterface)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [contract asset](#contract-asset): A contract asset is one file in an owning module's folder of a unit's contracts/ version folder; a
    contract is the binding interface its assets state together.

### contract asset

One file in an owning module's folder of a unit's contracts/ version folder, whose path names the real file it constrains and whose name
picks its kind — a fragment, a schema, a sample payload, or a command contract.

- **Defined by:** [ADR-REPO-CONTRACT-CONTRACTASSET](repository/api-contracts.md#rule-adr-repo-contract-contractasset)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [command contract](#command-contract): A command contract is the one asset kind that states a command's call interface and is compared
    with the command's source; a contract asset is any file of the five kinds.
  - [contract](#contract): A contract is the binding interface at the repository boundary; a contract asset is one checked-in file that
    states part of it.
  - [published artifact](#published-artifact): A published artifact is a file one stage produces and a later stage consumes within a run; a
    contract asset is a checked-in file that states what the repository boundary requires, frozen with its unit's release.

### contract language

The notation a command contract is written in — YAML with one string per parameter (type, mandatory, default, pipeline) and an output type,
over a closed type set whose defaults are declared once on the ContractCommand type.

- **Defined by:** [ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE](repository/command-contracts.md#rule-adr-repo-cmdcontract-contractlanguage)
- **Realized by:** type `Catzc.Base.Contracts.ContractCommand`
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [file language](#file-language): A file language is the kind of text a file holds, named by its extension; the contract language is a
    notation inside one YAML file, not a file language of its own.
  - [implementation language](#implementation-language): An implementation language is the file language a command's source is written in;
    the contract language is the notation its call interface is stated in.

### deck file

The `deck.md` of a deck folder — the deck's title and its sections, beside the slide files it gathers.

- **Defined by:** [ADR-REPO-SLIDES-SLIDEFILE](repository/slides-as-markdown.md#rule-adr-repo-slides-slidefile)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Slides/configs/glossary.yml`
- **Contrasts:**
  - [slide file](#slide-file): A slide file is one slide of a deck; the deck file names the deck and its sections and holds no slide.

### depended-on contract

A contract an outside platform expects of our files and calls, such as GitHub reading a workflow file; it follows the platform, so a
platform change is a new draft.

- **Defined by:** [ADR-REPO-CONTRACT-BINDINGINTERFACE](repository/api-contracts.md#rule-adr-repo-contract-bindinginterface)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [provided contract](#provided-contract): A provided contract is a promise to an outside consumer, kept while the consumer pins that
    version of its unit; a depended-on contract records what a platform requires and follows the platform.

### domain

A group of ADRs — one docs/adr/ subfolder — that adrs.yml declares with its role and the domains it depends on.

- **Defined by:** [ADR-REPO-FOLDERS-DOCUMENTATIONMARKDOWNONLY](repository/conventional-folders.md#rule-adr-repo-folders-documentationmarkdownonly)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Forms:** `ADR domain`, `thesis domain`, `principles domain`, `process domain`, `design domain`, `flow domain`, `automation domain`,
  `pwsh domain`, `configuration domain`, `pipelines domain`, `github domain`, `azure domain`, `repository domain`, `research domain`,
  `axioms domain`, `architecture domain`, `implementation domain`, `optimisable domain`, `owning domain`, and the bare `domain`
- **Contrasts:**
  - [language zone](#language-zone): A language zone is one of the design, test, and live registers of identities; an ADR domain groups
    ADRs.

### domain rules

The repository's conventions and decision records — its ADRs and the rules they state.

- **Defined by:** [ADR-REPO-VOCAB-DOMAINRULES](repository/controlled-vocabulary.md#rule-adr-repo-vocab-domainrules)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`

| Avoid         | Say instead              |
| ------------- | ------------------------ |
| `house rules` | domain rules / ADR rules |

### edge

One named relation under the edges part of a meta block, from the file to a rule code, a file or a URL, such as defines, cites, links, page
or test, written on its source only.

- **Defined by:** [ADR-REPO-FILEMETA-FILEISNODE](repository/file-meta.md#rule-adr-repo-filemeta-fileisnode)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [place facts](#place-facts): An edge is a named relation leaving the file, read from its text; the place facts are properties of the
    file as a node, read from the repository's configuration.

### facet

One of several parallel views of, or checks on, the same thing, none above another — a build facet (types, load, parity, manifest) or a
module facet (disk, session).

- **Defined by:** [ADR-REPO-VOCAB-FAMILYFORMS](repository/controlled-vocabulary.md#rule-adr-repo-vocab-familyforms)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Forms:** `build facet`, `types facet`, `load facet`, `parity facet`, `manifest facet`, `module facet`, `disk facet`, `session facet`,
  `runtime facet`, and the bare `facet`, with its verb forms
- **Contrasts:**
  - [layer](#layer): A layer is one level of a stack, sitting on or containing the next; a facet is a parallel view of the same thing.

### field

One level-two heading of a slide file and the text under it, filled into the placeholder of the same name in the slide's pattern.

- **Defined by:** [ADR-REPO-SLIDES-SLIDEFILE](repository/slides-as-markdown.md#rule-adr-repo-slides-slidefile)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Slides/configs/glossary.yml`

| Avoid               | Say instead |
| ------------------- | ----------- |
| `slot (of a slide)` | field       |

### file type

The extension of a file's name, which tells the sorts of file inside one language apart, such as ps1 from psm1 and psd1.

- **Defined by:** [ADR-REPO-FILEMETA-ROLE](repository/file-meta.md#rule-adr-repo-filemeta-role)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [file language](#file-language): A file language groups the extensions of one kind of text; a file type is the single extension of one
    file.
  - [role](#role): A role is the part a file plays; a file type is how its name ends.
  - [subkind](#subkind): A subkind is a narrower role, whatever the name; a file type is how a file's name ends.

### imprint step

A step the file-language registry lists under imprint, global or for one language, which Format-Code runs after the formatter to write one
derived fact into the file.

- **Defined by:** [ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`

### inspiration

A sibling repository declared in inspiration.yml and read for ideas, never as a reference implementation.

- **Defined by:** [ADR-REPO-INSPIRE-DECLAREDINSPIRATION](repository/inspiration.md#rule-adr-repo-inspire-declaredinspiration)
- **Realized by:** type `Catzc.Tooling.Inspiration.InspirationEntry`
- **Source:** `pwsh/Catzc.Tooling.Inspiration/configs/glossary.yml`

| Avoid                | Say instead |
| -------------------- | ----------- |
| `inspiration source` | inspiration |

### language zone

One of the three registers — design, test, live — each with its own terminology and identities; a token belongs to exactly one.

- **Defined by:** [ADR-REPO-LANG-THREEREGISTERS](repository/domain-language-separation.md#rule-adr-repo-lang-threeregisters)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Forms:** `language zone`, `design zone`, `test zone`, `live zone`, `landing zone`, `dns zone`, `availability zone`, and the bare `zone`
- **Contrasts:**
  - [domain](#domain): An ADR domain groups ADRs in one docs/adr/ subfolder; a language zone is a register of identities.
  - [file language](#file-language): A file language is the kind of text one file holds, named by its extension; a language zone is a
    register of identities.

### layer

One stratum of a structure, always qualified — one of the five layers of the automation (automation, contract, language, engine, importer;
ADR-AUTO-LAYERS-REALISENEVERREDEFINE), or a globset layer (module, fileset).

- **Defined by:** [ADR-REPO-VOCAB-FAMILYFORMS](repository/controlled-vocabulary.md#rule-adr-repo-vocab-familyforms)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Forms:** `automation layer`, `contract layer`, `language layer`, `engine layer`, `importer layer`, `installer layer`, `config layer`,
  `configuration layer`, `Azure layer`, `tooling layer`, `YAML layer`, `module layer`, `template layer`, `templating layer`, `vendor layer`,
  `abstraction layer`, `analyzer layer`, `compatibility layer`, `mapping layer`, `serialization layer`, `base layer`, `design layer`,
  `spelling layer`, `Pester layer`, `pip layer`, `path layer`, `support layer`, `doctrine layer`, `globset layer`, `fileset layer`,
  `cross layer`, `ADR layer`, `AUTO layer`, `shaping layer`, and the bare `layer`, with its verb forms
- **Contrasts:**
  - [facet](#facet): A facet is one of several parallel views of, or checks on, the same thing; a layer is one level of a stack.

### markdown link

A link inside a rendered .md file, written relative to that file so it resolves the same on GitHub and in VS Code.

- **Defined by:** [ADR-REPO-LINK-KINDBYFILE](repository/markdown-links.md#rule-adr-repo-link-kindbyfile)
- **Realized by:** function `Test-Links`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [code link](#code-link): A code link lives in a comment of a non-markdown file and is repository-rooted; a markdown link lives in a .md
    file and is relative to it.

### meta block

The facts the tooling owns about one tracked file, written into the file's carrier, which is the reserved front-matter key catzc of a
Markdown file, at the top level or nested at the key path its carrier declares, or the meta head of a code file.

- **Defined by:** [ADR-REPO-FILEMETA-HEADPOLICY](repository/file-meta.md#rule-adr-repo-filemeta-headpolicy)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [meta head](#meta-head): The meta block is the facts in any file; the meta head is the form they take in a code file.
  - [meta kind](#meta-kind): The meta block is the block in one file; a meta kind is the registry entry that says what goes in that block
    across files.

### meta head

The leading comment of a code file, whose text is a front matter document with the catzc block, that holds the file's derived facts, so it
is the form a meta block takes in a C# or PowerShell file.

- **Defined by:** [ADR-REPO-CODEMETA-CODEFILEHEAD](repository/code-file-meta.md#rule-adr-repo-codemeta-codefilehead)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [materialization](#materialization): Materialization says when a resource comes into being and how long it holds; a meta head is where a
    generated file shows its commit key, body_sha.
  - [meta block](#meta-block): The meta block is the facts in any file; the meta head is the form they take in a code file.

### meta kind

One entry of the meta-kind registry, naming a kind of derived fact imprinted into files, or of config contribution gathered out of Markdown
files, with the files it applies to, the keys it owns and, for a gather kind, the config it feeds.

- **Defined by:** [ADR-REPO-FILEMETA-METAKIND](repository/file-meta.md#rule-adr-repo-filemeta-metakind)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [meta block](#meta-block): The meta block is the block in one file; a meta kind is the registry entry that says what goes in that block
    across files.
  - [role](#role): A role is the part one file plays; a meta kind is a registry entry that says which derived fact goes into a head.

### model floor

The lowest model that performs a capability's steps reliably; no robot that preloads the capability runs below it.

- **Defined by:** [ADR-REPO-AGENTS-NAMEDMODEL](repository/agent-definitions.md#rule-adr-repo-agents-namedmodel)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`

### pattern

One `.claude/slides/patterns/<name>.html` file — a section in the slide format whose placeholders name the fields it takes and which are
required; the layout of one kind of slide.

- **Defined by:** [ADR-REPO-SLIDES-PATTERN](repository/slides-as-markdown.md#rule-adr-repo-slides-pattern)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Slides/configs/glossary.yml`

### place facts

The facts under the immutable part of a meta block, which are what the repository's own configuration makes of a file's location, such as
its path, kind, language, track and module, each read from a registry and never from the file's text.

- **Defined by:** [ADR-REPO-FILEMETA-FILEISNODE](repository/file-meta.md#rule-adr-repo-filemeta-fileisnode)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [edge](#edge): The place facts are properties of the file as a node, read from the repository's configuration; an edge is a named
    relation leaving the file, read from its text.

### provided contract

A contract an outside consumer may rely on — the repository's only public API, kept while a consumer pins that version of its unit.

- **Defined by:** [ADR-REPO-CONTRACT-BINDINGINTERFACE](repository/api-contracts.md#rule-adr-repo-contract-bindinginterface)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [depended-on contract](#depended-on-contract): A depended-on contract is what an outside platform expects of our files and calls, and it
    follows that platform; a provided contract is a promise to a consumer, kept while the consumer pins that version of its unit.
  - [pin](#pin): A pin is the consumer's explicit choice of a version that crosses the repository boundary; a provided contract is the
    promise catzc keeps under that pin.

### robot

A sub-agent in its minimal form — a body of at most the roof's lines on a named model, loading shared know-how from capabilities instead of
carrying it.

- **Defined by:** [ADR-REPO-AGENTS-ROBOTBODYLIMIT](repository/agent-definitions.md#rule-adr-repo-agents-robotbodylimit)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`

### role

The part a file plays, such as a test, a function, a config or a decision record, named by the file-kinds registry and never by the file's
language, track or module.

- **Defined by:** [ADR-REPO-FILEMETA-ROLE](repository/file-meta.md#rule-adr-repo-filemeta-role)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [file language](#file-language): A file language is the sort of text a file holds, named by its extension; a role is what the file is
    for.
  - [file type](#file-type): A file type is how a file's name ends; a role is the part the file plays.
  - [meta kind](#meta-kind): A meta kind is a registry entry that says which derived fact goes into a head; a role is the part one file
    plays.
  - [subkind](#subkind): A subkind is one narrower role under a role, and a file has at most one; a role is the part itself.
  - [track](#track): A track is the cluster a file lives in; a role is the part it plays, wherever it lives.
  - [track type](#track-type): A track type is the sort of cluster a file lives in; a role is the part the file plays, wherever it lives.

### scope

What something reaches, always qualified — a PowerShell scope (module, script, global), an install scope (user, machine), or a selection
scope (verify, scan, content).

- **Defined by:** [ADR-REPO-VOCAB-FAMILYFORMS](repository/controlled-vocabulary.md#rule-adr-repo-vocab-familyforms)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Forms:** `PowerShell scope`, `selection scope`, `module scope`, `user scope`, `machine scope`, `content scope`, `script scope`,
  `verify scope`, `shared scope`, `file scope`, `target scope`, `scan scope`, `test scope`, `persistent scope`, `category scope`,
  `global scope`, `process scope`, `Pester scope`, `default scope`, `install scope`, `markdown scope`, `repo scope`, `lint scope`,
  `child scope`, `environment scope`, `subscription scope`, `report scope`, `tag scope`, `declared scope`, `whole scope`, `top scope`,
  `strict scope`, `isolated scope`, `discovery scope`, `glossary scope`, `deployment scope`, `infra scope`, `radius scope`,
  `production scope`, and the bare `scope`, with its verb forms

### slide file

One markdown file per slide, `<stem>.slide.md`, in a deck folder under docs/explanation; its level-one heading is the title, each level-two
heading a field, and its head names the pattern, the deck and the order.

- **Defined by:** [ADR-REPO-SLIDES-SLIDEFILE](repository/slides-as-markdown.md#rule-adr-repo-slides-slidefile)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Slides/configs/glossary.yml`
- **Contrasts:**
  - [deck file](#deck-file): The deck file names the deck's title and sections; a slide file is one slide of it.

### source

Where something comes from, always qualified — a source mode, run, or tree; a glossary source; a type, authored, vendor, or dot source.

- **Defined by:** [ADR-REPO-VOCAB-FAMILYFORMS](repository/controlled-vocabulary.md#rule-adr-repo-vocab-familyforms)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Forms:** `glossary source`, `type source`, `authored source`, `dot source`, `function source`, `vendor source`, `catzc source`,
  `combined source`, `committed source`, `shipped source`, `tracked source`, `fixture source`, `comparison source`, `primary source`,
  `raw source`, `install source`, `rule source`, `docs source`, `derived source`, `current source`, `real source`, `configured source`,
  `public source`, `single source`, `token source`, `relative source`, `repo source`, `authoritative source`, `cross source`,
  `vendored source`, `input source`, and the bare `source`, with its verb forms
- **Contrasts:**
  - [source of truth](#source-of-truth): The source of truth is the one store that decides what is true about the delivered system, the
    repository; a source, always qualified, names where one thing comes from.

### subkind

The narrowing of a role, such as a gate among the functions, written under its role in the file-kinds registry.

- **Defined by:** [ADR-REPO-FILEMETA-ROLE](repository/file-meta.md#rule-adr-repo-filemeta-role)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [file type](#file-type): A file type is how a file's name ends; a subkind is a narrower role, whatever the name.
  - [role](#role): A role is the part a file plays; a subkind is one narrower role under it, and a file has at most one.

### workstream

One labeled section of a plan's work breakdown (`out/plan-*.md`) — its own `### W<n>:` heading, order, and gate — that lands as one change.

- **Defined by:** [ADR-REPO-OUTDIR-PLANNOTES](repository/dedicated-output-directory.md#rule-adr-repo-outdir-plannotes)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary.yml`
