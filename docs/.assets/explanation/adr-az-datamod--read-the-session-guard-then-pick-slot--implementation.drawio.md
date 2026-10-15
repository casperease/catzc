# docs/.assets/explanation/adr-az-datamod--read-the-session-guard-then-pick-slot--implementation.drawio.md

`Read the session, guard, then pick the slot: the diagram described`

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 5 code units (slate), 1 file (olive), 1 gate (neutral), 2 failures; 4 flow edges, 2 failure paths; 1 frame; 9 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-az-datamod--read-the-session-guard-then-pick-slot--implementation.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/azure/read-the-session-guard-then-pick-slot.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, a wide `SESSION`, a narrow `GUARD` and `SLOT`. It holds nine glyphs, five code units, one file, one gate and two failures, joined by
four flow edges and two failure paths, with nine markers and a legend panel along the bottom. A frame in the slot band holds three code
units stacked in a column. The eye lands first on the gate in the narrow guard band, with a red failure below it.

## Reading path

1. Marker 1, session band, upper row: the code unit Get-CurrentAzSubscription, then right to marker 2, the wide code unit
   Get-AzCliSessionSubscription.
2. Down to the lower row: marker 3, the file azure.yml, whose edge goes up into the wide code unit; and marker 4 to its right, the failure
   undeclared subscription, reached by a failure path down from the wide code unit.
3. Right across the band gap to marker 5, guard band: the gate -SubscriptionIdAssertIs; below it, marker 6, the failure wrong subscription.
4. Right into the slot band, where one flow edge enters the frame; inside it, top to bottom, markers 7, 8 and 9: the code units
   Get-AzureEnvironment, Get-Bicep…Configuration and Get-BicepResourceGroupName.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                                  |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 5     | Get-CurrentAzSubscription, Get-AzCliSessionSubscription (session band, upper row); Get-AzureEnvironment, Get-Bicep…Configuration, Get-BicepResourceGroupName (slot band, in the frame) |
| file                  | 1     | azure.yml (session band, lower row)                                                                                                                                                    |
| gate                  | 1     | -SubscriptionIdAssertIs (guard band)                                                                                                                                                   |
| failure               | 2     | undeclared subscription (session band, lower right), wrong subscription (guard band, below the gate)                                                                                   |

Code units are slate, the file olive, the gate neutral and the failures red. The frame is chrome: no fill and a thin band-coloured rim.

## Edges

| Edge kind                 | Count | From → to                                                                                                                                                                                       |
| ------------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: feeds the next step | 4     | Get-CurrentAzSubscription → Get-AzCliSessionSubscription; azure.yml → Get-AzCliSessionSubscription; Get-AzCliSessionSubscription → -SubscriptionIdAssertIs; -SubscriptionIdAssertIs → the frame |
| failure path              | 2     | Get-AzCliSessionSubscription → undeclared subscription; -SubscriptionIdAssertIs → wrong subscription                                                                                            |

The edges along the upper row are horizontal; the edge from azure.yml and both failure paths are vertical. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                        | Phrase                     |
| ----------------------------- | -------------------------- |
| slate rounded box             | code unit                  |
| olive page with folded corner | file                       |
| neutral rhombus               | gate                       |
| red rounded box               | failure                    |
| thin arrow                    | flow: feeds the next step  |
| red arrow                     | failure path               |
| light disc `1`                | marker: a Walkthrough step |

## Sidebar

The lens badge reads `IMPL`. The three minimaps sit above it, and the map key below it names the four swatches.
