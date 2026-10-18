# The code carries both halves of ingress, but nothing finds the last verified commit: the diagram described

```text
A 1572 x 640 diagram, read top to bottom through two bands, LOCAL HALF and SERVER HALF, each left to right.
Glyphs: 2 files (olive), 6 code units (slate), 1 gate, 1 failure; 8 flow edges, 1 failure path; 10 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-remote--local-guard-and-server-policies--implementation.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](local-guard-and-server-policies.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through two
full-width bands labelled LOCAL HALF and SERVER HALF; each band reads left to right. It holds ten glyphs, two files, six code units, one
gate and one failure, joined by nine edges, with ten markers and a legend panel along the bottom. The eye lands first on the red failure at
the right end of the LOCAL HALF row.

## Reading path

1. Marker 1, LOCAL HALF, left: the file variants.yml.
2. Right along the row through markers 2, 3 and 4: the code units Get-GitWorkspace, Test-GitWorkspace and Sync-GeneratedFile.
3. Along the red edge to marker 5: the failure Skipped on main.
4. Marker 6, SERVER HALF, left: the file build-validation.yml.
5. Right through markers 7 and 8: the code units Sync-AdoBuildValidations and Register-AdoBuildValidation.
6. Right to marker 9: the gate ADO branch policy.
7. Down to marker 10: the wide code unit Get-AdoBuildValidations, and up from it into Register-AdoBuildValidation.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                                               |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| file                  | 2     | variants.yml (LOCAL HALF, left), build-validation.yml (SERVER HALF, left)                                                                                                                           |
| code unit             | 6     | Get-GitWorkspace, Test-GitWorkspace, Sync-GeneratedFile (LOCAL HALF row); Sync-AdoBuildValidations, Register-AdoBuildValidation (SERVER HALF row); Get-AdoBuildValidations (SERVER HALF, lower row) |
| gate                  | 1     | ADO branch policy (SERVER HALF, right)                                                                                                                                                              |
| failure               | 1     | Skipped on main (LOCAL HALF, right)                                                                                                                                                                 |

Files are olive and code units slate, both with white names.

## Edges

| Edge kind    | Count | From → to                                                                                          |
| ------------ | ----- | -------------------------------------------------------------------------------------------------- |
| flow         | 3     | variants.yml → Get-GitWorkspace → Test-GitWorkspace → Sync-GeneratedFile                           |
| flow         | 3     | build-validation.yml → Sync-AdoBuildValidations → Register-AdoBuildValidation → ADO branch policy  |
| flow         | 2     | ADO branch policy → Get-AdoBuildValidations, Get-AdoBuildValidations → Register-AdoBuildValidation |
| failure path | 1     | Sync-GeneratedFile → Skipped on main                                                               |

Every edge is straight; none crosses another. The last three flow edges of the SERVER HALF form a loop: right into the gate, down to
Get-AdoBuildValidations, and up into Register-AdoBuildValidation.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                          | Phrase                     |
| ------------------------------- | -------------------------- |
| olive page with a folded corner | file                       |
| slate rounded box               | code unit                  |
| rhombus with a thick rim        | gate                       |
| red rounded box                 | failure                    |
| solid arrow                     | flow: feeds                |
| red arrow                       | failure path               |
| dark disc `1`                   | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-REMOTE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-remote--local-guard-and-server-policies--implementation.grid.md),
[tree](../.assets/tree/adr-dsgn-remote--local-guard-and-server-policies--implementation.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-remote--local-guard-and-server-policies--implementation.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-DSGN-REMOTE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
