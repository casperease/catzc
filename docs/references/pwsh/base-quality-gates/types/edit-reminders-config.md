# pwsh/Base.QualityGates/types/EditRemindersConfig.cs

The typed record for the reminders an agent session is shown after it edits a file: one map from repository path patterns to the checks that
file's edit owes. The `Show-EditReminder` hook reads it (PDR-POKAYOKE). It is declared as config, one mechanism with an entry per kind of
file (PDR-CONFIG).
