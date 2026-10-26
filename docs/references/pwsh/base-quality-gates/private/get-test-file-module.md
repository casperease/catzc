# pwsh/Base.QualityGates/private/Get-TestFileModule.ps1

Names the unit a run file belongs to: the first path segment under `pwsh/`, or the module of a language test folder. Per-module protection
uses it to group a run's files by unit.

## help

### synopsis

Names the unit a run file belongs to — the first path segment under pwsh/, or the module of a language test folder.

### description

Maps an absolute run-file path to its owning unit for per-module protection
([ADR-REPO-PROTGLOB](../../../../drs/repository/protected-globs.md)): a module folder name ('Catzc.Base.Globs') or a dot-prefixed infra test
unit ('.internal', '.scriptanalyzer'). A Go or Python test folder (`<root>/tests/<module in kebab case>`, Get-LanguageTestFolders) belongs
to the catzc module it is named for, so its tests protect and invalidate that module.

### parameter `Path`

The absolute path of a file under `<repo>/pwsh/`, or of a language test folder.
