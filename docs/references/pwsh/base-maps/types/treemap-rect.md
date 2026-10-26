# pwsh/Base.Maps/types/TreemapRect.cs

One rectangle of a `SquarifiedTreemap` layout: the item it stands for (its key and weight) and where it sits, in PDF user space, where x and
y are the bottom-left corner in points. It is a result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
