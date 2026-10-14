# .claude/drawio/STYLE.md

`Maker kit: style for new docs/.assets diagrams`

<!-- cspell:ignore mxGraphModel mxCell guillemets -->

The living style kit for the `drawio-diagram-waves` agent and every maker it launches. The lead updates it whenever a review teaches
something.

Tool: `uv run -q --with pillow python .claude/drawio/drawio_png.py <name>.xml <name>.drawio.png`. It embeds the model, draws a preview
raster, and asserts the round-trip. The XML root is
`<mxGraphModel …><root><mxCell id="0"/><mxCell id="1" parent="0"/>…</root></mxGraphModel>`.

## Canvas

`<mxGraphModel dx="1024" dy="768" grid="0" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1300" pageHeight="940" background="#ffffff" math="0" shadow="0">`.
Keep it at most 1300 wide and grow downward. Flat look: no shadows, no gradients.

## Ids and words

- Ids are semantic kebab/underscore slugs (`title`, `note`, `step-build`, `edge-build-test`). Never random ids.
- Every word comes from the source ADR or code, using its exact terms. Don't invent numbers, parts or loops.
- Stereotypes use guillemets: `<b>Name</b><br><i>&#171;module&#187;</i>`. Cite rules in parentheses, e.g. `(ADR-FLOW-CD:3)`. Write an em
  dash as `&#8212;`.
- The first cell after the root is a `title` text whose words are the finding the reader should leave with, not just the topic.

## Palette (structural diagrams: modules / tracks / flow / azure / config)

| Role                           | Fill      | Stroke    | Notes                      |
| ------------------------------ | --------- | --------- | -------------------------- |
| subject / title box            | `#e1d5e7` | `#9673a6` | module-ish subject         |
| track / primary box            | `#dae8fc` | `#6c8ebf` | stage, step                |
| pipeline / runner              | `#fff2cc` | `#d6b656` |                            |
| glob / code / config box       | `#f8fff8` | `#82b366` | `fontFamily=Courier New`   |
| neutral dependency / external  | `#f5f5f5` | `#666666` |                            |
| gate / check ("checked by")    | `#f5f5f5` | `#666666` | neutral, never red         |
| good / live / prod             | `#9BE7C4` | `#0E9F6E` | font `#0B5C43`             |
| failure / throw / discard only | `#EF9A9A` | `#C62828` |                            |
| band / container               | `#F6F8FA` | `#E1E4E8` | `arcSize=3`                |
| outer panel / legend           | `#FAFAFA` | `#CFD8DC` | `arcSize=6`                |
| text ink                       | —         | —         | `#37474F`, quiet `#666666` |

**Commit-lifecycle diagrams** (`commits-quality/`) use ONLY the locked commit palette from ADR-DSGN-VISUAL:4.

| Commit state            | Fill      | Stroke    |
| ----------------------- | --------- | --------- |
| brown topic             | `#C4915C` | `#7A4B25` |
| grey landed             | `#C9CCD1` | `#6B7178` |
| yellow BVT              | `#FFE082` | `#F9A825` |
| blue L3                 | `#64B5F6` | `#1565C0` |
| light-blue main-uat     | `#dae8fc` | `#6c8ebf` |
| light-green release-uat | `#d5e8d4` | `#82b366` |
| green prod              | `#60a917` | `#2D7600` |
| red discarded           | `#EF9A9A` | `#C62828` |

Ghosts use the state fill plus `strokeWidth=1.2;dashed=1;opacity=60;`.

## Style strings (copy verbatim)

- Box: `rounded=1;whiteSpace=wrap;html=1;arcSize=20;fillColor=#dae8fc;strokeColor=#6c8ebf;fontSize=12;`
- Container:
  `rounded=1;html=1;arcSize=3;fillColor=#F6F8FA;strokeColor=#E1E4E8;verticalAlign=top;align=left;spacingLeft=8;fontStyle=1;fontSize=12;fontColor=#455A64;`
