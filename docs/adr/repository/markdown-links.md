# docs/adr/repository/markdown-links.md

`ADR: Markdown links — relative in documents, repository-rooted out of code`

## Rules: ADR-REPO-LINK

### Rule ADR-REPO-LINK:1

A link's kind is fixed by the file it lives in. A **markdown link** lives in a rendered `.md` file; a **code link** lives in a comment of
any other tracked text file. Every function that reads or aligns links names the kinds it handles with the fixed `LinkKind` set (`Code`,
`Markdown`, or `Both`).

- [Two kinds of link](#two-kinds-of-link)

### Rule ADR-REPO-LINK:2

A markdown link is relative to its own file — no repository-root `/` and no absolute URL into this repository. Its target exists in the
repository — tracked by git, not merely present on disk — and its `#fragment` names a heading or explicit anchor of that file as GitHub
slugs it.

- [Markdown links are relative](#markdown-links-are-relative)
- [Anchors are GitHub's](#anchors-are-githubs)

### Rule ADR-REPO-LINK:3

Every ADR citation in a comment is a code link: `[ADR-<CODE>](/docs/adr/<path>.md)` for a whole ADR, or
`[ADR-<CODE>#<n>](/docs/adr/<path>.md#rule-adr-<code><n>)` for one rule. The text is the citation; the repository-rooted destination is
derived from it, so the same checked-in text resolves from any file depth wherever it is rendered as markdown.

- [Repository-rooted code links](#repository-rooted-code-links)
- [The citation decides](#the-citation-decides)
- [Code links in the editor](#code-links-in-the-editor)

### Rule ADR-REPO-LINK:4

Code links point one way: out of code, into an ADR. A comment never links to a reference article or how-to, and an ADR never links into code
— its "How this is enforced" section names the enforcing functions in code spans.

- [References point one way](#references-point-one-way)

### Rule ADR-REPO-LINK:5

A rule citation is spelled `ADR-<CODE>#<n>` everywhere — code comments, test tags, configuration, and document prose — and names a code in
the ADR index and a rule that ADR declares. The `:` form exists only in the rule's own `### Rule ADR-<CODE>:<n>` heading.

- [One citation spelling](#one-citation-spelling)

### Rule ADR-REPO-LINK:6

A string literal or configuration value that names a docs path or a citation is data, not a link: it stays a plain path or plain citation,
and outside tests it names a file or rule that exists. Nothing wraps data in link syntax.

- [Strings are data](#strings-are-data)

### Rule ADR-REPO-LINK:7

A link that leaves the repository is an absolute `https://` URL. A relative link never climbs above the repository root, and an absolute URL
into this repository appears only under `.github/`.

- [Off-repository links](#off-repository-links)

### Rule ADR-REPO-LINK:8

Links are aligned by tool, never by hand: `Format-Links` brings both kinds into canonical form — including every older spelling — and
`Test-Links` fails on any off-form, dangling, or dead link or citation. How the aligner wraps a comment line that outgrows its limit is a
configured setting with a sensible default.

- [How this is enforced](#how-this-is-enforced)

## Context

The repository's rationale lives in its ADRs, and code points at that rationale constantly — a function's help names the ADR it implements,
a comment cites the rule that forbids the obvious alternative. Those pointers are only useful while they resolve. A bare path such as
`docs/adr/automation/caching.md` in a comment is not a link anywhere: nothing renders it, nothing checks it, and when an ADR moves folder
the path silently rots. Citation codes rot the same way when a rule is renumbered or a code is renamed.

GitHub resolves links in every rendered file by one documented rule: "A relative link is a link that is relative to the current file", and
"Links starting with `/` will be relative to the repository root" — both following whatever branch is being viewed. GitHub does not render
markdown inside `.ps1`, `.cs`, or `.yml` source, so a link in a comment is text there; it renders as a link wherever that text is shown as
markdown. VS Code resolves the same two forms inside `.md` files ("Paths starting with `/` are resolved relative to the current workspace
root"); in other files its built-in link detection recognises only `http`, `https`, and `file` URLs.

### Two kinds of link

The kind of a link follows from where it lives, never from the author's choice:

| Kind              | Lives in                                                                                   | Canonical form                                                                                         |
| ----------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| **Markdown link** | a tracked `*.md` file                                                                      | relative to the file: `[reduce-variability](../principles/reduce-variability.md)`                      |
| **Code link**     | a comment in `*.ps1`, `*.psm1`, `*.psd1`, `*.cs`, `*.bicep`, `*.yml`, `*.yaml`, `*.csproj` | repository-rooted, text = citation: `[ADR-PRIN-REDUCEVAR](/docs/adr/principles/reduce-variability.md)` |

A comment is found per language family — the PowerShell tokenizer's comments, C-style `//` and `/* */` outside string literals, YAML `#`
outside quoted and block scalars, XML `<!-- -->`. Inline code spans and a help block's `.EXAMPLE` sections are literal text, never links.

### Markdown links are relative

A document links its neighbours relative to itself. The relative form resolves identically on GitHub (on any branch), in VS Code, in a
clone, and in an exported copy of the tree, and it is what every generated README link depends on
([generated-readmes](generated-readmes.md)). A repository-rooted link in a `.md` file is off-form and is aligned to relative.

GitHub, the renderer that follows these links, has only what git tracks. A gitignored file — a generated README link, a local-only draft —
satisfies a check against the disk and still 404s there, so `Test-Links` resolves a markdown link's target against the tracked files and
reports a target that exists only locally as untracked: commit it, or link its tracked source. Code links are checked against the disk:
no hosted renderer follows a comment, and the editor that does reads the working folder.

### Anchors are GitHub's

A `#fragment` names a heading as GitHub slugs it: inline markup reduced to its text, lowercased, every character other than a letter, digit,
space, hyphen, or underscore removed, and each space turned into a hyphen; duplicate headings take `-1`, `-2` suffixes; a heading inside a
fenced block is not a heading; an explicit `<a id="…">` is an anchor too. A rule's anchor is therefore `#rule-<code><n>` — the code
lowercased and the `:` dropped. markdownlint's own fragment rule (MD051) cannot reproduce these slugs, so it stays off and `Test-Links`
checks every fragment against the target's headings instead.

### Repository-rooted code links

`Code links are repository-rooted`

A comment cannot know how deep its file sits relative to `docs/adr/`, and a relative path would change with every file move. The
repository-rooted destination `/docs/adr/<path>.md` is one string from any file at any depth, and it is the tail of the file's GitHub URL on
every branch. An absolute `https://github.com/<owner>/<repo>/blob/main/…` URL is rejected: it pins one host, one owner, and one branch, so a
reader on another branch, an older commit, a fork, or an exported copy is sent to a different version of the ADR.

The leading `/` is link syntax meaning "the repository root"; the path after it is the communication form of
[path-representation](../automation/path-representation.md), not a third path form.

### The citation decides

`The citation is the source of truth`

The link text is the citation — `ADR-AUTO-ERROR#3`, or `ADR-AUTO-ERROR` for a whole ADR — and the destination is derived from it through the
ADR index, exactly as `Format-Types` derives a type's namespace from its folder. When an ADR moves, one `Format-Links` run re-points every
link to it; when a link's destination disagrees with its citation, the citation wins. A link to an ADR-folder document with no code of its
own (the index, a domain's `dora-explains`) takes the file name as its text.

### Code links in the editor

VS Code's built-in link detection does not read markdown links outside `.md` files, so a code link needs one workspace rule to be
Ctrl+clickable. The repository's VS Code registries carry it, version-controlled like every other editor setting: the extension
recommendations (`automation/Catzc.Base.VSCode/configs/vscode-extensions.yml`) recommend Regex Robin, and the workspace settings
(`vscode-settings.yml`) hold one `regexrobin.rules` entry that matches `[…](/docs/adr/<path>.md…)` in any language and opens
`file:///${workspaceFolder}/docs/adr/<path>.md`. The rule relies only on the repository's own layout — every target exists at its rooted
path in the checked-out workspace — so it works in any clone without per-user setup beyond installing the recommended extension. The
`#rule-…` fragment is not passed to the editor, which opens a file by line rather than by heading: the click lands on the ADR, and the rule
is one search away. Markdown links need no rule; the built-in markdown support already resolves them.

The same registry turns on VS Code's built-in markdown link validation (`markdown.validate.*`), so a dangling file or a bad `#fragment` in
a `.md` file shows as a warning while it is being written, and `markdown.updateLinksOnFileMove` offers to re-point relative links when a
file or folder moves. VS Code slugs headings with the same `github-slugger` algorithm GitHub uses, so its warnings agree with `Test-Links`.
Its reference-link check stays off: it reads every footnote use (`[^1]`) as an undefined reference, and markdownlint's MD052 already gates
real reference links. The editor feedback is early warning only; `Test-Links` stays the gate.

### References point one way

Code cites the decisions it implements; the decisions do not track their implementations. An ADR's "How this is enforced" section names the
enforcing functions in code spans, and a comment links only into `docs/adr/` — reference articles and how-tos are written for readers, not
cited by code.

### One citation spelling

The index defines the citation grammar: a rule is cited as `<code>#<n>` and resolves to the anchor `#rule-<code><n>`. The `:` form belongs
to the rule's own heading (`### Rule ADR-<CODE>:<n>`), which is the registry entry, not a citation of it. One spelling everywhere means one
search finds every citation of a rule, and one parser reads test tags, analyzer mappings, comments, and prose alike.

### Strings are data

A path or citation inside a string literal or a configuration value is consumed by code — a path the program opens, a test tag a filter
matches — so it keeps the plain form its consumer reads and is never wrapped in link syntax. It is still checked: outside test files, a docs
path in a string names a file that exists.

### Off-repository links

A relative link that climbs above the repository root (`../../../actions/…`) happens to resolve on GitHub as a web route, but in VS Code and
in a clone it names a file that does not exist. A link that leaves the repository is therefore an absolute `https://` URL, which resolves
everywhere. An absolute URL into this repository is the one case where the repository's identity is inherent — a badge or a workflow link
under `.github/` — and it appears nowhere else.

## Decision

Markdown links are relative to their file; code links are repository-rooted markdown links whose text is the citation code and whose
destination is derived from it. Rule citations are spelled `ADR-<CODE>#<n>` everywhere outside a rule's own heading. `Format-Links` aligns
both kinds mechanically and `Test-Links` gates them.

### How this is enforced

- **`Format-Links`** (in `Catzc.Base.QualityGates`) — the aligner and the repository-wide migration in one command. With no arguments it
  rewrites every git-tracked file in place: every ADR reference in a comment, in any older spelling, becomes a canonical code link; a rooted
  link in a `.md` file becomes relative; a prose `ADR-<CODE>:<n>` becomes `ADR-<CODE>#<n>`. `-Kind` takes the fixed `LinkKind` set.
- **Wrapping is configured** — `configs/links.yml` sets how a comment line that outgrows its limit is wrapped (`break` or `off`, default
  `break`); the limit itself comes from `.editorconfig`'s `max_line_length`. The defaults are declared once on the config type, per
  [sensible-defaults](../automation/sensible-defaults.md) (`ADR-AUTO-DEFAULT#6`).
- **`Test-Links`** — the gate. It runs the same engine read-only and fails on any off-form link, dangling target, bad anchor, unknown
  citation code or rule, link that climbs above the root, self-URL outside `.github/`, or missing docs path in a PowerShell string.
- **One engine** — both commands drive the compiled `Catzc.Base.QualityGates.LinkEngine` over the files in parallel, with the citation map
  from `Get-AdrCitationMap` (in `Catzc.Base.Docs`), so the aligner and the gate cannot disagree.
- **The VS Code registries** — `vscode-extensions.yml` recommends Regex Robin and `vscode-settings.yml` carries the `regexrobin.rules`
  code-link rule, and `vscode-settings.yml` enables markdown link validation and link updates on file moves; `Build-RootConfig` renders
  both into `.vscode/`, so every clone gets the same Ctrl+clickable code links and in-editor link warnings.

## Consequences

- Every pointer from code to a decision is checked: a moved ADR, a renamed code, or a renumbered rule fails `Test-Links` and is repaired by
  `Format-Links` rather than found by a reader.
- Comment lines grow. A code link is longer than the bare citation it replaces, so many comment lines are wrapped onto a second line; the
  aligner breaks before a link, never inside it.
- In VS Code a code link is Ctrl+clickable through the recommended Regex Robin extension and the version-controlled workspace rule; it opens
  the ADR file, not the rule's heading. Without the extension the link is plain text in the editor, but nothing breaks.
- GitHub's source view does not render markdown in code files, so there a code link is text; it is a valid link wherever the text is
  rendered as markdown, and its rooted destination reads as the file's repository path.
- Markdown fragments are checked against GitHub's slugs, so a renamed heading breaks the build instead of silently breaking its links.
