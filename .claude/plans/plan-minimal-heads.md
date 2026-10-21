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
  `GeneratedHeadConfig.DefaultWarning`), `with_body_sha`, the kind, `track`, `generator`, and the edges: links and ADR codes. Nothing else.
  It is no setting: a generated file without its head is a finding.
- **Authored source code and configs carry a navigation head** set by a repo-wide variant (ADR-REPO-VARIANT-SESSIONVARIANT), on or off, with
  its default declared once on `VariantsConfig`. The head holds only `with_body_sha` and the edges: the ADR codes (`cites`) and the links
  (`docs` to the comment page, `test` to the test). It exists so a reader on GitHub, or in an editor, steps straight to the rules and the
  docs of the file.
- **A test links to the code it tests**, a new relative edge beside `docs` and `test`; code and configs link to their docs.
- **Every other file carries no head**: authored Markdown, assets, everything not above.
- **An authored code head carries `with_body_sha`**, accepted with its cost: the line changes on every edit of the body, so two concurrent
  edits of one file also meet on that line. ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY is restated to say so, not reopened.

## Open questions

- **Q1: Does the generated head keep `source`?** Recommendation: yes, as an edge. The warning says "do not edit"; `source` is the one
  pointer that says what to edit instead (ADR-REPO-FILEMETA-PROVENANCEINHEAD), and it is a link. Otherwise: `generator` alone.
- **Q2: What are "links" on a generated Markdown page?** Recommendation: the few relatives (`source`, `docs`), never the `links` list of
  every outgoing link, and no `cites` on a page that renders a registry: the ADR index would carry every code and every ADR link, hundreds
  of lines. `cites` stays on a generated code file, where it is a handful. Otherwise: the full `links` and `cites` lists.
- **Q3: Which key spells "kind"?** Recommendation: `role`, the term ADR-REPO-FILEMETA-ROLE defines; `kind` would be a second name for it.
- **Q4: What happens to the agent, capability and slide entries of `head_policy.classes`?** Recommendation: their front matter belongs to
  the tool that reads it and stays untouched, and their authored `config` part (ADR-CONF-MDCONTRIB) stays; the imprinted `immutable` and
  `edges` parts go, as on every other authored Markdown file.
- **Q5: What is the shipped default of the code variant?** Recommendation: `minimal` (heads on), since navigation is the head's whole
  purpose; `none` is the one-line switch for a repository that wants clean files.
- **Q6: What is the test-to-code edge called?** Recommendation: `code`, so `source` keeps its one meaning, the authored input of a generated
  file.

- **Q7: Should the next session read less about heads?** Recommendation: yes, in two cuts. First, merge the `docs-link-head` memory into
  `minimal-heads-direction`, since the new direction supersedes it. Second, once this plan lands, fold ADR-REPO-FILEMETA-MODULEFACTS and
  ADR-REPO-FILEMETA-MARKDOWNEDGES into the dropped-keys page, so `file-meta.md` holds one rule per head shape. Otherwise: keep both as they
  are.

## Open steps

- [ ] `docs/explanation/file-meta.md`: add a section naming every key a head does not carry (`repo_status`, `path`, `folder`, `name`,
      `filetype`, `subkind`, `language`, `tracktype`, `vendor`, `module`, `moduletype`, `catzc_bundle`, `visibility`, `defines`, `links`),
      each with its meaning and the registry or command that derives it on demand (`file-kinds.yml`, the tracks variant, `module-types.yml`,
      `Get-RepoStatus`, …), before any key is removed (never drop a key silently). (check: `Test-Links` on the page passes; every key above
      has a line.)
- [ ] `pwsh/Catzc.Base.QualityGates`, before deleting anything: confirm nothing reads a head back (ADR-REPO-FILEMETA-NOREADBACK), the listen
      search and the minimap data included. (check: a grep for `immutable` and `edges.` outside the imprint engine and its tests finds no
      reader.)
- [ ] `docs/adr/repository/repo-variants.md`: add ADR-REPO-VARIANT-FILEHEADS: `file_heads.code` (`minimal` | `none`) decides whether an
      authored code or config file carries the navigation head; generated files are outside the variant. (check: `Test-AdrCodes` and
      `Build-AdrIndex` pass; the code is in the index.)
