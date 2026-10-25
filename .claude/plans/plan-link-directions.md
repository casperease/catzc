---
plan:
  status: active
  value: medium
  reviewed: 2026-10-24
  class: meta
  targets:
    [
      docs/drs/repository/markdown-links.md,
      docs/drs/repository/file-meta.md,
      pwsh/Catzc.Base.Drs/configs/drs.yml,
      pwsh/Catzc.Base.Config/configs/configs.yml,
      pwsh/Catzc.Base.QualityGates/configs/glossary.yml,
      pwsh/Catzc.Base.QualityGates/types/LinkEngine.cs,
      pwsh/Catzc.Base.QualityGates/types/LinkEngineResult.cs,
      pwsh/Catzc.Base.QualityGates/types/CodeLinkRewriter.cs,
      pwsh/Catzc.Base.QualityGates/types/MarkdownLinkScanner.cs,
      pwsh/Catzc.Base.QualityGates/private/Invoke-LinkEngine.ps1,
      pwsh/Catzc.Base.Globs/configs/file-kinds.yml,
      contracts/catzc/0.0.0/catzc.base.globs/configs/file-kinds.yml,
      pwsh/Catzc.Base.Globs/Get-AspectGlobSet.ps1,
      pwsh/Catzc.Base.Globs/types/Aspect.cs,
    ]
---

# Link directions: which way a link may point

