# Add a doc chapter

The repository has three kinds of prose, each with a home and a format:

| Kind                | Lives in                              | For                                                                            |
| ------------------- | ------------------------------------- | ------------------------------------------------------------------------------ |
| **ADR**             | `docs/adr/<area>/`                    | A durable design decision and its rationale (the _why_)                        |
| **Getting-started** | `docs/how-to/getting-started/<area>/` | A task-focused guide for onboarding and the common jobs (the _how_, like this) |
| **How-to**          | `docs/how-to/<area>/`                 | A standalone how-to article for one task (e.g. the manual test plan)           |
| **Note**            | `docs/notes/**`                       | Freeform working notes, investigations, drafts                                 |

All of `docs/` is **markdown only**. Decide which kind you're writing, then follow the matching recipe below.

## Formatting (applies to all docs)

- Match the cross-language baseline: UTF-8 (no BOM), LF endings, final newline, no trailing whitespace (except a Markdown hard line break).
  This is enforced by `.editorconfig` (see [uniform-formatting](../../../adr/repository/uniform-formatting.md)).
- Markdown is governed by `.markdownlint.yml` and formatted by Prettier. Before committing:

  ```powershell
  . ./importer.ps1
  Format-Markdown                    # format Markdown to the house style
  Test-Markdownlint                  # lint; report under out/test-markdownlint/
  Test-Spelling                      # cspell against the repo dictionary (cspell.yml)
  ```

- One `#` H1 per file (the title); a blank line after every heading and before the next; fenced code blocks carry a language; tables have a
  header separator row.

## Writing a getting-started or how-to article (like this one)

1. Create the file in kebab-case, named for the task (`add-a-thing.md`). An **onboarding/common-job** guide goes in
   `docs/how-to/getting-started/<area>/`; a **standalone how-to** for one specific task (e.g. the manual test plan) goes in
   `docs/how-to/<area>/`.
2. Write it for a human who wants to _do_ the task: numbered steps first, then a worked example, then the rules and the verify step. Keep it
   short — link to the ADR for the reasoning rather than re-explaining it.
3. If it is a getting-started guide, add a row to the task guide table in `docs/how-to/getting-started/<area>/index.md`.

References point **one way**: an article cites the relevant ADR; an ADR never links back to an article (that would couple durable rationale
to how-to churn).

## Writing an ADR

ADRs capture a decision so it can be cited and enforced. They follow a fixed shape — read [`docs/adr/README.md`](../../../adr/README.md)
("Authoring conventions") in full before writing, and copy the structure of an existing ADR. The essentials:

1. **Pick the area and a code.** ADRs are grouped into `principles/`, `automation/`, `pipelines/`, `azure/`, `repository/`. Choose a short
   unique citation code (e.g. `ADR-CACHE`, `ADR-NAMING`, `ADR-AZSESS`).
2. **Create `docs/adr/<area>/<kebab-title>.md`.** Start with the rule registry — a `## Rules: <code>` section followed by
   `### Rule <code>:<n>` entries, each a one-paragraph normative summary that links to the prose section justifying it. These are what other
   code and docs cite as `<code>#<n>` (e.g. `ADR-ERROR#3`).
3. **Then the prose**: `## Context`, `## Decision`, optionally `## How this is enforced`, `## Consequences`.
4. **Register it.** Add the code → ADR row to the table in `docs/adr/README.md`, and add a bullet under the right section of
   [`docs/index.md`](../../../index.md).

### ADR authoring conventions (the ones people miss)

- **Decision and rationale, not config values.** Name the enforcing file (`PSScriptAnalyzerSettings.psd1`, `.editorconfig`) as a pointer;
  don't paste rule tables that will drift.
- **Present tense, not a changelog.** Describe the current design as if it had always been that way. No "now", "no longer", "previously",
  "we used to", and no war stories. History lives in git.
- **Plain language.** Never write "iff" — spell out both directions ("required when Y; an error otherwise").
- **Blank-line padding.** A blank line after every heading and before the next, including inside the rule registry.

## Fixing the index

`docs/index.md` is the human entry point into the docs. When you add or move a chapter, update it — and remove links to files that no longer
exist, so the index never points at a missing page.
