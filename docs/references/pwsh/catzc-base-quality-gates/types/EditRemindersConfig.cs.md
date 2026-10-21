# pwsh/Catzc.Base.QualityGates/types/EditRemindersConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The reminders an agent session is shown after it edits a file: one map from repository path patterns to the checks that file's edit owes,
read by the Show-EditReminder hook (PDR-POKAYOKE) and declared as config, one mechanism with an entry per kind of file (PDR-CONFIG).
```