The rules for which way a link points between kinds of file are prose in four records, and almost none is checked. ADR-REPO-LINK-ONEWAY says
code links go out of code into an ADR and an ADR never links into code; ADR-REPO-FILEMETA-FEWLINKS says a comment page sits in the file's
own docs section and records no edge back, and modules relate by name, never by path; DDR-ASPECT splits a unit into `live` and `tests`;
ADR-AUTO-DEPM allows module-to-module edges by declaration. What is checked today: the form and target of a link (`Test-Links`),
module-to-module edges (`Test-ModuleDependency`), and an ADR citing a domain it does not depend on (`Test-DrsRegistry`, through
`Get-DrsCitationGraphViolations`). What is not (a read of the tree on 2026-10-24, not yet the gate's verdict):
`docs/drs/automation/pwsh/parameter-design.md:123` links `pwsh/Catzc.Base.Docs/Add-SessionLearning.ps1`, an ADR linking into code, which no
gate reports; and `CodeLinkRewriter` skips every comment link whose target is not an ADR, so the half of ONEWAY that forbids a comment
linking a reference page or how-to is never looked at.

The plan adds one ADR that states the directions as rows over derived facets of the two ends of a link, and one quality gate,
`Test-LinkDirections`, that asserts every link in the tree against the rows.

## Why its value is medium

It breaks nothing and ships nothing, but it turns four prose rules into one declaration a gate holds, shows one live breach today, and makes
every future file role or document type a row instead of a new unchecked convention.

## Decided (proposed 2026-10-24, the user: "looks very good")

- **A relation is one of three:** a markdown link (a link in a `.md` file), a code link (a link or a bare citation in a comment of any other
  file, ADR-REPO-LINK-KINDBYFILE) and a docs edge (the head's link to the comment page). A string that names a path or a citation is data
  and no relation (ADR-REPO-LINK-STRINGSAREDATA); an image is an embed, not a reference to read, and is no relation; a link to an in-file
  anchor, to a URL, to a folder or to a missing target is no relation either (`Test-Links` reports the missing one).
- **An end of a link is a set of facets derived on demand**, never read from a head (ADR-REPO-FILEMETA-NOREADBACK): `class` (the role and
  subkind, `file-kinds.yml`), `aspect` (`live`, `tests`, or the remainder name, DDR-ASPECT-ASPECTSAREDERIVED; none for a file in a track
  without aspects), `track` and `tracktype` (`Get-Track -Path`, DDR-TRACKTYPE-FACTSFROMDECLARATION), `module` (`Get-PathModule`) and, for an
  ADR, nothing more, since its domain order is another gate's.
- **Directions are rows in `link-directions.yml`, first match wins, a pair no row allows is denied** (the same default-deny as
  DDR-ASPECT-TRACKPICKSCATCHALL). A row names the relations it covers, a `from` selector, a `to` selector, a verdict (`allow` or `deny`) and
  `because`, a registered rule code, required. A selector lists values of the facets above (a class is `role` or `role/subkind`, with at
  most one `*`, as a file-meta kind selects); it never holds a glob (ADR-REPO-FILEMETA-METAKIND). A deny row exists for each rule an ADR
  states in prose, so the finding names that rule; the rest falls to the default.
- **A direction that another record declares is read there, never copied** (PDR-ONELIVE). Module to module stays `dependencies.yml`
  (ADR-AUTO-DEPM-CODEBUILTFROM), and an ADR's domain order stays `drs.yml` `depends_on`, checked by `Test-DrsRegistry`; the rows allow ADR
  to ADR and say in `because` where the order is held. The aspect partition stays DDR-ASPECT's: rows select an aspect, they do not recompute
  one.
- **An exception is a config entry with its reason** (PDR-CONFIG-EXCEPTIONISCONFIGENTRY): `exempt:` maps a file to why, as
  `string_citations.exempt` does in `links.yml`. There is no gate mode and no report mode: the gate runs as a gate from its first commit,
  because the same plan clears what it finds first (the clear-the-tree step) after the integrity test is written. If the first run finds
  more than 25 links, the step stops and the user is asked.
- **One extraction, not two.** The aligner and the gate read the same walk of the same files (`LinkEngine`, `MarkdownLinkScanner`,
  `CodeLinkRewriter`), so they cannot disagree on what a link is (ADR-REPO-LINK-ALIGNEDBYTOOL). The walk records each relation it recognises
  into a sink the caller asks for; `Test-Links` and `Format-Links` ask for none.
- **Signatures change with every caller in one pass** (PDR-ONELIVE, and the importer-path outages of 2026-10-19): a type and its callers
  land together, then a fresh full import in a new `pwsh` process before any test file runs.
- **The pure parts take their inputs as parameters** (ADR-REPO-FILEMETA-PUREPARTS): the engine that judges rows reads no config and no file,
  the table of end facets and the rows are passed in, and the facets are computed once per distinct file of the run, not once per link.
  Measure the run before any optimisation beyond that (ADR-AUTO-TEST speed rules).
- **The name** is `ADR-REPO-LINKS` (the user, 2026-10-24), the record file `links-in-repository.md`. `ADR-REPO-LINK` stays the form of a
  link; the two are separate whole segments of the code grammar (ADR-REPO-DRSCODE-CODEISSELECTOR), and the `drs.yml` step proves no citation
  regex confuses them.

## Decided (the user, 2026-10-24, decision round)

- **Derived relations are in scope, as a second plan.** The gate of this plan checks the links the files write. The relations the
  conventions imply (a test to its subject by stem under `tests/`, a file to its comment page by the pages map, a module to its declared
  dependencies) and completeness rows ride the same facets and rows in `plan-link-graph`, with a `Get-LinkEdge -To <path>` reader for the
  blast radius of a file (the `plan-link-graph` step).
- **A reference page may link any code.** Reference pages link across modules by design (`docs/references/BCL/index.md`), so no page-module
  facet is added.
- **An ADR links only the references that ground it, never code, a how-to, an explanation or another reference.** The user chose "deny
  except dora"; the authoring conventions in `docs/drs/index.md` ground the Azure Well-Architected and Cloud Adoption ADRs in
  `docs/references/waf` and `docs/references/caf` the same way, so the exception is the three subkinds `reference/dora`, `reference/caf` and
  `reference/waf` (the `file-kinds.yml` step). If the clear-the-tree step shows an ADR linking a fourth reference, the user is asked, not
  the row widened.
- **The ADR domain order stays in `Test-DrsRegistry`.** `Get-DrsCitationGraphViolations` keeps it; the rows allow ADR to ADR and say where
  the order is held. Revisit when the gate is green.

## Open steps

1. [ ] The closing checks, after the minimal-head run over the tree (its 1759 old-form `[x](path)` docs edges no longer resolve until then;
       no finding reads `ADR-REPO-LINK` as `ADR-REPO-LINKS`): `Test-Links` and `Test-FileMeta` over the tree. Check: both green.

## Refs

ADR-REPO-LINK, ADR-REPO-FILEMETA, ADR-REPO-CODEMETA, DDR-ASPECT, DDR-TRACKTYPE, DDR-MODTYPE, ADR-AUTO-DEPM, ADR-AUTO-TEST-QUALITYGATE,
ADR-CONF-LOADING-POWERSHELLVALIDATOR, ADR-REPO-CMDCONTRACT, PDR-CONFIG-EXCEPTIONISCONFIGENTRY, PDR-ONELIVE, ADR-BCL-TYPES-ONETYPEPERFILE.