- Title: `text;html=1;align=left;verticalAlign=middle;fontSize=16;fontStyle=1;fontColor=#37474F;`
- Body/note: `text;html=1;whiteSpace=wrap;align=left;verticalAlign=top;fontSize=11;fontColor=#666666;`
- Code box:
  `rounded=0;whiteSpace=wrap;html=1;align=left;verticalAlign=top;fontFamily=Courier New;fontSize=11;spacing=6;fillColor=#f8fff8;strokeColor=#82b366;`
- Decision: `rhombus;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;fontSize=11;`
- Hexagon (env slot / group):
  `shape=hexagon;perimeter=hexagonPerimeter2;whiteSpace=wrap;html=1;fillColor=#f5f5f5;strokeColor=#666666;strokeWidth=2;fontColor=#333333;`
- Commit dot: `ellipse;html=1;fillColor=<state>;strokeColor=<state>;strokeWidth=1.5;fontStyle=1;fontSize=11;`, with its digit as the value.
- Edge: `edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;fontSize=10;endArrow=block;strokeColor=#666666;`. Give it `source`/`target` ids and
  `<mxGeometry relative="1" as="geometry"/>`.
- Dashed edge (optional / not-taken): add `dashed=1;`. Forbidden or never: `strokeColor=#C62828;dashed=1;`.

## Every diagram: verify, then simplify (applies to ALL makers)

The user's standard, from the wave-1 review: the information must be **verified against the ADR AND the code AND the configs**, and the
picture must be **simple**. A diagram that is only true to the ADR prose is not done.

1. **Verify first.** For every claim in the picture (each box, edge, order, name, parameter, path and number), find its source in the ADR,
   the code (`automation/**`, `importer.ps1`, root scripts) and the configs (`configs/*.yml`, pipeline YAML). Write `<name>.verify.md` next
   to the XML: a table with the columns claim → source (`file:line`) → **confirmed / contradicted / ADR-only**.
2. **Code wins on facts. The ADR wins on intent.**
   - If the code contradicts the drawing, fix the drawing and report the contradiction.
   - If the ADR states something the code doesn't do yet, keep it only when it's essential to the finding, and mark it ADR-only in the
     table.
   - Never silently "fix" the ADR or the code.
3. **Get the order from the code.** For sequences (load order, precedence, pipeline steps), the call order in the code is the authority.
4. **Real names only.** Every function, parameter, env var, file path and task version must exist exactly as spelled. If the brief names
   something that doesn't exist (e.g. `Build-Catzc`), use the real name and report it.
5. **Hold terminology that is under review.** Don't rename or coin terms. Keep the ADR's current words and flag them. "Build mode" is
   currently being re-split (possibly into cached / installed / saved / temporary), so don't invent states for it.
6. **Then simplify** to the readability rules below. Cut detail into one footer line or leave it to the ADR. A cut is fine; a wrong or
   invented claim is not.

The maker's reply gives: the path, the title, the claim counts (confirmed / contradicted / ADR-only), each contradiction in one line, and
what was cut.

## Lens variants (one diagram, five simplifications)

A lens split redraws one diagram as five variants. Each variant is simplified toward one lens. All five **keep the source's flow axis**: the
same reading direction, and the same order of the main flow's stages, so the variants line up side by side. A variant drops what its lens
doesn't need. It never adds claims the source or its sources don't support.

- **`meta`** (≤ 5 boxes) shows the idea and its invariant: what kind of thing this is, and the one rule that holds. It drops every function,
  file, path and parameter name.
- **`architecture`** (≤ 8 boxes) shows the components or layers, their boundaries, and who depends on whom. It drops the call order inside a
  component, and parameters.
- **`implementation`** (≤ 10 boxes) shows the real functions, files, configs and parameters in code order, each verified to a `file:line`.
  It drops rationale and ADR wording.
- **`operations`** (≤ 8 boxes) shows what a person or pipeline runs and sees: entry commands, outputs, failure messages. It drops internals
  nobody operates directly.
