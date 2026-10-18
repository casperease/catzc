# automation/Catzc.Base.Reports/types/OutputFormat.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One entry of configs/output-formats.yml: a declared kind of file a producer writes under the output root
([ADR-REPO-OUTFMT#1](/docs/adr/repository/output-formats.md#rule-adr-repo-outfmt1)). Constructing one MAPS and
VALIDATES the entry, collecting every violation into one throw:
  - the id (its map key) is kebab-case;
  - only the keys patterns, target, producer, audience, validator, limits;
  - `patterns` is a non-empty list of output-root-relative globs in the OutputPattern grammar ('*' and '?'
    inside one segment, '**' any depth, '{stamp}' one stamped folder);
  - `target` is 'file' (the default) or 'folder' (the pattern names a folder, checked as one unit);
  - `producer` (the function or script that writes it) and `audience` (who opens it, with what) are required;
  - `validator` is a map with a known `kind` and only that kind's parameters, its required ones present
    ([ADR-REPO-OUTFMT#3](/docs/adr/repository/output-formats.md#rule-adr-repo-outfmt3));
  - `limits` holds only known limit names, each a positive whole number
    ([ADR-REPO-OUTFMT#5](/docs/adr/repository/output-formats.md#rule-adr-repo-outfmt5)).
That no two formats' patterns overlap spans entries, so OutputFormatsConfig checks it. Mirrors the YAML mapping
(snake_case keys, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
