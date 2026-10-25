# File meta: the repository knows the facts, a head only shows them

```text
File meta: every fact about a file is derived from the repository, never read from the file's head.

1  facts         path, kind, language, track, module, edges, comments: each from a registry, git, the disk or the text
2  head          a projection of those facts into the file's carrier, written by a tool, never an input
3  policy        every file is format-managed; a head only where it pays: generated, or authored with docs or cites
4  repo tools    Test-Spelling, Format-Code, Format-MarkdownTitle, Format-FileMeta, Export-Comments: whole-repository runs
5  Sync-FileMeta one call that brings one file up to the head its policy says it has, then stops
6  tight loops   Assert- and Test- guards, never the file tool

Explains ADR-REPO-FILEMETA, ADR-REPO-CODEMETA, ADR-REPO-COMMENTS and ADR-REPO-HELP.
```

A file in this repository is more than its text. It has a place (a path, a module, a track), a role (its kind), a language, things it points
at (the rules it cites, the pages it links, its comment page), a test found by convention, and a status in git. Some files also carry these
facts in a **meta block**: the `catzc` front-matter key of a Markdown file, the meta head of a code file, a property of a JSON file
([ADR-REPO-FILEMETA-HEADPOLICY](../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy)). Every file on disk is format-managed,
the default is no head, and a head is printed only where it carries a fact worth its lines. No command reads a fact back from one
([ADR-REPO-FILEMETA-NOREADBACK](../drs/repository/file-meta.md#rule-adr-repo-filemeta-noreadback)), so every command works the same whether
a file has a block or not.

## The principle

A fact about a file is known from the repository. A head is a picture of those facts, taken by a tool, for a reader who should not have to
run anything to see them. It is never the source:

- **No command reads an imprinted fact back.** A gate that wants a file's kind asks the file-kinds registry, never the `kind` key. A tool
  that wants a file's citations scans its text and its comment page, never its `cites` edge.
- **Removing every head changes no verdict.** Every gate, generator and resolver gives the same answer on a tree with all heads stripped.
- **A head is the exception, not the default.** A `Format-*` run decides whether a file carries one, prints it only where it pays, and
  removes a head the policy does not call for.

Three things can sit in front matter, and only the first is a fact:

| Part                              | Owner                    | Who reads it                                                                                      |
| --------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------- |
| `catzc.immutable`, `catzc.edges`  | the imprint (derived)    | no command: each fact is recomputed                                                               |
| `catzc.config`                    | the author               | the tool the values are for, such as a capability's tooling, on a class out of the policy's scope |
| foreign keys (`name`, `tools`, …) | another tool, the vendor | only the tool that owns them, such as the agent tooling for a `.claude/agents/` file              |

## Where each fact comes from

Every imprinted kind is an entry of `pwsh/Catzc.Base.QualityGates/configs/file-meta.yml` with a `Get-<Kind>FileMetaFact` processor
([ADR-REPO-FILEMETA-METAKIND](../drs/repository/file-meta.md#rule-adr-repo-filemeta-metakind),
[ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION](../drs/repository/file-meta.md#rule-adr-repo-filemeta-subscribebyfunction)), and each derives from
outside the head:

| Fact                                        | Source                                                                                                                                                      |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `path`, `folder`, `name`, `filetype`        | the path                                                                                                                                                    |
| `kind`, `subkind`                           | `file-kinds.yml` by glob                                                                                                                                    |
| `language`                                  | `languages.yml` by extension                                                                                                                                |
| `track`, `tracktype`, `vendor`              | the tracks registry                                                                                                                                         |
| `module`, `moduletype`, `catzc_bundle`      | the module-types and exporter registries                                                                                                                    |
| `visibility`                                | the module's `private/` folder                                                                                                                              |
| `repo_status`                               | the file class (`locked_classes`); the git-only states come from `Get-RepoStatus` and are never written                                                     |
| `generator`, `source`                       | the writer registry `generated-files.yml`, on demand and never written into a head; a generated file is told by it and `linguist-generated`                 |
| `with_body_sha`                             | a hash of a tracked generated file's body, recomputed and compared by `Get-GeneratedStampDrift`; an authored file carries none                              |
| `defines`, `links`                          | the Markdown body                                                                                                                                           |
| `cites`                                     | the text and the comment page; a code with no other home is a one-line `Rests on` link beside the code it binds                                             |
| `docs`                                      | the `relative-edges` path rule and the disk                                                                                                                 |
| the test                                    | the convention, its stem under `tests/`; never an edge                                                                                                      |
| comments (a long comment lives on its page) | `comments.yml`, the code and its page ([ADR-REPO-COMMENTS-ONELINEOFINSIGHT](../drs/repository/comments-in-docs.md#rule-adr-repo-comments-onelineofinsight)) |

`Get-DrsUsage` counts the rule citations and links of the tree through the same processors, so its rows are the same with or without heads.

## Keys a head does not carry

A head shows only what a reader needs to step on from the file: a generated file's warning and, while git tracks it, its body hash, and an
authored file's `docs` and `cites` edges. Every other fact about a file is derived on demand, so a head that showed it would be a second
statement of it that can drift. These keys are never written into a head; each still has its meaning and its one source:

| Key            | Meaning                                                                                  | Derived on demand by                                                                  |
| -------------- | ---------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `repo_status`  | whether the file is generated (`locked`, edit its source) or authored, and its git state | `Get-RepoStatus`; the generated class from `generated-files.yml` and `file-kinds.yml` |
| `path`         | the repository-relative path of the file                                                 | the path itself                                                                       |
| `folder`       | the folder of the file under its module                                                  | the path                                                                              |
| `name`         | the file's name in kebab case                                                            | the path                                                                              |
| `filetype`     | the extension, which tells the sorts of file inside one language apart (ps1, psm1, psd1) | the path                                                                              |
| `subkind`      | the finer role inside a file kind                                                        | `file-kinds.yml` by glob, through `Get-FileKind`                                      |
| `language`     | the file language                                                                        | `languages.yml` by extension, through `Get-FileLanguage`                              |
| `tracktype`    | the type of the file's track (modules, pipelines, vendor-settings, …)                    | the tracks variant, through `Get-Track`                                               |
| `vendor`       | the vendor that reads the track's files                                                  | the tracks variant, through `Get-Track`                                               |
| `module`       | the module the file is placed in                                                         | `module-types.yml`, through `Get-PathModule`                                          |
| `moduletype`   | the type of that module (pwsh-folder, settings, pipeline, …)                             | `module-types.yml`, through `Get-PathModule`                                          |
| `catzc_bundle` | the smallest bundle of the catzc exporter that holds the module                          | `exporter.yml` and the module's profile, through `Get-ModuleProfile`                  |
| `visibility`   | whether a PowerShell function file is public or private                                  | the module's `private/` folder                                                        |
| `defines`      | the rules a decision record defines in its own rule headings                             | the record's `### Rule` headings, read by `Get-DrsDefinedRule`                        |
| `links`        | every link a Markdown file points out of itself                                          | the Markdown body, read by `Test-Links`                                               |

The module facts, `module`, `moduletype`, `catzc_bundle`, `tracktype` and `vendor`, are each one question to the registry that places the
module ([module-types](../drs/design/module-types.md)) or declares its track, so a head that showed them would be a second list of what the
registries say and would change on every move of a module. A Markdown file's `defines` and `links` are its text: the rules a decision record
declares are its rule headings and the rules it cites are read from its text, never counting its own rules or a placeholder named in prose,
and the links that leave a file are its body. A generated page carries only its relative edges, never a list of either.

## The head policy

Every file on disk is format-managed: a `Format-*` command covers it and decides whether it carries a head and which, and a file no format
command covers is a finding. The default is no head, and a head is printed only where a reader needs it
([ADR-REPO-FILEMETA-HEADPOLICY](../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy)):

| Files                                                          | Head                                          | Why                                                                                    |
| -------------------------------------------------------------- | --------------------------------------------- | -------------------------------------------------------------------------------------- |
| generated files tracked in git, the DRS index and glossary too | the warning and `with_body_sha`, nothing else | the warning says not to edit the file, and the hash stamps the composed body           |
| generated files git does not track                             | the warning only                              | no commit compares the body, so a stamp would say nothing                              |
| authored files with a comment page or rule codes to cite       | `docs` and `cites` only                       | the page and the rules are one step away; the test is found by its stem under `tests/` |
| every other authored file, diagram declarations included       | none                                          | every fact is derivable, so a head would be a second statement of it that can drift    |
| binaries                                                       | none possible                                 | format-managed, with no place for a head                                               |
| agent, skill and slide definitions                             | their own tool's front matter, as authored    | out of scope: another tool reads those keys                                            |

Because no command reads an imprinted fact, a policy change is safe in both directions: adding heads changes no verdict, and removing them
changes none either. `Test-FileMeta` reports a head that disagrees with the policy, absent where it calls for one, present where it does
not, or drifted from the facts, and a `Format-*` run removes a head the policy does not call for.

## Function help on the comment page

A function's help is prose an author writes, so it lives with the file's other prose: in the `## help` section of its comment page, the page
`comments.yml` names for the path
([ADR-REPO-HELP-HELPONCOMMENTPAGE](../drs/repository/function-help.md#rule-adr-repo-help-helponcommentpage)). The section has one shape,
`### synopsis`, `### description`, one ``### parameter `<Name>` `` per parameter in `param()` order, the name written as code, `### inputs`,
`### outputs`, one `### example <n>` per example and `### notes`, and `Export-Comments`, which appends the page's `## comment:<n>` sections,
never writes it ([ADR-REPO-COMMENTS-PAGEISAUTHORED](../drs/repository/comments-in-docs.md#rule-adr-repo-comments-pageisauthored)).
`Format-Code` checks it through its `ps-help` step (`Get-HelpPageFinding`): a function file with no page, a page with no synopsis, a
parameter with no subsection or a subsection for one that is gone, and an `outputs` type that disagrees with `[OutputType]` are findings.

## The repository-wide tools

Each tool runs over the repository, or over the paths given, and each is idempotent.

- **`Test-Spelling`** runs cspell over the known file types with the one dictionary at `cspell.yml`. It is a gate only: it never writes.
- **`Format-Code`** formats each file with the formatter engine `languages.yml` names for its language and runs the language's imprint
  steps, and `Test-Formatting` fails when a run would change anything. Markdown is formatted at 140 columns; `Test-Markdownlint` lints it,
  and `Format-MarkdownTitle` brings the H1 and the headings into normal form. The imprint is stable under these formatters, so the two never
  undo each other ([ADR-REPO-FILEMETA-IMPRINTEDPARTS](../drs/repository/file-meta.md#rule-adr-repo-filemeta-imprintedparts)).
- **`Format-FileMeta`** brings every in-scope file to its head policy, and `Test-FileMeta` fails any difference and any key no kind owns.
  Its scope is `Get-FileMetaScope`: the files a folder lists in git, or a file named in `-Path` as given, new or tracked, unless git ignores
  it, less those `.gitattributes` exempts ([ADR-REPO-FILEMETA-KINDSCOPE](../drs/repository/file-meta.md#rule-adr-repo-filemeta-kindscope)).
- **`Export-Comments`** moves every long comment into the file's comment page, and `Test-Comments` checks that each page section still names
  a code line.
- **`Format-GeneratedFileHead`** is the one function every writer calls to compose a generated file's head; the imprint leaves those files
  alone ([ADR-REPO-FILEMETA-COMPOSEDFILES](../drs/repository/file-meta.md#rule-adr-repo-filemeta-composedfiles)).

## The single-file tool: Sync-FileMeta

`Sync-FileMeta <file>` brings one file up to date with the head it is configured to have, after an edit, a move or a rename, without a
repository run. It runs `Format-Code` on the file with the cache off, so the formatter and the imprint steps (the head, the comments, the
help check) apply, then `Format-FileMeta` on it, so a file whose language has no formatter is covered too. It refuses a folder, a missing
path and a path outside the repository, and `-DryRun` reports what would change.

What it is not:

- **Not a loop primitive.** It loads the registries and the rule citation map on every call. A tight loop asks an `Assert-` or `Test-` guard
  the one question it needs.
- **Not a gate.** `Test-FileMeta` and the other gates give the verdict; the file tool only writes.
- **Not a second engine.** It calls the repository tools on one file, so there is one living version of the imprint
  ([PDR-ONELIVE](../drs/principles/one-living-version.md)).

## Where a head is still read

- **`Test-AgentDefinitions`** reads an agent's foreign front matter (`name`, `model`, `tools`): the vendor reads the same keys.
- **`Read-SlideFile`** reads a slide's authored `catzc.config`: slides are out of the head policy's scope, so the front matter is the slide
  tool's own.
- **`Get-GeneratedStampDrift`** compares a tracked generated file's `with_body_sha` with the hash of its body, which is the check that the
  writer's stamp still matches what it composed.

None of them reads an imprinted fact to decide something it could derive.

## What stays open

- **`Get-Help` finds nothing in a code file.** Comment-based help stays forbidden, so in-shell help would read the page through a help
  provider.

## See also

- [File meta](../drs/repository/file-meta.md): the carriers, the meta-kind registry, the head policy, place facts and edges.
- [Code file meta](../drs/repository/code-file-meta.md): the meta head of a code file.
- [Function help](../drs/repository/function-help.md): the help section of the comment page.
- [Comments in docs](../drs/repository/comments-in-docs.md): long comments on their page, and the page as an authored file.
- [Sensible defaults](../drs/automation/sensible-defaults.md): the one resolution order of a setting.
