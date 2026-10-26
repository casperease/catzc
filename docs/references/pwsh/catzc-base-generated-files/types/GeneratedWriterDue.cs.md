# pwsh/Base.GeneratedFiles/types/GeneratedWriterDue.cs

The result of `Get-GeneratedWriterDue` for one writer: what the generated-files registry says about it for a changed set.

## Properties

- **`Name`** — the writer.
- **`Due`** — whether its dry run is due.
- **`HasLists`** — whether it declares input or output lists at all. A writer with none runs whenever anything changed, and the import
  janitor runs it always, so a caller uses `HasLists` to tell "nothing changed" from "this writer cannot say".
