# Add a doc chapter

The repository has five kinds of prose, each with a home and a format:

| Kind                | Lives in                              | For                                                                              |
| ------------------- | ------------------------------------- | -------------------------------------------------------------------------------- |
| **ADR**             | `docs/adr/<area>/`                    | A durable design decision and its rationale (the _why_)                          |
| **Getting-started** | `docs/how-to/getting-started/<area>/` | A task-focused guide for onboarding and the common jobs (the _how_, like this)   |
| **How-to**          | `docs/how-to/<area>/`                 | A standalone how-to article for one task (e.g. the manual test plan)             |
| **Explanation**     | `docs/explanation/<adr-domain>/`      | How one part works and why, narrating one diagram in `docs/explanation/.assets/` |
| **Note**            | `docs/notes/**`                       | Freeform working notes, investigations, drafts                                   |

All of `docs/` is **markdown only**, except the `.assets/` folders, which hold one folder per diagram, its `diagram.drawio.yml` source and
its `diagram.drawio.png` render ([conventional-folders](../../../adr/repository/conventional-folders.md)). Decide which kind you're writing,
then follow the matching recipe below.

## Formatting

`Formatting (applies to all docs)`

- Match the cross-language baseline: UTF-8 (no BOM), LF endings, final newline, no trailing whitespace (except a Markdown hard line break).
  This is enforced by `.editorconfig` (see [uniform-formatting](../../../adr/repository/uniform-formatting.md)).
- Markdown is governed by `.markdownlint.yml` and formatted by Prettier. Before committing:

  ```powershell
  . ./importer.ps1
  Format-Code -Language markdown     # format Markdown to the repository style
  Test-Markdownlint                  # lint; report under out/test-markdownlint/
  Test-Spelling                      # cspell against the repo dictionary (cspell.yml)
  ```

- One `#` H1 per file (the title); a blank line after every heading and before the next; fenced code blocks carry a language; tables have a
  header separator row.

## Writing a how-to article

`Writing a getting-started or how-to article (like this one)`

1. Create the file in kebab-case, named for the task (`add-a-thing.md`). An **onboarding/common-job** guide goes in
   `docs/how-to/getting-started/<area>/`; a **standalone how-to** for one specific task (e.g. the manual test plan) goes in
   `docs/how-to/<area>/`.
2. Write it for a human who wants to _do_ the task: numbered steps first, then a worked example, then the rules and the verify step. Keep it
   short — link to the ADR for the reasoning rather than re-explaining it.
3. If it is a getting-started guide, add a row to the task guide table in `docs/how-to/getting-started/<area>/index.md`.

References point **one way**: an article cites the relevant ADR; an ADR never links back to an article (that would couple durable rationale
to how-to churn).

## Writing an explanation article

An explanation article narrates one diagram: how one part of cats works and why it holds.

1. Create `docs/explanation/<adr-domain>/<kebab-title>.md`, in the folder of the ADR domain whose decision it explains.
2. Declare the diagram in `docs/explanation/<adr-domain>/.assets/<kebab-title>/diagram.drawio.yml` (its `description:`, the lens and ADR
   codes under `about:`, and the `content:` it draws), then put it with `Build-Diagrams -Path <that folder>`. Declare its minimaps' lit
   cells with `declaration.py minimaps <that folder>`, which writes each cell and what lit it under `content.minimaps`, then read them once
   against the drawing.
3. After the title, open with a fenced `text` block that gives the overview: the finding in one line, then one line per numbered point of
   the diagram. Then a short opening paragraph, the image, a Walkthrough that narrates every numbered point in order, the ADR rules that
   make it hold, and links to the ADR, the asset description and the related articles.
4. List it in its domain's `index.md`. Cite ADRs from the article; an ADR never links back to it.

## Writing an ADR

ADRs capture a decision so it can be cited and enforced. They follow a fixed shape — read [`docs/adr/index.md`](../../../adr/index.md)
("Authoring conventions") in full before writing, and copy the structure of an existing ADR. The essentials:

1. **Pick the domain and a code.** ADRs are grouped into the domains `pwsh/Catzc.Base.Docs/configs/adrs.yml` lists, each in its own folder
   under `docs/adr/`. The code is the domain's prefix plus a segment that names the decision (e.g. `ADR-THES-NORMALFORM`), as
   [adr-code-language](../../../adr/repository/adr-code-language.md) sets out.
2. **Create `docs/adr/<domain-folder>/<kebab-title>.md`.** Start with the rule registry: a `## Rules: <code>` section followed by one
   `### Rule <code>-<RULENAME>` entry per rule, each a one-paragraph normative summary that links to the prose section justifying it. Other
   code and docs cite a rule by that full code (e.g. `ADR-PWSH-ERROR-THROWNOTWRITEERROR`); a rule has a name, never a number.
3. **Then the prose**: `## Context`, `## Decision`, optionally `## How this is enforced`, `## Consequences`.
4. **Register it.** Add the ruleset to its domain in `adrs.yml` (the next import regenerates the code → ADR table in `docs/adr/index.md`),
   add its entry to the domain's `dora-explains.md`, and add a bullet under the right section of [`docs/index.md`](../../../index.md). The
   whole sequence, with its builds and checks, is [Add an ADR](add-an-adr.md).

### ADR authoring conventions

`ADR authoring conventions (the ones people miss)`

- **Decision and rationale, not config values.** Name the enforcing file (`PSScriptAnalyzerSettings.psd1`, `.editorconfig`) as a pointer;
  don't paste rule tables that will drift.
- **Present tense, not a changelog.** Describe the current design as if it had always been that way. No "now", "no longer", "previously",
  "we used to", and no war stories. History lives in git.
- **Plain language.** Never write "iff" — spell out both directions ("required when Y; an error otherwise").
- **Blank-line padding.** A blank line after every heading and before the next, including inside the rule registry.

## Fixing the index

`docs/index.md` is the human entry point into the docs. When you add or move a chapter, update it — and remove links to files that no longer
exist, so the index never points at a missing page.