- [ ] `docs/adr/repository/file-meta.md`: restate HEADPOLICY (generated: required, tracked or not; authored code: the variant; everything
      else: forbidden; no `pages` setting), IMPRINTEDPARTS and FILEISNODE (no `repo_status`, `immutable` holds `with_body_sha` alone on an
      authored head), COMPOSEDFILES and PROVENANCEINHEAD (the generated head's keys, per Q1–Q3), FEWLINKS (the `code` edge from a test, per
      Q6), MODULEFACTS and MARKDOWNEDGES (retired: the facts are derived, never shown). (check: `Test-AdrCodes` passes; `Test-Links` on the
      page passes.)
- [ ] `docs/adr/repository/code-file-meta.md`: restate COMPUTABLEFACTSONLY (the head is `with_body_sha`, `cites`, `docs`, `test`, `code`;
      the hash's cost on concurrent edits stated), SAMEENGINE (scope is the variant, not every tracked file), and the samples and the "What
      the head holds" and "Scope" sections. (check: `Test-AdrCodes` passes.)
- [ ] `docs/adr/repository/comments-in-docs.md`: restate ADR-REPO-COMMENTS-ONELINEOFINSIGHT so the code-to-page link is the navigation
      head's `docs` edge when the variant is `minimal`, and nothing in the code when it is `none`. (check: `Test-AdrCodes` passes.)
- [ ] `pwsh/Catzc.Base.Variants/types/VariantsConfig.cs` and `configs/variants.yml`: add `file_heads` with `code`, its
      `DefaultFileHeadsCode` constant (per Q5) shown in the shipped file, plus `Get-FileHeadVariant` and
      `Test-FileHeadVariant -Minimal|-None` (ADR-REPO-VARIANT-NODIRECTREADS). (check: `Invoke-TestFile` on
      `tests/types/VariantsConfig.Tests.ps1` and the new function tests.)
- [ ] `pwsh/Catzc.Base.QualityGates/types/FileHeadPolicy.cs`: drop `pages` and `DefaultPagesPolicy`; a generated file is `required`, an
      authored file in a code carrier (comment head or JSON property) takes the variant, and everything else is `forbidden`; `classes` keeps
      only what Q4 leaves. (check: `Invoke-TestFile` on `tests/types/FileHeadPolicy.Tests.ps1`.)
- [ ] `pwsh/Catzc.Base.QualityGates/configs/file-meta.yml`: keep the kinds `body-sha`, `relative-edges` (with the `code` relation for tests)
      and `adr-codes`, none of them with a `select`, so they apply to every file the policy gives a head; remove `head_policy.pages` and the
      class entries Q4 retires; delete the other kinds. (check: `Test-FileMetaProcessors` reports each removed kind's function as an
      orphan.)
- [ ] `pwsh/Catzc.Base.QualityGates/private/`: delete the `Get-<Kind>FileMetaFact.ps1` files, their tests and their comment pages, for
      `RepoStatus`, `FilePath`, `FileName`, `FileType`, `FileRole`, `FileLanguage`, `Track`, `TrackType`, `Vendor`, `ModuleName`,
      `ModuleType`, `CatzcBundle`, `Visibility`, `AdrDefines`, `Links`, one file at a time (ADR-PRIN-ONELIVE). (check:
      `Test-FileMetaProcessors` passes.)
- [ ] `pwsh/Catzc.Base.Languages/types/GeneratedHeadConfig.cs` and its caller `Format-GeneratedFileHead.ps1`, in one pass: `order` becomes
      `with_body_sha`, `warning`, `role`, `track`, `generator`, then the edges per Q1–Q2; the writer always writes it, tracked or not, then
      a fresh full import. (check: `Invoke-TestFile` on both test files; the import succeeds in a new `pwsh`.)
- [ ] `contracts/catzc/0.0.0/Catzc.Base.QualityGates/head.sample.yml`: the two head shapes, generated and authored code (ADR-REPO-CONTRACT).
      (check: the contract tests of `Catzc.Base.QualityGates` pass.)
- [ ] `pwsh/Catzc.Base.QualityGates/tests/`: `Invoke-FileMetaEngine.Tests.ps1`, `Format-FileMeta.Tests.ps1`, `Sync-FileMeta.Tests.ps1`
      expect the minimal shapes, `none` strips every authored head, and a generated head survives `none`; then `Format-FileMeta.ps1.md` and
      the other comment pages that name a removed key. (check: `Invoke-TestFile` on each.)
- [ ] Whole tree: `Format-FileMeta`, then every generator through `Sync-GeneratedFile`, then `Format-FileMeta` again. (check: the second run
      formats 0 files; `Test-FileMeta` and `Test-GeneratedFiles` pass; a sampled function, test, config and bicep file holds only the keys
      above; no authored Markdown file has a `catzc:` head.)

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
