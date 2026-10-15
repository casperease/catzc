---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/SquarifiedTreemap.cs.md
    kind: reference
    body_sha: "0f212045c983"
    adrs:
      - ADR-PWSH-TYPES#1
---

# automation/Catzc.Base.Maps/types/SquarifiedTreemap.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A deterministic squarified treemap: it tiles a bounding box with one rectangle per item, each with an area
proportional to the item's weight, and adds items to a row along the box's shorter side only while that keeps the
row's worst aspect ratio from growing, so the rectangles stay close to square. The world map's tree view lays out the
tracks by file count with it, and each track's cells inside the track's rectangle.

The result depends only on the input: the items are taken heaviest first, ties broken by the ordinal order of their
keys, so the same weights give the same rectangles whatever order they arrive in. An item of weight zero gets no
rectangle; a negative, NaN or infinite weight, a duplicate or empty key, or an empty box throws. BCL only
([ADR-PWSH-TYPES#1](/docs/adr/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types1)).
```

## comment:2

Above `public static TreemapRect[] Layout(string[] keys, double[] weights, double x,...`.

```text
The rectangles of the items with a positive weight inside the box (x, y is its bottom-left corner), heaviest
first, ties in ordinal key order.
```

## comment:3

Above `private static void Place(List<int> row, string[] keys, double[] weights,...`.

```text
Lays a row along the shorter side of the remaining box: a column at the left of a wide box (top to bottom), a band
at the top of a tall one (left to right). The last row takes the whole remaining box, so rounding never leaves a
sliver or overflows the bounds.
```
