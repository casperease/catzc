---
catzc:
  immutable:
    with_body_sha: "24d57046fb96"
    warning: "Do Not Edit, this file is generated"
---

# docs/drs/glossary.md

Glossary: the controlled vocabulary

Every defined term of the repository, generated from the glossary sources (each module's `configs/glossary.yml`) by `Build-Glossary` — edit
a source, never this page. A term's meaning is fixed by the one ADR rule that defines it
([controlled-vocabulary](repository/controlled-vocabulary.md)); this page collects them, with how each differs from its neighbours and the
phrasings to avoid. `Test-Glossary` checks the sources.

## thesis

### actionable fact

A fact found by synchronising truth stores that is verifiable, naming the store, address, and moment it was read, and names the one change
or report it calls for.

- **Defined by:** [TDR-STORES-RECONCILEFACTS](thesis/truth-stores.md#rule-tdr-stores-reconcilefacts)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

### adjacent store

The one legitimate second store — a repository or service, such as a GitOps or configuration repository, or Azure DevOps Services or GitHub
SaaS, with its own history, driven one way from the trunk's pipelines and never edited beside it.

- **Defined by:**
  [TDR-ONETRUTH-REPOSITORYISCONFIGURATIONRECORD](thesis/one-source-of-truth.md#rule-tdr-onetruth-repositoryisconfigurationrecord)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [fact source](#fact-source): A fact source is owned by a state machine and only read; an adjacent store is driven one way from the
    trunk's pipelines.
  - [source of truth](#source-of-truth): An adjacent store is a second store driven one way from the trunk's pipelines, a projection of the
    truth; the source of truth is the record it is driven from.

### eac normal form

The shape in which the repository can verify any code — verifiable within its enabling constraints and uncontested by its formatters, tests,
and asserts.

- **Defined by:** [TDR-NORMALFORM-ANYCODEHASNORMALFORM](thesis/eac-normal-form.md#rule-tdr-normalform-anycodehasnormalform)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [repository normal form](#repository-normal-form): The repository normal form is the one language-neutral spelling of a name; the eac
    normal form is the verifiable shape of a whole piece of code.

| Avoid               | Say instead                                                                                 |
| ------------------- | ------------------------------------------------------------------------------------------- |
| `eac's normal form` | eac normal form (catzc's own term, not the sibling eac repository's form; ADR-REPO-INSPIRE) |

### enabling constraints

What a repository declares about itself — the sensible defaults, the catzc bundle, and the local configs — and nothing else.

- **Defined by:** [TDR-NORMALFORM-ENABLINGCONSTRAINTS](thesis/eac-normal-form.md#rule-tdr-normalform-enablingconstraints)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

### fact source

A state store — a database with a reachable live URL holding state about delivery outside the repository, such as the Azure DevOps runtime
state — whose state catzc reads only.

- **Defined by:** [TDR-STORES-FACTSOURCEREADONLY](thesis/truth-stores.md#rule-tdr-stores-factsourcereadonly)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [adjacent store](#adjacent-store): A fact source is owned by a state machine and only read; an adjacent store is driven one way from the
    trunk's pipelines.
  - [state machine](#state-machine): A state machine is the application that owns and changes a fact source; a fact source is the store
    catzc reads.

### fragment migration

Bringing an unordered code fragment into eac normal form through the one change process.

- **Defined by:** [TDR-NORMALFORM-MIGRATIONREACHESTHEFORM](thesis/eac-normal-form.md#rule-tdr-normalform-migrationreachestheform)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

### pin

An explicit version, controlled by the consumer, of a dependency that crosses the repository boundary inward, stitched into an immutable
artifact at build time.

- **Defined by:** [TDR-ONETRUTH-PRODUCTMONOREPOSITORY](thesis/one-source-of-truth.md#rule-tdr-onetruth-productmonorepository)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [provided contract](#provided-contract): A pin is the consumer's explicit choice of a version that crosses the repository boundary; a
    provided contract is the promise catzc keeps under that pin.
  - [trunk](#trunk): A pin is an explicit version at the repository boundary; inside the trunk nothing is pinned, and everything is at HEAD.

### product mono-repository

One repository that several teams contribute to for one product, bounded into tracks and deployable-units by path filters; catzc is one.

- **Defined by:** [TDR-ONETRUTH-PRODUCTMONOREPOSITORY](thesis/one-source-of-truth.md#rule-tdr-onetruth-productmonorepository)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [trunk](#trunk): The trunk is the one mainline of a product mono-repository, where everything is at HEAD; the product mono-repository is
    the repository as a whole, with its tracks and deployable-units.

### query surface

The tooling's Get-* cmdlets, each of which also emits its answer as data (JSON), through which every question about the system's state is
answered.

- **Defined by:** [TDR-ONETRUTH-TRUTHISQUERYABLE](thesis/one-source-of-truth.md#rule-tdr-onetruth-truthisqueryable)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

### responsibility domain

The organisation, team, product, or person that one repository is the responsibility boundary for, set by where git's hard security controls
stop.

- **Defined by:** [TDR-STORES-RESPONSIBILITYDOMAIN](thesis/truth-stores.md#rule-tdr-stores-responsibilitydomain)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [domain](#domain): A responsibility domain is what one repository is accountable for; a decision-record domain groups decision records.

### source of truth

The one store whose content decides what is true about the delivered system — for catzc, the repository, changed through one change process.

- **Defined by:** [TDR-ONETRUTH-ONESTOREDECIDES](thesis/one-source-of-truth.md#rule-tdr-onetruth-onestoredecides)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [adjacent store](#adjacent-store): An adjacent store is a second store driven one way from the trunk's pipelines, a projection of the
    truth; the source of truth is the record it is driven from.
  - [source](#source): The source of truth is the one store that decides what is true about the delivered system, the repository; a source,
    always qualified, names where one thing comes from.
  - [truth store](#truth-store): A truth store is any store of the three kinds; the source of truth is the one truth store that decides
    inside a responsibility domain, the repository.

### state machine

An application that owns fact sources and changes their state by its own rules, met by catzc only at a junction, inbound or outbound.

- **Defined by:** [TDR-STORES-STATEMACHINE](thesis/truth-stores.md#rule-tdr-stores-statemachine)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [fact source](#fact-source): A state machine is the application that owns and changes a fact source; a fact source is the store catzc
    reads.

### trunk

The one mainline of a product mono-repository, where everything is at HEAD — no internal versions, and a shared change lands in one commit
with all its consumers.

- **Defined by:** [TDR-ONETRUTH-PRODUCTMONOREPOSITORY](thesis/one-source-of-truth.md#rule-tdr-onetruth-productmonorepository)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [pin](#pin): A pin is an explicit version at the repository boundary; inside the trunk nothing is pinned, and everything is at HEAD.
  - [product mono-repository](#product-mono-repository): The trunk is the one mainline of a product mono-repository, where everything is at
    HEAD; the product mono-repository is the repository as a whole, with its tracks and deployable-units.

### truth store

Any store that holds part of the truth about a delivered system — a version-controlled repository, a fact source, or a state machine.

- **Defined by:** [TDR-STORES-THREEKINDS](thesis/truth-stores.md#rule-tdr-stores-threekinds)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [source of truth](#source-of-truth): A truth store is any store of the three kinds; the source of truth is the one truth store that
    decides inside a responsibility domain, the repository.

### uncontested

Of code, left unchanged by every formatter and failed by no test or assert of the repository; the fixed point of its checks.

- **Defined by:** [TDR-NORMALFORM-UNCONTESTED](thesis/eac-normal-form.md#rule-tdr-normalform-uncontested)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

### unordered code fragment

Code from outside the trunk, in whatever shape its origin left it, that is not yet in eac normal form and decides nothing.

- **Defined by:** [TDR-NORMALFORM-ANYCODEHASNORMALFORM](thesis/eac-normal-form.md#rule-tdr-normalform-anycodehasnormalform)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

### version-controlled repository

The kind of truth store whose content is a versioned history of reviewed changes; a git repository is one subgroup of it.

- **Defined by:** [TDR-STORES-VERSIONCONTROLLEDREPOSITORY](thesis/truth-stores.md#rule-tdr-stores-versioncontrolledrepository)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

## principles

### cats

The product's name to a person — the executor outside pwsh, and the word in prose, docs and conversation.

- **Defined by:** [PDR-CATS-CATSISPERSONNAME](principles/cats-and-catzc.md#rule-pdr-cats-catsispersonname)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [catzc](#catzc): cats is the same system named to a person; catzc is its name to code and to the facts the tooling writes.

### catzc

The source-level name of the system — the Catzc.* module prefix, the C# namespaces, the type-accelerator prefix, and the product token in
code and precise references.

- **Defined by:** [PDR-CATS-CATZCISSOURCENAME](principles/cats-and-catzc.md#rule-pdr-cats-catzcissourcename)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [cats](#cats): cats is the same system named to a person; catzc is its name to code and to the facts the tooling writes.

| Avoid          | Say instead |
| -------------- | ----------- |
| `.cats folder` | .catzc/     |

## design

### cell

One row crossed with one column of a map — the world map's tracked files of one track in one file language, or the value-chain map's
decision records of one row of the value-chain stack in one value-chain concern.

- **Defined by:** [DDR-TRACK-CELL](design/tracks.md#rule-ddr-track-cell)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [lit cell](#lit-cell): A lit cell is a cell a highlight selects; a cell is any intersection, lit or not.
  - [stack violation](#stack-violation): A stack violation is a cell holding a live file outside its track's file languages; a cell is any
    intersection, allowed or not.
  - [value-chain map](#value-chain-map): The value-chain map is a whole grid; a cell is one intersection of it, holding the decision records
    of one row in one value-chain concern.
  - [world map](#world-map): A cell is one row crossed with one column; the world map is the whole grid of them, computed from the
    registries and the git index.

### deployable track

A track whose type owns deployable-units — collections of its modules that the repository delivers through CI/CD.

- **Defined by:** [DDR-TRACKTYPE-ONEROLE](design/track-types.md#rule-ddr-tracktype-onerole)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [deployable-unit](#deployable-unit): A deployable track is the track that owns deployable-units; a deployable-unit is what ships.
  - [holder track](#holder-track): A holder track is itself a module and ships nothing of its own; a deployable track owns deployable-units.

### deployable-unit

What ships — a whole track or a reduced composition — bound one-to-one to its pipeline.

- **Defined by:** [DDR-TRACK-DEPLOYABLEUNIT](design/tracks.md#rule-ddr-track-deployableunit)
- **Realized by:** config-key `pwsh/Catzc.Base.Globs/configs/globs.yml`
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [bundle](#bundle): A deployable-unit is what ships from the mono-repository, composed from a whole track or part of one; a bundle is one
    build of the toolset.
  - [deployable track](#deployable-track): A deployable track is the track that owns deployable-units; a deployable-unit is what ships.
  - [release candidate](#release-candidate): A release candidate is one commit's tagged, immutable build of a deployable-unit; a
    deployable-unit is the composition that ships, whichever commit is built.
  - [track](#track): A track is a cluster of module contents; a deployable-unit is what ships, composed from a whole track or a reduced part
    of one.

### file language

The language a tracked file is written in, named by its extension — PowerShell, C#, YAML, Bicep, Markdown, Python; a track's tech-stack is a
set of them.

- **Defined by:** [DDR-TRACK-FILELANGUAGE](design/tracks.md#rule-ddr-track-filelanguage)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [contract language](#contract-language): A file language is the kind of text a file holds, named by its extension; the contract language
    is a notation inside one YAML file, not a file language of its own.
  - [file type](#file-type): A file language groups the extensions of one kind of text; a file type is the single extension of one file.
  - [implementation language](#implementation-language): A file language is any language the registry names by extension; an implementation
    language is one a command is written in.
  - [language zone](#language-zone): A file language is the kind of text one file holds, named by its extension; a language zone is a
    register of identities.
  - [role](#role): A file language is the sort of text a file holds, named by its extension; a role is what the file is for.
  - [track](#track): A file language is the kind of text a file holds, named by its extension; a track is the cluster the file lives in, and
    its tech-stack is a set of file languages.
  - [unlisted file](#unlisted-file): An unlisted file is a tracked file no file language names — no extension, or one no entry lists; a file
    language is a registered kind of text, named by its extensions.

### holder track

A track that is itself a module more than it owns modules — one vendor's, one tool's or one purpose's files, shipping nothing of its own.

- **Defined by:** [DDR-TRACKTYPE-ONEROLE](design/track-types.md#rule-ddr-tracktype-onerole)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [deployable track](#deployable-track): A holder track is itself a module and ships nothing of its own; a deployable track owns
    deployable-units.

### import

Bringing an outside repository into this one with its full history, at one landing address.

- **Defined by:** [DDR-TRACK-UNORDEREDTRACK](design/tracks.md#rule-ddr-track-unorderedtrack)
- **Realized by:** function `Import-RepositoryWithHistory`
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [importer](#importer): The importer brings catzc's modules into a session; an import brings an outside repository's files and history
    into this repository.

### landing address

The folder `.unordered/<name>` an import lands at, named by a short kebab word unique among the addresses.

- **Defined by:** [DDR-TRACK-UNORDEREDTRACK](design/tracks.md#rule-ddr-track-unorderedtrack)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [landing zone](#landing-zone): A landing address is the folder an import lands at under the unordered track; a landing zone is the Azure
    network and guardrails a workload lands in.

### lit cell

A cell a highlight selects — on the world map the cells of the files a rule code or a file set names, on the value-chain map the cells a
decision record sits in.

- **Defined by:** [DDR-TRACK-LITCELL](design/tracks.md#rule-ddr-track-litcell)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [cell](#cell): A lit cell is a cell a highlight selects; a cell is any intersection, lit or not.
  - [stack violation](#stack-violation): A lit cell is selected by a highlight and says nothing about the stack; a stack violation is a
    finding, marked whatever the highlight.

### module

A named unit placed in a track — a folder or one file, found by where its files stand — resolved through its track.

- **Defined by:** [DDR-MODTYPE-MODULEISPLACEDUNIT](design/module-types.md#rule-ddr-modtype-moduleisplacedunit)
- **Realized by:** type `Catzc.Base.Modules.Module`
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [module type](#module-type): A module is one named unit placed in a track; a module type is the sort of module found at a place, one of
    a closed set.
  - [track](#track): A module is one named unit placed in a track; a track is the cluster of module contents and the concern it holds.

### module type

The sort of module, named by the module-types registry, which says where modules of each type are found and how a path in that place names
its module.

- **Defined by:** [DDR-MODTYPE-MODULETYPEISSORT](design/module-types.md#rule-ddr-modtype-moduletypeissort)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [layout](#layout): A layout says what a module's own folders hold; a module type says where modules of a sort are found.
  - [module](#module): A module is one named unit placed in a track; a module type is the sort of module found at a place, one of a closed
    set.
  - [track](#track): A track is the cluster of module contents and the concern it holds; a module type is the sort of module found at a
    place inside or across tracks.
  - [track type](#track-type): A track type is the sort of cluster a track is; a module type is the sort of module placed in it.

### occupant

The one commit an always-on environment holds, deployed there as its release candidate — named by its environment.

- **Defined by:** [FDR-CD-LIFE-ONECOMMITPERENVIRONMENT](flow/commit-lifecycle.md#rule-fdr-cd-life-onecommitperenvironment)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [release candidate](#release-candidate): An occupant is the commit an environment holds; a release candidate is the artifact built from
    it, the same bytes wherever it is deployed.

| Avoid               | Say instead                             |
| ------------------- | --------------------------------------- |
| `current occupant`  | occupant (the `<environment>` occupant) |
| `current occupants` | occupants                               |
| `resident commit`   | occupant                                |

### place

A path a track declares it covers — a root folder, a path inside one, or a tool's root folder; the longest place that contains a file names
its track.

- **Defined by:** [DDR-TRACK-TRACKISPLACEDCLUSTER](design/tracks.md#rule-ddr-track-trackisplacedcluster)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [track](#track): A place is one path a track covers; a track is the cluster of module contents, whatever places select it.

### root file

A tracked file no track holds — at the repository root itself, or under out/ — the world map's own row.

- **Defined by:** [DDR-TRACK-ROOTFILE](design/tracks.md#rule-ddr-track-rootfile)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [track](#track): A root file is a tracked file no track holds, at the repository root or under out/; a track is a cluster of places and
    every file under them.
  - [unlisted file](#unlisted-file): An unlisted file is a tracked file outside every file language, whatever its track; a root file is one
    outside every track, whatever its file language.

### run mode

How the toolset is loaded, source mode from a repository root or build mode from a built package; exactly two exist.

- **Defined by:** [DDR-RUNMODE-TWORUNMODES](design/run-modes.md#rule-ddr-runmode-tworunmodes)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [importer](#importer): The importer decides which modules, languages and engines a session loads; a run mode says where it reads the
    modules from.

### sorting

Moving a file from its landing address to its module or track with `git mv`, so its history follows.

- **Defined by:** [DDR-TRACK-UNORDEREDTRACK](design/tracks.md#rule-ddr-track-unorderedtrack)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`

### stack violation

A world-map cell holding a live file whose file language its track does not declare — the second tech-stack DDR-TRACK-ONETECHSTACK forbids.

- **Defined by:** [DDR-TRACK-STACKVIOLATION](design/tracks.md#rule-ddr-track-stackviolation)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [cell](#cell): A stack violation is a cell holding a live file outside its track's file languages; a cell is any intersection, allowed
    or not.
  - [lit cell](#lit-cell): A lit cell is selected by a highlight and says nothing about the stack; a stack violation is a finding, marked
    whatever the highlight.
  - [value-chain stack](#value-chain-stack): A stack violation is a world-map cell outside its track's tech-stack, a set of file languages;
    the value-chain stack orders decisions, not files.

### staging slot

System.Collections.Specialized.OrderedDictionary

- **Defined by:** [FDR-CD-LIFE-ONECOMMITPERENVIRONMENT](flow/commit-lifecycle.md#rule-fdr-cd-life-onecommitperenvironment)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

### track

A named, on-disk cluster of module contents — the tracked files of one concern, selected by the places the track declares, and of one track
type.

- **Defined by:** [DDR-TRACK-TRACKISPLACEDCLUSTER](design/tracks.md#rule-ddr-track-trackisplacedcluster)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [deployable-unit](#deployable-unit): A track is a cluster of module contents; a deployable-unit is what ships, composed from a whole
    track or a reduced part of one.
  - [file language](#file-language): A file language is the kind of text a file holds, named by its extension; a track is the cluster the
    file lives in, and its tech-stack is a set of file languages.
  - [language track](#language-track): A language track is a modules track of one language, holding its modules and its test holder alike; a
    track is any cluster of module contents.
  - [module](#module): A module is one named unit placed in a track; a track is the cluster of module contents and the concern it holds.
  - [module type](#module-type): A track is the cluster of module contents and the concern it holds; a module type is the sort of module
    found at a place inside or across tracks.
  - [place](#place): A place is one path a track covers; a track is the cluster of module contents, whatever places select it.
  - [role](#role): A track is the cluster a file lives in; a role is the part it plays, wherever it lives.
  - [root file](#root-file): A root file is a tracked file no track holds, at the repository root or under out/; a track is a cluster of
    places and every file under them.
  - [track type](#track-type): A track type is the sort of cluster a track is, one of a closed set; a track is the named cluster itself.
  - [value-chain concern](#value-chain-concern): A value-chain concern is where along delivery a decision acts; a track is a concern of the
    repository, the cluster where files live.

### track type

The sort of cluster a track is, one of a closed set — modules, infrastructure, pipelines, vendor-settings, vendored-code, contracts,
documentation, or unordered.

- **Defined by:** [DDR-TRACKTYPE-CLOSEDSETOFTYPES](design/track-types.md#rule-ddr-tracktype-closedsetoftypes)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [module type](#module-type): A track type is the sort of cluster a track is; a module type is the sort of module placed in it.
  - [role](#role): A track type is the sort of cluster a file lives in; a role is the part the file plays, wherever it lives.
  - [track](#track): A track type is the sort of cluster a track is, one of a closed set; a track is the named cluster itself.

### unlisted file

A tracked file no file language names — no extension, or one no entry lists — the world map's own column.

- **Defined by:** [DDR-TRACK-UNLISTEDFILE](design/tracks.md#rule-ddr-track-unlistedfile)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [file language](#file-language): An unlisted file is a tracked file no file language names — no extension, or one no entry lists; a file
    language is a registered kind of text, named by its extensions.
  - [root file](#root-file): An unlisted file is a tracked file outside every file language, whatever its track; a root file is one outside
    every track, whatever its file language.

### unordered track

The track at `.unordered` where imports land; the unordered part of the repository is whatever is still under it, and nothing internal reads
or falls back to it.

- **Defined by:** [DDR-TRACK-UNORDEREDTRACK](design/tracks.md#rule-ddr-track-unorderedtrack)
- **Realized by:** config-key `pwsh/Catzc.Base.Variants/configs/variants.yml`
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`

### value-chain concern

Where along delivery a decision record acts — automation, build, quality-control, release, deploy, or access — a default per decision-record
domain, an override per decision record.

- **Defined by:** [DDR-TRACK-VALUECHAINCONCERN](design/tracks.md#rule-ddr-track-valuechainconcern)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [track](#track): A value-chain concern is where along delivery a decision acts; a track is a concern of the repository, the cluster
    where files live.
  - [value-chain stack](#value-chain-stack): A value-chain concern is a column, where along delivery a decision record acts; the value-chain
    stack is the rows, how general the decision is.

### value-chain map

The decision records drawn as the value-chain stack crossed with the value-chain concerns, computed from drs.yml — where a decision sits in
the value chain.

- **Defined by:** [DDR-TRACK-VALUECHAINMAP](design/tracks.md#rule-ddr-track-valuechainmap)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [cell](#cell): The value-chain map is a whole grid; a cell is one intersection of it, holding the decision records of one row in one
    value-chain concern.
  - [world map](#world-map): The value-chain map says where along delivery a decision acts; the world map crosses tracks with file languages
    and says where its files sit.

### value-chain stack

The ordered rows a decision sits on, from the axioms down to the vendor — PRIN, DSGN, AUTO, PIPE, CLOUD; each decision-record domain
declares one.

- **Defined by:** [DDR-TRACK-VALUECHAINSTACK](design/tracks.md#rule-ddr-track-valuechainstack)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [stack violation](#stack-violation): A stack violation is a world-map cell outside its track's tech-stack, a set of file languages; the
    value-chain stack orders decisions, not files.
  - [value-chain concern](#value-chain-concern): A value-chain concern is a column, where along delivery a decision record acts; the
    value-chain stack is the rows, how general the decision is.

### vendor

The platform or tool that reads a track's files, from a closed set declared once — never the third party that wrote them.

- **Defined by:** [DDR-TRACKTYPE-OPTIONALVENDOR](design/track-types.md#rule-ddr-tracktype-optionalvendor)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [vendored code](#vendored-code): Vendored code is written by a third party and the repository does not author it; a vendor is the
    platform that reads a track's files.

### vendored code

Code written by a third party that the repository does not author, held in a track of its own nested under another track's root.

- **Defined by:** [DDR-TRACKTYPE-VENDOREDCODE](design/track-types.md#rule-ddr-tracktype-vendoredcode)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [vendor](#vendor): Vendored code is written by a third party and the repository does not author it; a vendor is the platform that reads
    a track's files.

### world map

The repository drawn as tracks crossed with file languages, plus a row for the root files and a column for the unlisted files — every
tracked file in exactly one cell.

- **Defined by:** [DDR-TRACK-WORLDMAP](design/tracks.md#rule-ddr-track-worldmap)
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

- **Defined by:** [FDR-CD-GATEDEFINED](flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-gatedefined)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Forms:** `quality gate`, `CI gate`, `AT gate`, `RC gate`, `RBC gate`, `BVT gate`, `release gate`, `manual gate`, `PR gate`,
  `merge gate`, `commit gate`, `approval gate`, `production gate`, `push gate`, and the bare `gate`, with its verb forms
- **Contrasts:**
  - [manual queue](#manual-queue): A gate is any check a commit climbs through, code or person; a manual queue is the wait in front of the
    gates a person serves.
  - [quality gate](#quality-gate): A quality gate is one automated check of the repository; a gate is any decision point, human or
    automated.

### manual queue

A point on the promotion ladder where a commit waits for a person's act before it climbs; the ladder has three, each with a named server, a
named store and a measured wait.

- **Defined by:** [FDR-CD-QUEUE-THREEQUEUES](flow/manual-queues.md#rule-fdr-cd-queue-threequeues)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [gate](#gate): A gate is any check a commit climbs through, code or person; a manual queue is the wait in front of the gates a person
    serves.

### release candidate

The immutable, tagged artifact a CI component builds from one commit — versioned, never rebuilt, promotable toward production.

- **Defined by:** [FDR-CD-RELEASECANDIDATE](flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-releasecandidate)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [deployable-unit](#deployable-unit): A release candidate is one commit's tagged, immutable build of a deployable-unit; a deployable-unit
    is the composition that ships, whichever commit is built.
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

### release signature

One recorded act in the appointed security registry by a user with access, saying that a rung passed its check for one named commit; it
serves the RC gate for main-UAT and the RBC gate for release-uat.

- **Defined by:** [FDR-CD-QUEUE-SIGNATUREISTHEGATE](flow/manual-queues.md#rule-fdr-cd-queue-signatureisthegate)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

### slot switch

The automated, monitored act that makes the pre-prod occupant the live production occupant and moves the former one into the staging slot;
never a manual queue.

- **Defined by:** [FDR-CD-QUEUE-SLOTSWITCHISAUTOMATED](flow/manual-queues.md#rule-fdr-cd-queue-slotswitchisautomated)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

## automation

### accosted

The cats language of `<name>.accosted.yml` files, a flat list of runs, each a list of harmless contracted commands in the contract form with
literal arguments, run under every engine; the word is reserved for it.

- **Defined by:** [ADR-AUTO-ACCOSTED-FILEFORM](automation/accosted-language.md#rule-adr-auto-accosted-fileform)
- **Realized by:** type `Catzc.Base.Contracts.AccostedFile`
- **Source:** `pwsh/Catzc.Base.Languages/configs/glossary.yml`

### all tests

Every test in the repository — every test file of every module, at every tier and category; what a test run selects at its defaults.

- **Defined by:** [ADR-AUTO-TEST-ALLTESTS](automation/test-automation.md#rule-adr-auto-test-alltests)
- **Realized by:** function `Test-Automation`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [test run](#test-run): All tests is every test in the repository, at rest; a test run executes one selection of them, possibly all.
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
  - [execution engine](#execution-engine): auto is a value that leaves the engine open; an execution engine is the pwsh, bash or zsh it
    resolves to.

### automation

The abstract, the commands and behaviours the repository offers and the doctrine that governs them, independent of language, shell and
folder; the decision-record domain, the value-chain row and the concern carry the name.

- **Defined by:** [ADR-AUTO-LAYERS-AUTOMATIONISABSTRACT](automation/layers.md#rule-adr-auto-layers-automationisabstract)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
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
  - [quality gate](#quality-gate): The BVT is the verification that runs every quality gate together; a quality gate is one check inside it.

### bundle

The toolset's build, one installable, versioned Catzc package of one named bundle, built from a profile of the exporter registry.

- **Defined by:** [ADR-AUTO-BUNDLE-BUNDLEISBUILD](automation/platform-bundle.md#rule-adr-auto-bundle-bundleisbuild)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [deployable-unit](#deployable-unit): A deployable-unit is what ships from the mono-repository, composed from a whole track or part of
    one; a bundle is one build of the toolset.

### category

A test's kind, logic or integrity — one mandatory tag saying whether it runs on fixtures or reads the shipped assets.

- **Defined by:** [ADR-AUTO-TEST-ONECATEGORY](automation/test-automation.md#rule-adr-auto-test-onecategory)
- **Realized by:** tag `logic|integrity`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [tier](#tier): A category says what a test reads (logic or integrity); a tier says what it may touch and when it runs.

| Avoid             | Say instead         |
| ----------------- | ------------------- |
| `integrity suite` | the integrity tests |

### command

One public function of the module system, the unit a contract describes, written in one implementation language.

- **Defined by:** [ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION](automation/layers.md#rule-adr-auto-layers-commandispublicfunction)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
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
  - [posture](#posture): A config fragment is a file that changes a few keys of a shipped config; a posture is what one key does when no
    file states it.

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
  - [pwsh](#pwsh): pwsh is one of the three execution engines, and the name the PowerShell track takes from it.

### go test module

The folder `<root>/tests/<module>/` under the Go root — one Go module per catzc module, named for it as one lowercase word
(`catzcbaserepository`), holding its black-box Go tests.

- **Defined by:** [ADR-AUTO-GO-ONEGOROOT](automation/go/go-test-artifacts.md#rule-adr-auto-go-onegoroot)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Languages/configs/glossary.yml`

### implementation language

The file language a command's source is written in, one whose languages.yml entry sets executable, which are PowerShell with its hosted C#,
Bash, Python and Go.

- **Defined by:** [ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION](automation/layers.md#rule-adr-auto-layers-commandispublicfunction)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [contract language](#contract-language): An implementation language is the file language a command's source is written in; the contract
    language is the notation its call interface is stated in.
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
  - [automation](#automation): The importer brings a mix of languages, engines and modules into a session; automation is what the loaded
    modules offer.
  - [import](#import): The importer brings catzc's modules into a session; an import brings an outside repository's files and history into
    this repository.
  - [run mode](#run-mode): The importer decides which modules, languages and engines a session loads; a run mode says where it reads the
    modules from.

### language track

A modules track of one language — pwsh, python, go, bash — holding its modules as folders under its root and its own test holder under
tests/, the same way for every language.

- **Defined by:** [ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE](automation/module-model.md#rule-adr-auto-module-everylanguagetrackalike)
- **Realized by:** config-key `pwsh/Catzc.Base.Variants/configs/module-types.yml`
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [track](#track): A language track is a modules track of one language, holding its modules and its test holder alike; a track is any
    cluster of module contents.

### layout

The one table of folders inside a module and what each holds, declared once under each file language and read by every command that reads a
module's folders.

- **Defined by:** [ADR-AUTO-MODULE-EXISTSBYLAYOUT](automation/module-model.md#rule-adr-auto-module-existsbylayout)
- **Realized by:** config-key `pwsh/Catzc.Base.Languages/configs/languages.yml`
- **Source:** `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [module type](#module-type): A layout says what a module's own folders hold; a module type says where modules of a sort are found.

### materialization

When a knowledge resource comes into being and how long it holds, on-demand (made when asked, held for the call or the session) or commit
(made at commit, keyed by the scoped sha of its inputs, never changing).

- **Defined by:** [ADR-AUTO-MATERIAL-MATERIALIZATION](automation/materialization.md#rule-adr-auto-material-materialization)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [meta head](#meta-head): Materialization says when a resource comes into being and how long it holds; a meta head is where a generated
    file shows its commit key, body_sha.

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
  - [tier](#tier): A phase is when a test's file runs within a run (parallel, greedy, serial); a tier is what the test may touch.

### posix engine

System.Collections.Specialized.OrderedDictionary

- **Defined by:** [ADR-AUTO-ENGINE-IMPORTERENTRY](automation/execution-engines.md#rule-adr-auto-engine-importerentry)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Engines/configs/glossary.yml`
- **Contrasts:**
  - [execution engine](#execution-engine): A POSIX engine is an execution engine whose importer entry is importer.sh; an execution engine is
    any one of them, pwsh included.

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
  - [contract asset](#contract-asset): A published artifact is a file one stage produces and a later stage consumes within a run; a contract
    asset is a checked-in file that states what the repository boundary requires, frozen with its unit's release.
  - [release candidate](#release-candidate): A published artifact is any file handed across a stage boundary; a release candidate is the
    tagged build that gets promoted.

### pwsh

The name of the PowerShell track and of the engine that runs it; the PowerShell product itself is called PowerShell in prose.

- **Defined by:** [ADR-AUTO-LAYERS-TOOLSRUNTHROUGHENGINE](automation/layers.md#rule-adr-auto-layers-toolsrunthroughengine)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [execution engine](#execution-engine): pwsh is one of the three execution engines, and the name the PowerShell track takes from it.

### python test folder

The folder `<root>/tests/<module>/` under the Python root — one per catzc module, named for it in snake case (`catzc_base_repository`),
holding its black-box Python tests; each is a member of the one generated uv workspace.

- **Defined by:** [ADR-AUTO-PY-ONEPYTHONROOT](automation/python/python-test-artifacts.md#rule-adr-auto-py-onepythonroot)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Languages/configs/glossary.yml`

### quality gate

A gate checking one property of the whole repository automatically — one `Test-<subject>` function that reports through
Write-QualityGateReport and throws once with every issue.

- **Defined by:** [ADR-AUTO-TEST-QUALITYGATE](automation/test-automation.md#rule-adr-auto-test-qualitygate)
- **Realized by:** function `Write-QualityGateReport`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Kind of:** [gate](#gate)
- **Contrasts:**
  - [build verification test](#build-verification-test): The BVT is the verification that runs every quality gate together; a quality gate
    is one check inside it.
  - [gate](#gate): A quality gate is one automated check of the repository; a gate is any decision point, human or automated.

| Avoid            | Say instead                                     |
| ---------------- | ----------------------------------------------- |
| `analyzer suite` | the analyzer quality gate (Test-ScriptAnalyzer) |

### repository normal form

The one language-neutral spelling of a function, type, parameter or module name, in the naming case the languages config sets as
`naming.normal_form`, which is `snake` (`get_command_contract`); every language's idiomatic name is a rendering of it.

- **Defined by:** [ADR-AUTO-IDIOM-NORMALFORM](automation/idiomatic-names.md#rule-adr-auto-idiom-normalform)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Languages/configs/glossary.yml`
- **Contrasts:**
  - [eac normal form](#eac-normal-form): The repository normal form is the one language-neutral spelling of a name; the eac normal form is
    the verifiable shape of a whole piece of code.

### test

The smallest unit of verification that passes or fails on its own — counted by every report row, rule citation, skip, and timing; in pwsh
one Pester It.

- **Defined by:** [ADR-AUTO-TEST-TEST](automation/test-automation.md#rule-adr-auto-test-test)
- **Realized by:** function `It`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Part of:** [test block](#test-block)
- **Contrasts:**
  - [test block](#test-block): A test is one It that passes or fails; a test block groups tests and carries their shared tags and setup.

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
  - [release candidate](#release-candidate): A test run executes tests; a release candidate is the artifact a release-candidate test run
    verifies.
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
  - [all tests](#all-tests): A test suite is a named selection, usually a few modules up to a tier; all tests is every test there is.
  - [release candidate](#release-candidate): A test suite is the declared selection of tests that verifies a change; a release candidate is
    the artifact under test.
  - [test run](#test-run): A test suite is a declared selection at rest; a test run executes a selection, a test suite or an ad-hoc one.
  - [tier](#tier): A test suite is a declared selection of modules up to a top tier; a tier is one level a single test carries.

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
  - [testing in production](#testing-in-production): A vertical test crosses the local-tool or outside-state ring around the code; testing
    in production checks the released system.
  - [tier](#tier): A vertical test is an L2 or L3 test that cuts from its ring through to the core; a tier names the ring, any test has one.

## pwsh

### test block

A Describe or Context in a test file — a named group of tests whose tags and setup apply to everything inside it.

- **Defined by:** [ADR-PWSH-PESTER-TESTISIT](automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-testisit)
- **Realized by:** function `Describe|Context`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Part of:** [test file](#test-file)
- **Contrasts:**
  - [test](#test): A test is one It that passes or fails; a test block groups tests and carries their shared tags and setup.
  - [test file](#test-file): A test block is a Describe or Context inside a test file; a test file is the file that holds them.

## configuration

### config contribution

One config value, a key path and its value, that an author states in the config part of a tracked Markdown file's meta block and that the
config reader gathers into the config that opted in to it.

- **Defined by:**
  [ADR-CONF-MDCONTRIB-CONFIGCONTRIBUTION](configuration/markdown-config-contributions.md#rule-adr-conf-mdcontrib-configcontribution)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

## azure

### break-glass login

The one SQL login beside a server's Entra ID admin group, its password a Key Vault reference to foundation's vault.

- **Defined by:** [ADR-AZ-LZ-SQLENTRAADMINS](azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`

### caf tags

The six tag keys every resource carries — workload, environment, owner, cost-center, criticality, data-classification; cost-center is
required by policy.

- **Defined by:**
  [ADR-AZ-CAF-NAME-DEFINETAGGINGREQUIREMENTS](azure/caf/naming-and-tagging.md#rule-adr-az-caf-name-definetaggingrequirements)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`

### cloud adoption framework

Microsoft's guidance for preparing an Azure estate; its landing-zone design principles and design areas are recorded as vendor
recommendation in docs/drs/azure/caf/, one rule per recommendation.

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
efficiency — each one ADR in docs/drs/azure/waf/.

- **Defined by:** [ADR-AZ-LZ-EVERYPILLAR](azure/landing-zones.md#rule-adr-az-lz-everypillar)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`

### slot

A Bicep configuration slot — one config file of a template (`<env>[-<slot>].yml`), deploying one subscription's resource group.

- **Defined by:** [ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`
- **Forms:** `Bicep slot`, `base slot`, `configuration slot`, `root slot`, `template slot`, `indexed slot`, `special slot`, `optional slot`,
  `customer slot`, `platform slot`, `env slot`, `core slot`, `subfolder slot`, `target slot`, `region slot`, `yml slot`, `bicepparam slot`,
  and the bare `slot`

### spoke

The landing zone of a customer subscription — peered to the hub of its tier, holding the subnet its workloads' private endpoints use.

- **Defined by:** [ADR-AZ-LZ-HUBANDSPOKE](azure/landing-zones.md#rule-adr-az-lz-hubandspoke)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`
- **Contrasts:**
  - [hub](#hub): A spoke is a customer subscription's landing zone, peered to its hub; a hub is a shared subscription's, listing its spokes.

### subscription vending

Onboarding a subscription by pull request — its azure.yml entry, its range in network.yml, and one config per template; the subscription
itself is created outside the repository.

- **Defined by:**
  [ADR-AZ-CAF-RESORG-SUBSCRIPTIONVENDINGPROCESS](azure/caf/resource-organization.md#rule-adr-az-caf-resorg-subscriptionvendingprocess)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`

### well-architected framework

Microsoft's checklist of a workload's quality in five pillars; each checklist item is a rule in docs/drs/azure/waf/, numbered as Microsoft
numbers it.

- **Defined by:** [ADR-AZ-LZ-EVERYPILLAR](azure/landing-zones.md#rule-adr-az-lz-everypillar)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Azure.Templates/configs/glossary.yml`
- **Contrasts:**
  - [cloud adoption framework](#cloud-adoption-framework): The Cloud Adoption Framework shapes the landing zone; the Well-Architected
    Framework shapes the workload in it.

## repository

### algorithmical insight

One authored comment line that gives a reader the clue the code cannot say, why it is shaped so or what breaks if it changes.

- **Defined by:** [ADR-REPO-COMMENTS-CLUESNOTNARRATION](repository/comments-in-docs.md#rule-adr-repo-comments-cluesnotnarration)
- **Realized by:** function `Export-Comments`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`

| Avoid                | Say instead                       |
| -------------------- | --------------------------------- |
| `narration comment`  | an algorithmical insight / a clue |
| `diagnostic comment` | an algorithmical insight / a clue |

### capability

One `.claude/skills/<domain>-<job>/SKILL.md` file a robot preloads through its `skills` list — at most the roof's lines, with a model floor
declared once in its metadata.

- **Defined by:** [ADR-REPO-AGENTS-CAPABILITYFILE](repository/agent-definitions.md#rule-adr-repo-agents-capabilityfile)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

### code link

A rule citation in a code comment, written as a repository-rooted markdown link whose text is the citation code.

- **Defined by:** [ADR-REPO-LINK-KINDBYFILE](repository/markdown-links.md#rule-adr-repo-link-kindbyfile)
- **Realized by:** function `Format-Links`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [markdown link](#markdown-link): A code link lives in a comment of a non-markdown file and is repository-rooted; a markdown link lives
    in a .md file and is relative to it.

### command contract

A provided contract asset, `<module>/<Verb-Noun>.command.yml` in a unit's version folder, that states one command's call interface in the
contract language; a command is public exactly when one names it.

- **Defined by:** [ADR-REPO-CMDCONTRACT-COMMANDCONTRACT](repository/command-contracts.md#rule-adr-repo-cmdcontract-commandcontract)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [command](#command): A command contract is the asset that states a command's call interface at the boundary; the command is the function
    that implements it.
  - [contract asset](#contract-asset): A command contract is the one asset kind that states a command's call interface and is compared with
    the command's source; a contract asset is any file of the five kinds.

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
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [contract asset](#contract-asset): A contract asset is one file in an owning module's folder of a unit's contracts/ version folder; a
    contract is the binding interface its assets state together.

### contract asset

One file in an owning module's folder of a unit's contracts/ version folder, whose path names the real file it constrains and whose name
picks its kind — a fragment, a schema, a sample payload, or a command contract.

- **Defined by:** [ADR-REPO-CONTRACT-CONTRACTASSET](repository/api-contracts.md#rule-adr-repo-contract-contractasset)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [command contract](#command-contract): A command contract is the one asset kind that states a command's call interface and is compared
    with the command's source; a contract asset is any file of the five kinds.
  - [contract](#contract): A contract asset is one file in an owning module's folder of a unit's contracts/ version folder; a contract is
    the binding interface its assets state together.
  - [published artifact](#published-artifact): A published artifact is a file one stage produces and a later stage consumes within a run; a
    contract asset is a checked-in file that states what the repository boundary requires, frozen with its unit's release.

### contract language

The notation a command contract is written in — YAML with one string per parameter (type, mandatory, default, pipeline) and an output type,
over a closed type set whose defaults are declared once on the ContractCommand type.

- **Defined by:** [ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE](repository/command-contracts.md#rule-adr-repo-cmdcontract-contractlanguage)
- **Realized by:** type `Catzc.Base.Contracts.ContractCommand`
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [file language](#file-language): A file language is the kind of text a file holds, named by its extension; the contract language is a
    notation inside one YAML file, not a file language of its own.
  - [implementation language](#implementation-language): An implementation language is the file language a command's source is written in;
    the contract language is the notation its call interface is stated in.

### convention relation

A relation no file writes but a declaration implies — a test to its subject, a file to its comment page, a module to a dependency.

- **Defined by:** [ADR-REPO-LINKS-CONVENTIONSAREDERIVED](repository/links-in-repository.md#rule-adr-repo-links-conventionsarederived)
- **Realized by:** function `Get-ConventionEdge`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [relation](#relation): A relation is written in a file, as a link or a docs edge; a convention relation is derived from a declaration on
    every run.

### decision record

One record of the DRS, of exactly one registered record kind, stating its rules and why.

- **Defined by:** [ADR-REPO-DRSCODE-DECISIONRECORDSSYSTEM](repository/drs-code-language.md#rule-adr-repo-drscode-decisionrecordssystem)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

### decision records system

The DRS: the one system that holds every decision record, its index and its registry, under docs/drs/.

- **Defined by:** [ADR-REPO-DRSCODE-DECISIONRECORDSSYSTEM](repository/drs-code-language.md#rule-adr-repo-drscode-decisionrecordssystem)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

| Avoid        | Say instead |
| ------------ | ----------- |
| `adr system` | the DRS     |

### deck file

The `deck.md` of a deck folder — the deck's title and its sections, beside the slide files it gathers.

- **Defined by:** [ADR-REPO-SLIDES-SLIDEFILE](repository/slides-as-markdown.md#rule-adr-repo-slides-slidefile)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Slides/configs/glossary.yml`
- **Contrasts:**
  - [slide file](#slide-file): The deck file names the deck's title and sections; a slide file is one slide of it.

### depended-on contract

A contract an outside platform expects of our files and calls, such as GitHub reading a workflow file; it follows the platform, so a
platform change is a new draft.

- **Defined by:** [ADR-REPO-CONTRACT-BINDINGINTERFACE](repository/api-contracts.md#rule-adr-repo-contract-bindinginterface)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [provided contract](#provided-contract): A depended-on contract is what an outside platform expects of our files and calls, and it
    follows that platform; a provided contract is a promise to a consumer, kept while the consumer pins that version of its unit.

### diagram declaration

A diagram's one source, `<name>.drawio.yml` beside its `<name>.drawio.png` — a description, what the diagram shows in the kit's closed
vocabulary, and where a moved cell sits; put renders it into the drawing and get reads the drawing back into it.

- **Defined by:** [ADR-REPO-SLIDES-DECLARATION](repository/slides-as-markdown.md#rule-adr-repo-slides-declaration)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Slides/configs/glossary.yml`
- **Contrasts:**
  - [slide file](#slide-file): A diagram declaration is yml the kit renders into a draw.io model; a slide file is markdown prose a pattern
    fills.

### domain

A group of decision records — one docs/drs/ subfolder — that drs.yml declares with its role and the domains it depends on.

- **Defined by:**
  [ADR-REPO-FOLDERS-DOCUMENTATIONMARKDOWNONLY](repository/conventional-folders.md#rule-adr-repo-folders-documentationmarkdownonly)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Forms:** `ADR domain`, `record domain`, `thesis domain`, `principles domain`, `process domain`, `design domain`, `flow domain`,
  `automation domain`, `bcl domain`, `pwsh domain`, `configuration domain`, `ado domain`, `github domain`, `azure domain`,
  `repository domain`, `research domain`, `axioms domain`, `architecture domain`, `implementation domain`, `optimisable domain`,
  `owning domain`, and the bare `domain`
- **Contrasts:**
  - [language zone](#language-zone): A language zone is one of the design, test, and live registers of identities; a decision-record domain
    groups decision records.
  - [responsibility domain](#responsibility-domain): A responsibility domain is what one repository is accountable for; a decision-record
    domain groups decision records.

| Avoid            | Say instead              |
| ---------------- | ------------------------ |
| `problem domain` | the problem catzc solves |

### domain rules

The repository's conventions and its decision records and the rules they state.

- **Defined by:** [ADR-REPO-VOCAB-DOMAINRULES](repository/controlled-vocabulary.md#rule-adr-repo-vocab-domainrules)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

| Avoid         | Say instead              |
| ------------- | ------------------------ |
| `house rules` | domain rules / DRS rules |

### edge

One named relation under the edges part of a meta block, from the file to a rule code, a file or a URL, such as defines, cites, links, page
or test, written on its source only.

- **Defined by:** [ADR-REPO-FILEMETA-FILEISNODE](repository/file-meta.md#rule-adr-repo-filemeta-fileisnode)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [place facts](#place-facts): The place facts are properties of the file as a node, read from the repository's configuration; an edge is
    a named relation leaving the file, read from its text.

### endpoint

One end of a relation as the facets derived from the declarations (class, aspect, track, track type, module), never read from a file's head.

- **Defined by:** [ADR-REPO-LINKS-ENDPOINTSAREFACETS](repository/links-in-repository.md#rule-adr-repo-links-endpointsarefacets)
- **Realized by:** type `LinkEndpoint`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`

### facet

One of several parallel views of, or checks on, the same thing, none above another — a build facet (types, load, parity, manifest) or a
module facet (disk, session).

- **Defined by:** [ADR-REPO-VOCAB-FAMILYFORMS](repository/controlled-vocabulary.md#rule-adr-repo-vocab-familyforms)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Forms:** `build facet`, `types facet`, `load facet`, `parity facet`, `manifest facet`, `module facet`, `disk facet`, `session facet`,
  `runtime facet`, and the bare `facet`, with its verb forms
- **Contrasts:**
  - [layer](#layer): A facet is one of several parallel views of, or checks on, the same thing; a layer is one level of a stack.

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
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [file language](#file-language): A file language groups the extensions of one kind of text; a file type is the single extension of one
    file.
  - [role](#role): A file type is how a file's name ends; a role is the part the file plays.
  - [subkind](#subkind): A file type is how a file's name ends; a subkind is a narrower role, whatever the name.

### imprint step

A step the file-language registry lists under imprint, global or for one language, which Format-Code runs after the formatter to write one
derived fact into the file.

- **Defined by:** [ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

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
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Forms:** `language zone`, `design zone`, `test zone`, `live zone`, `landing zone`, `dns zone`, `availability zone`, and the bare `zone`
- **Contrasts:**
  - [domain](#domain): A language zone is one of the design, test, and live registers of identities; a decision-record domain groups
    decision records.
  - [file language](#file-language): A file language is the kind of text one file holds, named by its extension; a language zone is a
    register of identities.

### layer

One stratum of a structure, always qualified — one of the five layers of the automation (automation, contract, language, engine, importer;
ADR-AUTO-LAYERS-REALISENEVERREDEFINE), or a globset layer (module, fileset).

- **Defined by:** [ADR-REPO-VOCAB-FAMILYFORMS](repository/controlled-vocabulary.md#rule-adr-repo-vocab-familyforms)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Forms:** `contract layer`, `language layer`, `engine layer`, `importer layer`, `installer layer`, `config layer`, `configuration layer`,
  `Azure layer`, `tooling layer`, `YAML layer`, `module layer`, `template layer`, `templating layer`, `vendor layer`, `abstraction layer`,
  `analyzer layer`, `compatibility layer`, `mapping layer`, `serialization layer`, `base layer`, `design layer`, `spelling layer`,
  `Pester layer`, `pip layer`, `path layer`, `support layer`, `doctrine layer`, `globset layer`, `fileset layer`, `cross layer`,
  `ADR layer`, `AUTO layer`, `shaping layer`, and the bare `layer`, with its verb forms
- **Contrasts:**
  - [facet](#facet): A facet is one of several parallel views of, or checks on, the same thing; a layer is one level of a stack.

### link direction

Which way a relation points, from the file that writes it to the file it names, judged by the rows of link-directions.yml.

- **Defined by:** [ADR-REPO-LINKS-EVERYLINKHASADIRECTION](repository/links-in-repository.md#rule-adr-repo-links-everylinkhasadirection)
- **Realized by:** function `Test-LinkDirections`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`

### markdown link

A link inside a rendered .md file, written relative to that file so it resolves the same on GitHub and in VS Code.

- **Defined by:** [ADR-REPO-LINK-KINDBYFILE](repository/markdown-links.md#rule-adr-repo-link-kindbyfile)
- **Realized by:** function `Test-Links`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [code link](#code-link): A code link lives in a comment of a non-markdown file and is repository-rooted; a markdown link lives in a .md
    file and is relative to it.
  - [relation](#relation): A markdown link is one kind of relation, the one written in a .md file; a relation is any of the three kinds.

### meta block

The facts the tooling owns about one tracked file, written into the file's carrier, which is the reserved front-matter key catzc of a
Markdown file, at the top level or nested at the key path its carrier declares, or the meta head of a code file.

- **Defined by:** [ADR-REPO-FILEMETA-HEADPOLICY](repository/file-meta.md#rule-adr-repo-filemeta-headpolicy)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [meta head](#meta-head): The meta block is the facts in any file; the meta head is the form they take in a code file.
  - [meta kind](#meta-kind): The meta block is the block in one file; a meta kind is the registry entry that says what goes in that block
    across files.

### meta head

The leading comment of a code file, whose text is a front matter document with the catzc block, that holds the file's derived facts, so it
is the form a meta block takes in a C# or PowerShell file.

- **Defined by:** [ADR-REPO-CODEMETA-CODEFILEHEAD](repository/code-file-meta.md#rule-adr-repo-codemeta-codefilehead)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [materialization](#materialization): Materialization says when a resource comes into being and how long it holds; a meta head is where a
    generated file shows its commit key, body_sha.
  - [meta block](#meta-block): The meta block is the facts in any file; the meta head is the form they take in a code file.

### meta kind

One entry of the meta-kind registry, naming a kind of derived fact imprinted into files, or of config contribution gathered out of Markdown
files, with the files it applies to, the keys it owns and, for a gather kind, the config it feeds.

- **Defined by:** [ADR-REPO-FILEMETA-METAKIND](repository/file-meta.md#rule-adr-repo-filemeta-metakind)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [meta block](#meta-block): The meta block is the block in one file; a meta kind is the registry entry that says what goes in that block
    across files.
  - [role](#role): A role is the part one file plays; a meta kind is a registry entry that says which derived fact goes into a head.

### model floor

The lowest model that performs a capability's steps reliably; no robot that preloads the capability runs below it.

- **Defined by:** [ADR-REPO-AGENTS-NAMEDMODEL](repository/agent-definitions.md#rule-adr-repo-agents-namedmodel)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

### pattern

One `patterns/<name>.html` file of the slides kit — a section in the slide format whose placeholders name the fields it takes and which are
required; the layout of one kind of slide.

- **Defined by:** [ADR-REPO-SLIDES-PATTERN](repository/slides-as-markdown.md#rule-adr-repo-slides-pattern)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Slides/configs/glossary.yml`

### place facts

The facts under the immutable part of a meta block, which are what the repository's own configuration makes of a file's location, such as
its path, kind, language, track and module, each read from a registry and never from the file's text.

- **Defined by:** [ADR-REPO-FILEMETA-FILEISNODE](repository/file-meta.md#rule-adr-repo-filemeta-fileisnode)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [edge](#edge): The place facts are properties of the file as a node, read from the repository's configuration; an edge is a named
    relation leaving the file, read from its text.

### provided contract

A contract an outside consumer may rely on — the repository's only public API, kept while a consumer pins that version of its unit.

- **Defined by:** [ADR-REPO-CONTRACT-BINDINGINTERFACE](repository/api-contracts.md#rule-adr-repo-contract-bindinginterface)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [depended-on contract](#depended-on-contract): A depended-on contract is what an outside platform expects of our files and calls, and it
    follows that platform; a provided contract is a promise to a consumer, kept while the consumer pins that version of its unit.
  - [pin](#pin): A pin is the consumer's explicit choice of a version that crosses the repository boundary; a provided contract is the
    promise catzc keeps under that pin.

### record kind

The first segment of a decision record code (ADR, TDR, PDR, WDR, DDR, FDR or RDR), registered in drs.yml; together the XDR kinds.

- **Defined by:** [ADR-REPO-DRSCODE-DECISIONRECORDSSYSTEM](repository/drs-code-language.md#rule-adr-repo-drscode-decisionrecordssystem)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

### relation

One file pointing at another tracked file — a markdown link, a code link or a docs edge; a string, an image or a URL is none.

- **Defined by:** [ADR-REPO-LINKS-EVERYLINKHASADIRECTION](repository/links-in-repository.md#rule-adr-repo-links-everylinkhasadirection)
- **Realized by:** type `LinkRelation`
- **Source:** `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [convention relation](#convention-relation): A relation is written in a file, as a link or a docs edge; a convention relation is derived
    from a declaration on every run.
  - [markdown link](#markdown-link): A markdown link is one kind of relation, the one written in a .md file; a relation is any of the three
    kinds.

### robot

A sub-agent in its minimal form — a body of at most the roof's lines on a named model, loading shared know-how from capabilities instead of
carrying it.

- **Defined by:** [ADR-REPO-AGENTS-ROBOTBODYLIMIT](repository/agent-definitions.md#rule-adr-repo-agents-robotbodylimit)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`

### role

The part a file plays, such as a test, a function, a config or a decision record, named by the file-kinds registry and never by the file's
language, track or module.

- **Defined by:** [ADR-REPO-FILEMETA-ROLE](repository/file-meta.md#rule-adr-repo-filemeta-role)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [file language](#file-language): A file language is the sort of text a file holds, named by its extension; a role is what the file is
    for.
  - [file type](#file-type): A file type is how a file's name ends; a role is the part the file plays.
  - [meta kind](#meta-kind): A role is the part one file plays; a meta kind is a registry entry that says which derived fact goes into a
    head.
  - [subkind](#subkind): A subkind is one narrower role under a role, and a file has at most one; a role is the part itself.
  - [track](#track): A track is the cluster a file lives in; a role is the part it plays, wherever it lives.
  - [track type](#track-type): A track type is the sort of cluster a file lives in; a role is the part the file plays, wherever it lives.

### scope

What something reaches, always qualified — a PowerShell scope (module, script, global), an install scope (user, machine), or a selection
scope (verify, scan, content).

- **Defined by:** [ADR-REPO-VOCAB-FAMILYFORMS](repository/controlled-vocabulary.md#rule-adr-repo-vocab-familyforms)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
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
  - [diagram declaration](#diagram-declaration): A diagram declaration is yml the kit renders into a draw.io model; a slide file is markdown
    prose a pattern fills.

### source

Where something comes from, always qualified — a source mode, run, or tree; a glossary source; a type, authored, vendor, or dot source.

- **Defined by:** [ADR-REPO-VOCAB-FAMILYFORMS](repository/controlled-vocabulary.md#rule-adr-repo-vocab-familyforms)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
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
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
- **Contrasts:**
  - [file type](#file-type): A file type is how a file's name ends; a subkind is a narrower role, whatever the name.
  - [role](#role): A subkind is one narrower role under a role, and a file has at most one; a role is the part itself.

### workstream

One labeled section of a plan's work breakdown (`out/plan-*.md`) — its own `### W<n>:` heading, order, and gate — that lands as one change.

- **Defined by:** [ADR-REPO-OUTDIR-PLANNOTES](repository/dedicated-output-directory.md#rule-adr-repo-outdir-plannotes)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `pwsh/Catzc.Base.Docs/configs/glossary`
