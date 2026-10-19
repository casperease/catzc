# The glyph library described

```text
Three bands: THINGS (13 glyphs), LINES AND MARKS (4 edge kinds, 5 marks) and SOURCE LENS (3 code-unit variants, frames that nest).
Structure is mid-toned with a light rim: slate, mauve, olive. Result and failure are saturated.
Every diagram in docs/explanation uses these glyphs and these legend phrases.
```

This describes what the [glyph library](diagram.drawio.png) draws. Every explanation diagram is built from these glyphs, and each legend
entry on a diagram uses the phrase given here. How to read a diagram with them is in [the explanation index](../../index.md).

## Things

| Glyph         | Shape and colour                                      | Stands for                                                                                                      |
| ------------- | ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| code unit     | slate rounded box, white name                         | a module, function, type or script that runs                                                                    |
| named set     | mauve rounded box, white name                         | a group, globset, track, aspect or other named collection                                                       |
| file          | olive page with a folded corner, white name           | a config, YAML, manifest or other file read as data                                                             |
| store         | slate cylinder, white name                            | the repository, a registry, a cache, a feed                                                                     |
| runner        | slate pill, white name                                | a pipeline, stage, task or job that executes                                                                    |
| gate          | grey rhombus with a thick rim                         | a check that passes or stops the flow                                                                           |
| environment   | grey hexagon                                          | a deployment target, coloured only by the commit it holds                                                       |
| external tool | grey square box                                       | a vendor tool the code delegates to, such as the az CLI, Bicep or git                                           |
| result        | light green rounded box                               | what a step produces                                                                                            |
| failure       | light red rounded box                                 | a throw, rejection or discard; the only red                                                                     |
| ADR-only      | the glyph's shape, white with a dashed outline        | something an ADR states that no code runs or checks                                                             |
| actor         | white circle                                          | a person, such as a developer or reviewer                                                                       |
| commit        | small disc with a digit, in the locked commit palette | one commit, in the colour of its delivery state; red is a discarded commit (ADR-DSGN-VISUAL-FIXEDCOMMITPALETTE) |

Code unit, store and runner share the slate colour; their shapes tell them apart.

## Lines and marks

| Mark          | Looks like                                        | Means                                           |
| ------------- | ------------------------------------------------- | ----------------------------------------------- |
| flow          | thin grey arrow                                   | the one relationship the diagram's legend names |
| thick         | thick grey arrow                                  | the same relationship, to a named set           |
| ADR-only      | dashed grey arrow                                 | a relationship an ADR states that no code runs  |
| failure path  | red arrow                                         | the path into a failure                         |
| marker        | dark disc with a white digit                      | a numbered step of the article's Walkthrough    |
| fraction chip | bold `4/5`                                        | how many members of a set carry an edge         |
| rule chip     | small white pill, such as `#3`                    | the ADR rule that governs the glyph beside it   |
| span bar      | a line with an end tick on each side, label above | stages grouped over the bands, such as CI or CD |
| count chip    | white pill with a coloured rim, such as `87`      | how many members the glyph it sits on has       |

## Source lens

The code-unit family under the source lens, in slate with no new colour.

| Glyph          | Shape and colour                                         | Stands for                                                             |
| -------------- | -------------------------------------------------------- | ---------------------------------------------------------------------- |
| private helper | dark slate fill, slate rim, smaller name, never dashed   | a function under `private/`, loaded but not exported                   |
| C# type        | a code unit with a `C#` tag on its corner                | a compiled type the module carries                                     |
| catzc module   | slate frame named by the module, holding its code units  | another module's members; the diagram's own module is drawn as a band  |
| nested frames  | a frame inside a frame, such as a track holding a module | a holder's part: a track holds its modules, a module holds its members |
