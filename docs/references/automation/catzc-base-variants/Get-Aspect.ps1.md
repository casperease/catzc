---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/Get-Aspect.ps1.md
    kind: comment-page
    body_sha: b33c0514ae91
    adrs: []
    links: []
---

# automation/Catzc.Base.Variants/Get-Aspect.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The `aspects` repo-wide variant (configs/variants.yml,
[ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)) is a per-track/per-container map of
ordered first-match (fallthrough) classifications, patterns relative to the unit root. Each aspect is a
VariantAspect { Name, Patterns }; evaluated in order, first match wins, the LAST aspect is the '**' catch-all
remainder. The catch-all's liveness is the container's call: 'automation' (code) keeps 'live' closed so a
stray file falls to the 'tests' catch-all and never ships; 'infrastructure' (a deployment) makes 'live' the
catch-all — everything under a template ships, only an explicit tests/ folder is non-live. An unknown track
falls back to the automation convention. The shape is validated by the VariantsConfig type (which also
validates the defaults below); the Globs aspect engine compiles each aspect into a scan program.
```

## comment:2

Section `.PARAMETER Track` of the comment-based help.

```text
The track/container whose convention to return ('automation', 'infrastructure', …). Defaults to
'automation'.
```
