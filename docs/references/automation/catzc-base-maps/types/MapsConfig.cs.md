---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/MapsConfig.cs.md
    kind: comment-page
    body_sha: c9cc3f76b71d
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
      - ADR-REPO-OUTDIR#2
---

# automation/Catzc.Base.Maps/types/MapsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The map settings (configs/maps.yml): the palette, the limits, the printed labels of the world map and the value-chain
map, the reviewed highlight pins and exceptions, and the output folder the PDFs land in under Get-OutputRoot
([ADR-REPO-OUTDIR#2](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir2)). Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Maps.MapsConfig), so Get-Config -Config maps returns this
typed record. Property names mirror the YAML keys (snake_case,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Every key has a sensible default, declared once on the type that holds it
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): MapsPalette, MapsLimits,
MapsLabels, and here the output folder. An empty file means the defaults; a file sets a key only to change it.

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - only the known keys, at the top and in each section; an unknown key (a typo) fails at load;
  - a section is a mapping, and highlight.pins / highlight.exceptions are lists of { adr, track, file_language, reason };
  - a colour is '#' and six hex digits (e.g. #DCE6F0);
  - a size is a positive number, and a label length a positive whole number;
  - a label is one non-empty line of WinAnsi text, the only text the base-14 PDF fonts show (WinAnsi), and a row or
    column header of the world map fits its limit (row_axis and root_files within max_row_label, column_axis and
    unlisted_files within max_column_label); the value_chain_ labels have no length limit;
  - output_folder is one path segment;
  - a pin names an ADR code (optionally #n), a track name, a kebab-case file language and a reason;
  - highlight.citation_exclude is a list of repository-relative, '/'-separated globs.
```
