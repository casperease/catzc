# pwsh/Base.Maps/types/SquarifiedTreemap.cs

A deterministic squarified treemap: it tiles a bounding box with one rectangle per item, each with an area proportional to the item's
weight. The world map's tree view lays out the tracks by file count with it, and each track's cells inside the track's rectangle.

## How it tiles

Items are added to a row along the box's shorter side only while that keeps the row's worst aspect ratio from growing, so the rectangles
stay close to square. A row is laid as a column at the left of a wide box (top to bottom) or a band at the top of a tall one (left to right).
The last row takes the whole remaining box, so rounding never leaves a sliver or overflows the bounds.

## Deterministic

The result depends only on the input. The items are taken heaviest first, ties broken by the ordinal order of their keys, so the same
weights give the same rectangles whatever order they arrive in. `Layout` returns the rectangles of the items with a positive weight inside
the box (x, y is its bottom-left corner), heaviest first. An item of weight zero gets no rectangle. A negative, NaN or infinite weight, a
duplicate or empty key, or an empty box throws.

## Why it is shaped so

It uses the BCL only
([ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES](../../../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-hostguaranteedassemblies)).
