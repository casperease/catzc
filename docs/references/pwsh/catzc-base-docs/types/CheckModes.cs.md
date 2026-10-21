# pwsh/Catzc.Base.Docs/types/CheckModes.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The one parser of a check's mode setting (CheckMode), shared by every check config: adr-checks.yml in Catzc.Base.Docs, and
links.yml and source-conventions.yml in Catzc.Base.QualityGates. One parser keeps one accepted spelling and one error text
([PDR-ONELIVE-ONEVERSION](/docs/adr/principles/one-living-version.md#rule-pdr-onelive-oneversion)). An omitted mode is
default(CheckMode), Gate, the default CheckMode declares once
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
```

## comment:2

Above `public static CheckMode Parse(IDictionary raw, out string error)`, written with `//`.

```text
The mode under the 'mode' key of a check's settings map, matched by name, case-insensitively; raw may be null. An
omitted or null mode is default(CheckMode). A value that names no mode returns default(CheckMode) and sets error to
the one message for it; otherwise error is null.
```
