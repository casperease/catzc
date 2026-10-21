---
plan:
  status: active
  value: highest
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      pwsh/Catzc.Base.QualityGates/configs/file-meta.yml,
      pwsh/Catzc.Base.QualityGates/types/FileHeadPolicy.cs,
      pwsh/Catzc.Base.Variants/configs/variants.yml,
      pwsh/Catzc.Base.Variants/types/VariantsConfig.cs,
      pwsh/Catzc.Base.Languages/types/GeneratedHeadConfig.cs,
      pwsh/Catzc.Base.Languages/Format-GeneratedFileHead.ps1,
      docs/adr/repository/file-meta.md,
      docs/adr/repository/code-file-meta.md,
      docs/adr/repository/repo-variants.md,
      docs/adr/repository/comments-in-docs.md,
      docs/explanation/file-meta.md,
      contracts/catzc/0.0.0/Catzc.Base.QualityGates/head.sample.yml,
    ]
---

# Minimal heads: a warning head on generated files, a navigation head on code, nothing elsewhere

`Format-FileMeta` with its shipped defaults writes a head of about 20 lines into almost every tracked code file: `head_policy.pages` is
`required` on `FileHeadPolicy`, nearly every code file has a comment page, and every place-fact kind (`repo_status`, `path`, `name`,
`filetype`, `role`, `language`, `track`, `tracktype`, `vendor`, `module`, `moduletype`, `catzc_bundle`, `visibility`) selects every file in
scope. The run left about 1,250 `.ps1`, 270 `.cs`, 250 `.yml` and every `.bicep` file with such a head. The sensible defaults must give the
minimal shape below instead (ADR-AUTO-DEFAULT-ONERESOLUTIONORDER), and a re-run must strip what the last run wrote.

## Why highest

Every code file in the tree carries a head no reader needs, and the next `Format-Code` keeps it there; GitHub's code view opens each file on
20 lines of facts instead of the code. Until this lands, `Format-FileMeta` cannot run without dirtying the whole repository.

## Decided (the user, 2026-10-21)

- **Generated content always carries a head**, tracked or not: the warning ("Do Not Edit, this file is generated",
  `GeneratedHeadConfig.DefaultWarning`), `with_body_sha`, `role`, `track`, `generator`, `source` as a plain path value, and the edges.
  Nothing else. It is no setting: a generated file without its head is a finding.
- **Authored source code and configs carry a navigation head** set by a repo-wide variant (ADR-REPO-VARIANT-SESSIONVARIANT), on or off, with
  its default declared once on `VariantsConfig`. The head holds only `with_body_sha` and the edges: the ADR codes (`cites`) and the links
  (`docs` to the comment page, `test` to the test). It exists so a reader on GitHub, or in an editor, steps straight to the rules and the
  docs of the file.
- **A test links to the code it tests**, a new relative edge beside `docs` and `test`; code and configs link to their docs.
- **Every other file carries no head**: authored Markdown, assets, everything not above.
- **An authored code head carries `with_body_sha`**, accepted with its cost: the line changes on every edit of the body, so two concurrent
  edits of one file also meet on that line. ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY is restated to say so, not reopened.

### From the decision round (the user, 2026-10-21)

- **`source` stays a plain path value** in the generated head, never an edge: an edge would break ADR-REPO-FILEMETA-FEWLINKS, since a source
  crosses modules (`importer.ps1` from `Catzc.Internal.Importer.psm1`); ADR-REPO-FILEMETA-PROVENANCEINHEAD stays as it is.
- **A generated page carries the relatives only** (`docs` where one exists), never the `links` list of every outgoing link, and no `cites`
  on a page that renders a registry; `cites` stays on a generated code file. This narrows the earlier "the edges: links and ADR codes", and
  ADR-REPO-FILEMETA-MARKDOWNEDGES retires.
- **The kind key is `role`** (ADR-REPO-FILEMETA-ROLE); `kind` would be a second name.
- **Agent heads are forbidden**: an agent's head holds only imprinted facts, so it goes, and `docs/adr/repository/agent-definitions.md:47`
  and `file-meta.md:10` are restated. A capability keeps its authored `config` part (`model_floor`, ADR-REPO-AGENTS-NAMEDMODEL) and loses
  its imprinted parts; a slide's front matter belongs to its tool and stays.
- **The code variant ships `minimal`** (heads on); `none` is the one-line switch.
- **The test-to-code edge is `code`**, so `source` keeps its one meaning; FEWLINKS' "at most two edges" is restated.
- **Fewer head notes**: the `docs-link-head` memory is folded into `minimal-heads-direction` now (done in the round); MODULEFACTS and
  MARKDOWNEDGES move to the dropped-keys page only after this plan lands.

## Open steps

- [ ] The generated head's `docs` edge: the docs-edge derivation moves down to a module both `Catzc.Base.Languages` and
      `Catzc.Base.QualityGates` load, so `Format-GeneratedFileHead` derives the edge itself and the relative-edges processor calls the same
      derivation; one mechanism, no upward dependency (the user, 2026-10-21). How (delegated to the orchestrator, 2026-10-21): the `pages`
      map leaves `comments.yml` for a `comment-pages` config of its own, with its type holding `CommentPageMap` and one public
      `Get-CommentPage -Path`, in a module both load; the ten `PageFor` callers in `Catzc.Base.QualityGates` move to it in the same change
      (ADR-PRIN-ONELIVE). (check: `Invoke-TestFile` on `Format-GeneratedFileHead.Tests.ps1`, the relative-edges processor's tests and each
      moved caller's tests; a fresh import.)
- [ ] `pwsh/Catzc.Base.QualityGates/tests/Invoke-FileMetaEngine.Tests.ps1`: a case that an unowned key in the authored `config` part is kept
      as the author's (KINDSCOPE landed without it, 2026-10-21) (check: `Invoke-TestFile` on the file).
- [ ] Whole tree: `Format-FileMeta`, then every generator through `Sync-GeneratedFile`, then `Format-FileMeta` again. (check: the second run
      formats 0 files; `Test-FileMeta` and `Test-GeneratedFiles` pass; a sampled function, test, config and bicep file holds only the keys
      above; no authored Markdown file has a `catzc:` head.)
- [ ] After every step above: `docs/explanation/file-meta.md`'s dropped-keys section absorbs ADR-REPO-FILEMETA-MODULEFACTS and
      -MARKDOWNEDGES, and `docs/adr/repository/file-meta.md` keeps one rule per head shape; the codes are retired, never reused. (check:
      `Build-AdrIndex`, `Test-AdrRegistry` on the two pages.)

## Refs

- `plan-docs-link-head.md` is retired into this plan (catzc-03, 2026-10-21); the trim of a paged file's head is this plan's.
- `head_policy.pages` came from the user (2026-10-20): every code file with a comment page links it as
  `edges.docs: "[<page>.md](docs/references/...)"`, repository-relative and with no leading `/` (the user corrected the `/`-rooted form).
  The navigation head keeps that form, written by the `link: "[{leaf}]({path})"` template of the `docs` relation in `relative-edges`
  (`Get-RelativeEdgesFileMetaFact`); only the `pages` policy goes, since the variant now decides which code files carry a head.
- The paged-file wording to restate lives in ADR-REPO-FILEMETA-HEADPOLICY, the file-meta "Head policy" section, ADR-REPO-FILEMETA-FEWLINKS,
  ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY and ADR-REPO-COMMENTS-ONELINEOFINSIGHT; the `pages` tests are in
  `tests/types/FileHeadPolicy.Tests.ps1` and the "comment page where the default forbids one" case of
  `tests/Invoke-FileMetaEngine.Tests.ps1`.