- **`governance`** (≤ 8 boxes) shows which ADR rule constrains each stage, which gate checks it, and what is ADR-only. It drops mechanics
  and paths.

- Name the files `<name>.<lens>.xml` / `<name>.<lens>.drawio.png`. The title states the lens's finding, e.g. "Meta: …".
- Lenses share the source's colour meanings, so a stage keeps its colour across all five.
- If a lens has nothing honest to show (e.g. no operator touches it), draw nothing for it, and say so in the reply.
- **Keep helper scripts in your own output folder** (e.g. `out/diagrams/lenses/<name>/_gen.py`), never under a shared name in the
  scratchpad. Makers run in parallel, and a shared `gen_lenses.py` once let one maker overwrite another's files.
- Lens variants live in `out/diagrams/lenses/<name>/`. At fan-in, the lead tiles them for review with
  `uv run -q --with pillow python .claude/drawio/contact_sheet.py out/diagrams/lenses/<name>`, which writes `<name>.sheet.png`: five rows in
  lens order, with a "skipped" row for any missing lens.

## Readability rules

These come from the wave-1 review. The user rated azure and commits-quality "SUPER" and config-read-path "really bad", and sent
promotion-flow, globset-roles, bundle, importer, dependency-groups, auth and runner back for "simplify and verify".

- **Quality bar:** `docs/.assets/commits-quality/commit-lifecycle-states.drawio.png`. It has labelled bands, one direction, short boxes, a
  footer of meanings, and a swatch legend. Read it before drawing.
- **Group-level beats module-level.** If the source has dozens of nodes (e.g. dependencies.yml), draw the groups and point to the config for
  the per-node detail.
- **State a rule once.** Put "no fallback", "never rebuilt" and the like in one side note or bracket, never as a marker on every step.
- **Don't fan arrows.** A box that acts on three targets gets one bracket or band around the targets, not three diagonal arrows.
- **Compact forks.** A Mode → task mapping is one 3-row chip group, not three separate paths.

- **One reading direction.** Use left → right (or top → down) bands, as in commit-lifecycle-states. Never let the flow snake right, then
  down, then left, then back up.
- **No crossing or long diagonal edges.** If an edge must cross the picture, re-lay out the boxes instead.
- **Boxes: one bold name plus ≤ 2 short lines.** Move detail into one footer note. Don't put an ADR code on every box: give one in the title
  or the band label.
- **Bands with labels** (light containers with a caps-style label, e.g. "PROMOTION LADDER — left → right") group the stages.
- **Colour = meaning, and the legend uses swatches** (a small shape plus its text), not a text-only legend. Gates and checks are NOT red.
  Red is only for failure, throw or discard.
- About 12 boxes at most. More than that means the picture is two pictures, or the detail belongs in the ADR.

## Preview tool caveats

The Pillow preview draws dashed outlines, opacity fades and `<font color>` HTML. It does **not** route edges: they come out as straight
centre-to-centre lines, and draw.io routes them orthogonally on open. Lay boxes out so even straight lines don't cross labels: put connected
boxes in line (same row or same column) wherever possible. When an edge must leave a box off-centre, attach it to an invisible 1 px **port
cell** (`text;html=1;strokeColor=none;fillColor=none;`, id `port-<box>-<side>`) placed on that box's edge. The edge then stays straight in
both the preview and draw.io.

## Reporting drift found while verifying

Verification regularly finds the ADR, the code or the code comments out of step: a file the ADR names that doesn't exist, a rule the checker
enforces more loosely, a comment citing the wrong rule. Draw the side the brief says (normally what the code does). List every drift in the
reply and the `.verify.md` table. The lead collects these for the user. Never fix them from a maker.

## Layout

- Leave at least 20 px between boxes. A box is as wide as its longest line × 7 px + 24.
- Use `<br>` to break lines yourself.
- Put a legend (an outer-panel box) bottom-right whenever colour carries meaning.
