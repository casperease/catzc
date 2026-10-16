---
catzc:
  immutable:
    with_body_sha: d621f7198d22
    path: docs/.assets/explanation/adr-flow-cd-globs--range-per-context-then-diff-and-match--implementation.drawio.md
    folder: docs/.assets/explanation
    name: adr-flow-cd-globs-range-per-context-then-diff-and-match-implementation-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--range-per-context-then-diff-and-match--implementation.drawio.png
      - docs/explanation/flow/range-per-context-then-diff-and-match.md
---

# Range per context, then diff and match: the diagram described

```text
A 1572 x 800 diagram, read top to bottom through four bands.
Glyphs: 3 code units (slate), 1 file (olive), 5 results, 1 failure; 7 flow edges, 1 failure path; 1 frame; 9 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-flow-cd-globs--range-per-context-then-diff-and-match--implementation.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../explanation/flow/range-per-context-then-diff-and-match.md).

## At a glance

A 1572 × 800 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled `ENTRY`, `RANGE PER CONTEXT`, `DIFF AND MATCH` and `ANSWER`. It holds ten glyphs, three code units, a file, five
results and a failure, joined by seven flow edges and one failure path, with nine markers and a legend panel along the bottom. The eye lands
first on the row of three green results inside a frame in the second band.

## Reading path

1. Marker 1, `ENTRY` band: the code unit Test-GlobSetAffected, centred; left along a flow edge to marker 2, the file globs.yml; right along
   the failure path to marker 3, the failure not a declared globset.
2. Down the flow edge to marker 4, `RANGE PER CONTEXT` band: the code unit Get-GlobSetChangeRange.
3. Down into the frame, marker 5 on its corner: the results HEAD, HEAD^1..HEAD and origin/\<target\>...HEAD, left to right.
4. Marker 6, on the right, beside the long flow edge that leaves Get-GlobSetChangeRange to the right, runs down past the frame and enters
   the result $true from the right.
5. Down from the frame to marker 7, `DIFF AND MATCH` band: the code unit Get-ChangedGlobSet.
6. Down the two flow edges that leave it to `ANSWER` band: marker 8, the result
   $false, confirmed untouched, and marker 9, the result
   $true, touched or doubt.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                |
| --------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 3     | Test-GlobSetAffected (`ENTRY`), Get-GlobSetChangeRange (`RANGE PER CONTEXT`), Get-ChangedGlobSet (`DIFF AND MATCH`)                                  |
| file                  | 1     | globs.yml (`ENTRY`, left)                                                                                                                            |
| result                | 5     | HEAD, HEAD^1..HEAD, origin/\<target\>...HEAD (`RANGE PER CONTEXT`, in one frame); $false, confirmed untouched and $true, touched or doubt (`ANSWER`) |
| failure               | 1     | not a declared globset (`ENTRY`, right)                                                                                                              |

Code units are slate and the file olive, both with white names; the results are green and the failure the only red. A thin neutral frame
groups the three range results; it is chrome, not a glyph.

## Edges

| Edge kind                 | Count | From → to                                                                                                                                                                                                                                                                                |
| ------------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: feeds the next step | 7     | Test-GlobSetAffected → globs.yml; Test-GlobSetAffected → Get-GlobSetChangeRange; Get-GlobSetChangeRange → the frame; the frame → Get-ChangedGlobSet; Get-ChangedGlobSet → $false; Get-ChangedGlobSet → $true; Get-GlobSetChangeRange → $true (three straight segments, labelled `$null`) |
| failure path              | 1     | Test-GlobSetAffected → not a declared globset, labelled `undeclared`                                                                                                                                                                                                                     |

Three edges carry a word label: `undeclared` on the failure path, `$null` on the long edge, and `untouched` and `touched, or git throws` on
the two edges into the answers. No edge crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate rounded box | code unit                  |
| olive page        | file                       |
| green rounded box | result                     |
| red rounded box   | failure                    |
| thin arrow        | flow: feeds the next step  |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `IMPL`. The three minimaps sit above it, and the map key below it names the four swatches: lit, lit by passing mentions
only, lit ADR file, idle.
