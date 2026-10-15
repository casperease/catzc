# docs/adr/repository/uniform-formatting.md

`ADR: Uniform formatting — the whole repository, one mechanical standard`

## Rules: ADR-REPO-FORMAT

### Rule ADR-REPO-FORMAT:1

Let the tools format your code; never hand-format. `.editorconfig` is the single source of truth for text formatting, across languages —
configure your editor to honour it, and let each language's analyzers catch the rest.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-REPO-FORMAT:2

Do not debate formatting. If a choice must change, change `.editorconfig` (and the relevant analyzers and tests) and reformat every affected
file in one sweep — never adopt a new style partially.

- [Decision](#decision)

### Rule ADR-REPO-FORMAT:3

Every text file in the repository, of every type, meets the cross-language baseline defined in `.editorconfig`'s `[*]` section (encoding,
line endings, indentation kind, trailing-whitespace handling, and final newline).

- [The cross-language baseline](#the-cross-language-baseline)

### Rule ADR-REPO-FORMAT:4

The baseline is the floor, not the ceiling. Indent width and line-length limits are per-language `.editorconfig` sections, and each language
layers its own formatting rules on top. No file falls below the baseline.

- [Per-language layers](#per-language-layers)

### Rule ADR-REPO-FORMAT:5

An artifact the build generates — a module manifest, a compiled cache — is emitted in canonical, formatter-stable form: deterministic
ordering, tool-computed layout, and the `.editorconfig` baseline, so every build of one commit is byte-identical and the artifact diffs
cleanly across commits. It is never hand-formatted, not even inside a generator's string template.

- [Generated artifacts are canonical too](#generated-artifacts-are-canonical-too)

### Rule ADR-REPO-FORMAT:6

Every git-tracked Markdown file opens — after any YAML front matter — with the H1 `# <repository-relative path>`, e.g.
`# docs/references/infrastructure/foundation.md`, and nothing else on that line. `Format-MarkdownTitle` writes it — a replaced title's
wording is kept between single backticks as the body's first line, so no authored text is lost — and `Test-MarkdownTitle` checks it. The
scope follows the repository's own file classes: every tracked `.md` file except those `.gitattributes` marks `linguist-vendored`,
`linguist-generated`, `catzc-fixture` (the test fixture trees), or `catzc-contract` (the contract assets,
[ADR-REPO-CONTRACT#6](api-contracts.md#rule-adr-repo-contract6)), and those it marks `-catzc-path-title` (the repository landing page, which
keeps its own title). A new exception is declared in the `.gitattributes` source, never in a list of the gate's own.

- [Markdown titles are paths](#markdown-titles-are-paths)

### Rule ADR-REPO-FORMAT:7

A Markdown heading below the title is plain words with an anchor unique in its document. A trailing parenthesized group that holds only code
spans and separators — a file name, a path, a citation — sits on its own line directly below the heading instead, groups joined by `·` and a
citation written as a link to its ADR; code that is the heading's subject stays in it. In a `dora-explains.md` file, each entry's DORA
paragraph is a `>` blockquote, so paraphrased research reads as grey text. `Format-MarkdownTitle` writes this form and `Test-MarkdownTitle`
checks it.

- [Headings are plain words](#headings-are-plain-words)

### Rule ADR-REPO-FORMAT:8

Each file language's formatter is configured, not coded: its entry in the file-language registry (`languages.yml`) names the formatter
engine that formats its files, or states in `no_formatter:` why it has none. `Format-Code` runs the engines over every tracked file except
vendored code and contract assets (`catzc-contract`, whose bytes a contract check compares and a released version freezes,
[ADR-REPO-CONTRACT#5](api-contracts.md#rule-adr-repo-contract5)), and `Test-Formatting` checks the same entries — there is no formatting
command per language and no list of formatters in a check (ADR-PRIN-CONFIG#1).

- [Formatting is configured per language](#formatting-is-configured-per-language)

### Rule ADR-REPO-FORMAT:9

The `derived` part of a Markdown file's meta block ([ADR-REPO-MDMETA#1](markdown-meta.md#rule-adr-repo-mdmeta1)) is formatter output like
the title: `Format-MarkdownMeta` writes it in canonical, prettier-stable form, byte-identical on every run, and `Test-MarkdownMeta` checks
it, over the same file class as the title (ADR-REPO-FORMAT#6). A hand edit to a derived value is overwritten.

- [Markdown meta is imprinted](#markdown-meta-is-imprinted)

## Context

The repository holds many file types — PowerShell (`.ps1`/`.psm1`/`.psd1`), Bicep, YAML pipelines, Markdown, JSON, C#. When formatting is
inconsistent, every pull request carries two kinds of change: the actual logic change and incidental formatting noise. Reviewers must
mentally separate the two, and they will miss real changes hidden in reformatting. This is the single biggest waste of review time in any
codebase without enforced formatting — and it is not language-specific, so the fix must not be either.

Inconsistent formatting also poisons `git blame`: a reformatted line shows the reformatter as the last author, not the person who wrote the
logic. `git diff` becomes noisy, `git log -p` unreadable, and bisecting across formatting changes painful.

The fix is simple and repo-wide: pick one standard, enforce it mechanically for every file type, and never discuss it again. The specific
choices matter far less than that every file — whatever its language — obeys the same baseline.

### The cross-language baseline

`.editorconfig`'s `[*]` section defines the baseline every text file meets, regardless of language — it is the source of truth for these
values; the bullets below give the reasoning, not a second copy to maintain:

- **Encoding: UTF-8 without BOM.** BOM breaks `git diff`, Unix utilities, and some editors.
- **Line endings: LF.** Consistent across Windows, macOS, and Linux.
- **Indentation: spaces, not tabs.** (Width is per-language — see below.)
- **Trailing whitespace: trimmed.** (Markdown is the one exception — trailing spaces there are significant line breaks.)
- **Final newline: required.**

`.editorconfig` is read by VS Code, JetBrains, vim, and most editors without plugins, so every contributor's editor applies the baseline on
save.

### Per-language layers

The baseline is the floor. Each language adds its own `.editorconfig` section (indent width, line length) and, where it has one, a formatter
engine and an analyzer. The exact per-language values live in `.editorconfig`, and which engine formats each language lives in the
file-language registry, `automation/Catzc.Base.Languages/configs/languages.yml`; this ADR restates neither. Beyond the engines, PowerShell
is governed by `PSScriptAnalyzerSettings.psd1` (see [powershell-formatting](../pwsh/powershell-formatting.md)), Markdown by
`.markdownlint.yml`, and pipeline YAML by the naming-and-placement check `Test-Pipelines`
([pipeline-naming-and-placement](../pipelines/pipeline-naming-and-placement.md)).

### Formatting is configured per language

Formatting follows [configure-not-program](../principles/configure-not-program.md): there is one formatting command, `Format-Code`, and one
adapter per formatter engine (Prettier, gofmt, ruff, PSScriptAnalyzer, dotnet format, the Bicep CLI). Which engine formats a language is one
line in the registry — `formatter: prettier` — so supporting a language on an engine the repository already runs is a configuration change,
reviewed as such, and the editor, the formatting command, and the `Test-Formatting` check all read the same line. A language with nothing to
format says why in `no_formatter:`, so a gap is a visible entry rather than a missing command. Adding a language means adding its registry
entry and its `.editorconfig` section — not a new command, and not a new formatting philosophy.

### Markdown meta is imprinted

`Derived front matter is written, not typed`

A fact that can be computed from a Markdown file and the repository sits in the file's meta block, where a reader and a tool both see it.
Because the formatter writes it in one fixed form, a rerun changes nothing and a diff never carries it as noise. The kinds of fact, the
reserved key and the subscription of each kind are in [markdown-meta](markdown-meta.md).

### `.gitattributes` and binary files

`.gitattributes` is the companion guard: it marks binary types as `binary` so end-of-line conversion never rewrites their bytes — which
would corrupt the byte-exact, hash-keyed compiled-type cache. It deliberately sets **no** `* text=auto`, so existing text files keep their
stored line endings rather than being mass-renormalized. The specific binary patterns live in `.gitattributes`. Formatting of text is
`.editorconfig`'s job; protecting binaries from EOL/diff corruption is `.gitattributes`'.

### Generated artifacts are canonical too

Some files are not hand-authored but generated by the build — the module manifests are the clearest case: the importer emits each
`<module>.psd1` from the module's files on every import. Because the same commit is built repeatedly — on every machine and in CI — the
generated bytes must be reproducible, so "let the tools format it" binds the generator too. The emitter produces canonical output directly —
keys ordered deterministically, the `=` column computed rather than hand-padded, LF endings and a final newline — and that output is
formatter-stable: running the formatter over it changes nothing. A hand-padded string template is the same hand-formatting ADR-REPO-FORMAT#1
forbids, merely moved into code; it drifts the moment a field is added and churns the diff on every build.

### Markdown titles are paths

A hand-written title is the author's guess at a name — usually the file's leaf name, which says nothing about where the document lives. The
same document is read through a generated README, a search result, a printout, or a pasted excerpt, and each of those loses the folder it
came from. A title that is the repository-relative path names the document exactly in all of them, cannot drift when the file is renamed
(the formatter rewrites it), and leaves nothing to judge, so a tool owns it like every other formatting choice. The path is plain text, with
its `.md` extension, so it can be copied straight into a link or a terminal. What the document is about is said in its first paragraph: when
the formatter replaces an authored title, that title's wording is kept below the path between single backticks, marked as the old title
rather than read as prose. The title's own backticks are dropped, since inside that one code span they would split it.

The scope reuses the classes the repository already declares instead of keeping its own: git decides what is committed (a gitignored
generated file is out, its tracked source is in), and `.gitattributes` decides what is vendored, generated, or a fixture (`catzc-fixture`
and `catzc-contract`: data on purpose, which the link tools skip too — a contract asset's bytes are what its contract check compares). The
landing page is the one file whose title is its first impression on GitHub, not a location, so it opts out with `-catzc-path-title`.

### Headings are plain words

A heading's anchor is how every other document reaches it, so the heading is written to be linked: `## Templating data model` gives
`#templating-data-model`, while the same heading with ``(`azure.yml` + `infrastructure/`) (`ADR-AZ-DATAMOD`)`` appended gives an anchor that
spells out file names and a citation code. Those trailing groups are reference material, not the heading's words, so they move to the line
below it, where they still read at a glance and a citation becomes a checked link instead of an inert code span. Only a group of code spans
and separators moves; a group holding prose, or code that is the heading's subject (`` `$Matches` — capture immediately ``), is the author's
wording and stays. Duplicate anchors are reported, never renumbered: GitHub's `-1` suffix is an anchor nobody can predict, and choosing
distinct words is the author's call. A rule's registry heading (`### Rule ADR-<CODE>:<n>`) already has the form its citations need.

Cited or paraphrased content reads grey. A `dora-explains.md` entry's opening paragraph restates DORA's research rather than this
repository's decision, so it is a blockquote — the one Markdown construct GitHub renders as muted text, and the repository's VS Code preview
style renders it the same way.

## Decision

The whole repository follows a single, mechanically enforced formatting baseline, with per-language layers on top. No exceptions, no
per-file overrides, no "I prefer it this way." The tools decide, not the contributor.

### How this is enforced

- **`.editorconfig`** — the `[*]` baseline plus per-language sections (indent width, line length). Applied by every contributor's editor on
  save.
- **`.gitattributes`** — marks binary files so EOL/diff normalization never corrupts them; deliberately no `* text=auto`.
- **Per-language analyzers** — each language's specific rules run in its own gate. For PowerShell this is PSScriptAnalyzer plus custom rules
  in the L2 tests (see [powershell-formatting](../pwsh/powershell-formatting.md)). For Markdown it is markdownlint (`.markdownlint.yml`),
  formatted by Prettier and kept in sync with it. For ADO pipeline YAML (`.yaml`) it is Prettier (the same engine as Markdown, checked by
  the `Test-Formatting` gate in an L2 test) plus the naming-and-placement quality gate `Test-Pipelines`
  ([pipeline-naming-and-placement](../pipelines/pipeline-naming-and-placement.md), an L1 integrity test) — both run in every CI test run, so
  drifted or misplaced pipeline YAML fails CI.
- **The file-language registry** — `languages.yml` names each language's formatter engine or the reason it has none, validated at load
  (`LanguagesConfig`); `Format-Code` runs the engines and `Test-Formatting` reports every file an engine would change, and an L0 integrity
  test asserts every engine the registry may name has its adapter.
- **Generated artifacts** — a build-generated artifact is emitted canonical by its generator (the module-manifest emitter), and an L2 test
  asserts the formatter is a no-op over generated output, so its bytes cannot drift from the standard.
- **Links** — `Format-Links` aligns every link mechanically (code links repository-rooted, markdown links relative, rule citations spelled
  `ADR-<CODE>#<n>`) and `Test-Links` checks them; an L2 test asserts `Format-Links` is a no-op over the tracked tree
  ([markdown-links](markdown-links.md)).
- **Markdown titles** — `Format-MarkdownTitle` titles every in-scope Markdown file with its repository path, brings its headings into normal
  form (moving trailing reference groups out, quoting `dora-explains` paragraphs, and re-pointing every link to a heading whose anchor
  changed), and `Test-MarkdownTitle` checks both, including duplicate anchors; an L1 test asserts the tracked tree has no finding.
- **Markdown meta** — `Format-MarkdownMeta` imprints the `derived` part of every in-scope Markdown file's meta block, and
  `Test-MarkdownMeta` fails any file that differs from what the formatter would write ([markdown-meta](markdown-meta.md)).

## Consequences

- Pull-request diffs contain only logic changes, for every file type — reviewers see what actually changed.
- `git blame` points at the author of the logic, not the last reformatter; `git diff` and `git log -p` stay clean.
- New contributors produce correctly formatted files from the first commit because their editor reads `.editorconfig`.
- Formatting discussions never happen — the baseline is fixed and the per-language layers are mechanical.
- Adding a file type is a small, bounded act: add its `.editorconfig` section (and formatter), inheriting the baseline.
