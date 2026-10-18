# File meta: the repository knows the facts, a head only shows them

```text
File meta: every fact about a file is derived from the repository, never read from the file's head.

1  facts         path, kind, language, track, module, edges, comments: each from a registry, git, the disk or the body
2  head          an optional projection of those facts into the file's carrier, written by a tool, never an input
3  policy        a config with sensible defaults decides which files must, may or must not carry a head
4  repo tools    Test-Spelling, Format-Code, Format-MarkdownTitle, Format-FileMeta, Export-Comments: whole-repository runs
5  Sync-FileMeta one call that brings one file up to the head its policy says it has, then stops
6  tight loops   Assert- and Test- guards, never the file tool

Explains ADR-REPO-FILEMETA, ADR-REPO-CODEMETA and ADR-REPO-COMMENTS, and the direction they are moving in.
```

A file in this repository is more than its text. It has a place (a path, a module, a track), a role (its kind), a language, things it points
at (the rules it cites, the pages it links, its comment page, its test) and a status in git. Today most of those facts are also written into
the file, in its **meta block**: the `catzc` front-matter key of a Markdown file, the meta head of a code file, a property of a JSON file
([ADR-REPO-FILEMETA#1](../adr/repository/file-meta.md#rule-adr-repo-filemeta1)). This article describes that state and the rule it is moving
to: **every fact is verifiable without ever reading a head**, so every command works the same whether a file has one or not.

## The principle

A fact about a file is known from the repository. A head is a picture of those facts, taken by a tool, for a reader who should not have to
run anything to see them. It is never the source:

- **No command reads an imprinted fact back.** A gate that wants a file's kind asks the file-kinds registry, never the `kind` key. A tool
  that wants a file's citations scans its body, never its `cites` edge.
- **Removing every head changes no verdict.** Every gate, generator and resolver gives the same answer on a tree with all heads stripped.
- **A head is configured, not assumed.** Whether a file carries a head is a policy with sensible defaults declared once
  ([ADR-AUTO-DEFAULT#6](../adr/automation/sensible-defaults.md#rule-adr-auto-default6)), not a property of the file class alone.

Three things sit in front matter today and must be told apart, because only the first is a fact:

| Part                              | Owner                    | May a command read it?                                                               |
| --------------------------------- | ------------------------ | ------------------------------------------------------------------------------------ |
| `catzc.immutable`, `catzc.edges`  | the imprint (derived)    | never: recompute it                                                                  |
| `catzc.config`                    | the author               | today yes; function help moves to the comment page, see the decisions below          |
| foreign keys (`name`, `tools`, …) | another tool, the vendor | only the tool that owns them, such as the agent tooling for a `.claude/agents/` file |

## Where each fact comes from today

Every imprinted kind is an entry of `automation/Catzc.Base.QualityGates/configs/file-meta.yml` with a `Get-<Kind>FileMetaFact` processor
([ADR-REPO-FILEMETA#2](../adr/repository/file-meta.md#rule-adr-repo-filemeta2),
[ADR-REPO-FILEMETA#4](../adr/repository/file-meta.md#rule-adr-repo-filemeta4)). Almost all of them already derive from outside the head:

| Fact                                        | Source                                       | Head-free today?                                                                           |
| ------------------------------------------- | -------------------------------------------- | ------------------------------------------------------------------------------------------ |
| `path`, `folder`, `name`, `filetype`        | the path                                     | yes                                                                                        |
| `kind`, `subkind`                           | `file-kinds.yml` by glob                     | yes                                                                                        |
| `language`                                  | `languages.yml` by extension                 | yes                                                                                        |
| `track`, `tracktype`, `vendor`              | the tracks registry                          | yes                                                                                        |
| `module`, `moduletype`, `catzc_bundle`      | the module-types and exporter registries     | yes                                                                                        |
| `visibility`                                | the module's `private/` folder               | yes                                                                                        |
| `repo_status`                               | the file class (`locked_classes`)            | yes; the git-only states come from `Get-RepoStatus` and are never written                  |
| `generator`, `source`                       | the writer, at write time                    | no: a reader tells generated from authored by the `generator` key, a head read             |
| `with_body_sha`                             | a hash of the body                           | yes: recomputed and compared by `Get-GeneratedStampDrift`                                  |
| `defines`, `links`                          | the Markdown body                            | yes                                                                                        |
| `cites`                                     | the body and the comment page                | not quite: for `held_classes` it also keeps what the head already holds                    |
| `page`, `test`                              | the `relative-edges` path rules and the disk | yes                                                                                        |
| comments (a long comment lives on its page) | `comments.yml`, the code and its page        | yes ([ADR-REPO-COMMENTS#1](../adr/repository/comments-in-docs.md#rule-adr-repo-comments1)) |

## The repository-wide tools

Each tool runs over the repository, or over the paths given, and each is idempotent. None of them is a single-file tool, though most take a
`-Path`.

- **`Test-Spelling`** runs cspell over the known file types with the one dictionary at `cspell.yml`. It spells the whole text, head
  included, so an imprinted path or help text in a head is spelled like the body. It is a gate only: it never writes.
- **`Format-Code`** formats each file with the formatter engine `languages.yml` names for its language, and `Test-Formatting` fails when a
  run would change anything. Markdown is formatted here, at 140 columns; `Test-Markdownlint` lints it, and `Format-MarkdownTitle` brings the
  H1 and the headings into normal form. The imprint is stable under these formatters, so the two never undo each other
  ([ADR-REPO-FILEMETA#3](../adr/repository/file-meta.md#rule-adr-repo-filemeta3)).
- **`Format-FileMeta`** imprints `immutable` and `edges` into every in-scope file, and `Test-FileMeta` fails any drift and any key no kind
  owns. Its scope is `Get-FileMetaScope`: the files git tracks, that the carrier registry gives a carrier, that some kind selects, less
  those `.gitattributes` exempts ([ADR-REPO-FILEMETA#5](../adr/repository/file-meta.md#rule-adr-repo-filemeta5)). Of 5172 tracked files,
  about 3900 carry a block today, authored or generated alike.
- **`Export-Comments`** moves every long comment into the file's comment page, and `Test-Comments` checks that each page section still names
  a code line.
- **`Format-GeneratedFileHead`** is the one function every writer calls to compose a generated file's head; the imprint leaves those files
  alone ([ADR-REPO-FILEMETA#7](../adr/repository/file-meta.md#rule-adr-repo-filemeta7)).

## Where code reads a head today

These are the places the principle does not yet hold. Each is a finding against the target, not a defect against the ADRs as written:

- **`Get-AdrCodesFileMetaFact`** keeps, for the `held_classes`, the codes the head's `cites` edge already lists, so a fact feeds on its own
  picture.
- **`Get-AdrUsageRow`** reads the `cites` and `links` edges out of the head to count ADR usage, instead of scanning the body.
- **Generated or authored** is told by the `generator` key. Head-free, it is the writer registry (`generated-files.yml`) and the
  `linguist-generated` attribute that say it.
- **`Get-HelpHeadFinding`** and every reader of function help read the synopsis, parameters and examples from the head's `config` part
  ([ADR-REPO-CODEMETA](../adr/repository/code-file-meta.md)). That is authored content, not a fact, but it lives in a head; it moves to the
  file's comment page.
- **`Read-SlideFile`** and the gather kinds (`Get-<Kind>MarkdownConfigContribution`) read authored values from `catzc.config`.
- **`Test-AgentDefinitions`** reads an agent's foreign front matter (`name`, `model`, `tools`). That one stays: the vendor reads the same
  keys, so the file cannot run without them.

## The target: a head policy with sensible defaults

Whether a file carries a head becomes one config entry per file class, read with the same resolution order as every setting: the caller's
value, else the config, else the default declared on the type
([ADR-AUTO-DEFAULT#6](../adr/automation/sensible-defaults.md#rule-adr-auto-default6)). A policy has three values: `required`, `optional` and
`forbidden`. The defaults proposed here:

| Files                                                                   | Head        | Why                                                                                       |
| ----------------------------------------------------------------------- | ----------- | ----------------------------------------------------------------------------------------- |
| tracked **and** generated                                               | `required`  | the head says which writer and which source to edit instead, and stamps the composed body |
| agent and capability definitions (`.claude/agents/`, `.claude/skills/`) | `required`  | the vendor reads the front matter; the file does not work without it                      |
| authored source files (code, config, docs)                              | `forbidden` | every fact is derivable, so a head is a second statement of it that can drift             |
| untracked and gitignored output (`out/`)                                | `optional`  | nothing checks it                                                                         |

Because no command reads an imprinted fact, a policy change is safe in both directions: switching a class from `forbidden` to `required`
adds heads and changes no verdict, and switching it back removes them and changes none either. The gate becomes: a file whose head does not
match its policy, absent where required, present where forbidden, or drifted from the facts, is a finding.

## The single-file tool: Sync-FileMeta

The repository-wide tools stay what they are. What is missing is one call, `Sync-FileMeta -Path <file>`, that **brings one file up to date
with the head it is configured to have**: after an edit, a move or a rename, on the file at hand, without a repository run.

What it does, in order, for one path:

1. Resolve the file's facts from the registries, git and the disk: the same processors `Format-FileMeta` calls, never reading the head.
2. Resolve the file's head policy.
3. Write the head (`required`, or `optional` with a head already there), replace a drifted one, or strip it (`forbidden`). The `config` part
   and foreign keys are kept as written; an unowned key is reported and the file is left alone, as `Format-FileMeta` does.
4. Run the file's own formatter and title normalisation on the result, so the file leaves in the form `Test-Formatting` expects.
5. Report what changed, or with `-DryRun` what would.

What it is not:

- **Not a loop primitive.** It loads the registries and the ADR citation map, so it costs about what one import of the config costs. A tight
  loop asks an `Assert-` or `Test-` guard the one question it needs, and calls the file tool once at the end, if at all.
- **Not a gate.** `Test-FileMeta` and the other gates stay the verdict; the file tool only writes.
- **Not a second engine.** It reuses `Invoke-FileMetaEngine` with one entry, so there is one living version of the imprint
  ([ADR-PRIN-ONELIVE](../adr/principles/one-living-version.md)).

One gap shows up already: `Get-FileMetaScope` starts from `Get-GitTrackedPath`, so a file that is not yet tracked is out of scope and
`Format-FileMeta -Path <new file>` leaves it alone. The file tool takes its one path as given and asks git only for the `tracked` fact the
policy needs.

## Decisions

Decided on 2026-10-18:

- **Function help lives on the comment page.** An authored code file carries no head at all, so its synopsis, description, parameters,
  outputs and examples move from the head's `config` part to the file's comment page, the page `comments.yml` resolves for the path
  (`PageFor`), which is found without reading a head. `Get-HelpHeadFinding` becomes a check of the page, and every help reader reads the
  page.
- **ADR-REPO-FILEMETA#1 is restated, and one rule is added.** Rule 1 says a file carries a block exactly as its head policy says,
  `required`, `optional` or `forbidden`, with the defaults declared on the policy's type. The new rule says no command reads an imprinted
  fact back, so stripping every head changes no verdict.
- **The single-file command is `Sync-FileMeta`.** It sits beside `Format-FileMeta` and `Test-FileMeta`.

- **A comment page is an authored file, and help is its `## help` section.** The page is already where a code file's prose lives:
  `Export-Comments` only appends new `## comment:<n>` sections, and a section a person edits stays as edited
  ([ADR-REPO-COMMENTS#2](../adr/repository/comments-in-docs.md#rule-adr-repo-comments2)). So the page leaves `locked_classes` and carries no
  body hash, no `generator` and, as authored docs, no head. Help is one section in a fixed shape: `### synopsis`, `### description`,
  `### parameter <Name>` in `param()` order, `### outputs` and `### example <n>`, which `Export-Comments` never writes or reorders. Today's
  help moves out of the heads through one tested step of `Export-Comments`, as the comments did.

## Still open

- **`Get-Help` finds nothing in the code file.** Comment-based help stays forbidden, so in-shell help reads the page, through the reference
  tooling or a help provider.

## See also

- [File meta](../adr/repository/file-meta.md): the carriers, the meta-kind registry, place facts and edges.
- [Code file meta](../adr/repository/code-file-meta.md): the meta head of a code file and the help in it.
- [Comments in docs](../adr/repository/comments-in-docs.md): long comments on their page.
- [Sensible defaults](../adr/automation/sensible-defaults.md): the one resolution order of a setting.
