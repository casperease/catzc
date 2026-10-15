---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/Get-WorldMapOutputRoot.ps1.md
    kind: comment-page
    body_sha: d46f24204dbd
    adrs:
      - ADR-PWSH-PESTER#2
      - ADR-REPO-OUTDIR#2
    links: []
---

# automation/Catzc.Base.Maps/Get-WorldMapOutputRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The world map writes recurring files, so they land in their own folder under the output root
([ADR-REPO-OUTDIR#2](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir2)): Get-OutputRoot
joined with the output_folder of configs/maps.yml (read through Get-Config, typed as Catzc.Base.Maps.MapsConfig;
default world-map). It is also the seam a test mocks to a folder of its own
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)).
```
