# ADR: Uniform formatting — the whole repository, one mechanical standard

## Rules: ADR-REPO-FORMAT

### Rule ADR-REPO-FORMAT:1

Let the tools format your code; never hand-format. `.editorconfig` is the single cross-language source of truth for text formatting —
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
layers its own formatting rules on top — PowerShell in [powershell-formatting](../automation/powershell/powershell-formatting.md). No file
falls below the baseline.

- [Per-language layers](#per-language-layers)

### Rule ADR-REPO-FORMAT:5

An artifact the build generates — a module manifest, a compiled cache — is emitted in canonical, formatter-stable form: deterministic
ordering, tool-computed layout, and the `.editorconfig` baseline, so every build of one commit is byte-identical and the artifact diffs
cleanly across commits. It is never hand-formatted, not even inside a generator's string template.

- [Generated artifacts are canonical too](#generated-artifacts-are-canonical-too)

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

The baseline is the floor. Each language adds its own `.editorconfig` section (indent width, line length) and, where it has one, a
formatter/analyzer. The exact per-language values live in `.editorconfig`; this ADR does not restate them — it records only which tool
governs each language:

| Language                            | Governed by                                                                                                                                                  |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| PowerShell (`.ps1`/`.psm1`/`.psd1`) | `.editorconfig` + `PSScriptAnalyzerSettings.psd1` — see [powershell-formatting](../automation/powershell/powershell-formatting.md)                           |
| YAML (`.yml`/`.yaml`)               | `.editorconfig`; `.yaml` pipelines additionally formatted by Prettier (`Format-Pipelines`) and gated on naming/placement (`Assert-Pipelines`, ADR-PIPE-NAME) |
| JSON                                | `.editorconfig`                                                                                                                                              |
| Markdown (`.md`)                    | `.editorconfig` + `.markdownlint.yml`, formatted by Prettier                                                                                                 |

Adding a language means adding its `.editorconfig` section (and, if it has one, wiring its formatter into the test suite) — not inventing a
new formatting philosophy.

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
formatter-stable: running the formatter over it changes nothing. A hand-padded string template is the same hand-formatting ADR-REPO-FORMAT:1
forbids, merely moved into code; it drifts the moment a field is added and churns the diff on every build.

## Decision

The whole repository follows a single, mechanically enforced formatting baseline, with per-language layers on top. No exceptions, no
per-file overrides, no "I prefer it this way." The tools decide, not the contributor.

### How this is enforced

- **`.editorconfig`** — the `[*]` baseline plus per-language sections (indent width, line length). Applied by every contributor's editor on
  save.
- **`.gitattributes`** — marks binary files so EOL/diff normalization never corrupts them; deliberately no `* text=auto`.
- **Per-language analyzers** — each language's specific rules run in its own gate. For PowerShell this is PSScriptAnalyzer plus custom rules
  in the L2 test suite (see [powershell-formatting](../automation/powershell/powershell-formatting.md)). For Markdown it is markdownlint
  (`.markdownlint.yml`), formatted by Prettier and kept in sync with it. For ADO pipeline YAML (`.yaml`) it is Prettier (`Format-Pipelines`,
  the same engine as Markdown) plus the naming-and-placement gate `Assert-Pipelines`
  ([pipeline-naming-and-placement](../pipelines/pipeline-naming-and-placement.md)) — both run in the L2 suite, so drifted or misplaced
  pipeline YAML fails CI.
- **Generated artifacts** — a build-generated artifact is emitted canonical by its generator (the module-manifest emitter), and the L2 suite
  asserts the formatter is a no-op over generated output, so its bytes cannot drift from the standard.

## Consequences

- Pull-request diffs contain only logic changes, for every file type — reviewers see what actually changed.
- `git blame` points at the author of the logic, not the last reformatter; `git diff` and `git log -p` stay clean.
- New contributors produce correctly formatted files from the first commit because their editor reads `.editorconfig`.
- Formatting discussions never happen — the baseline is fixed and the per-language layers are mechanical.
- Adding a file type is a small, bounded act: add its `.editorconfig` section (and formatter), inheriting the baseline.
