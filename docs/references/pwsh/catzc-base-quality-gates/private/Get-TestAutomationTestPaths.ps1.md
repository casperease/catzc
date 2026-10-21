# pwsh/Catzc.Base.QualityGates/private/Get-TestAutomationTestPaths.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the run's test paths — tests folders and language test folders — foundation-first: modules by dependency order, infrastructure last.

### description

Discovers every `pwsh/<dir>/tests` folder in a single .NET directory scan — one enumeration instead of two Get-ChildItem passes, with no
pipeline/object overhead (and fewer filesystem round trips on network-backed repos, see effective-in-enterprises). A module's Go and Python
test folders (`<root>/tests/<module` in kebab case>/, Get-LanguageTestFolders) belong to that module and follow its tests folder; a module
with only such tests is included by them. A test folder that matches no catzc module throws, naming the folder. Module tests come
FOUNDATION-FIRST (Get-ModuleOrder — a topological sort of the declared dependency graph), so a broken base module's failures surface before
the dependents that cascade from it; dot-prefixed infrastructure (.internal, .scriptanalyzer) follows, ordinally. Best-effort on the order:
if the graph cannot be sorted (a malformed or cyclic dependencies.yml, which its OWN tests then report), it falls back to the ordinal order
so the test run still proceeds rather than the runner crashing on the config it is testing.

### parameter `Modules`

Narrow to the named modules' tests folders and language test folders. Dot-prefixed infrastructure is never a named module, so it is included
only in the unfiltered case. Empty (the default) includes everything.

### outputs

`[string[]]` the test paths, foundation-first, infrastructure last. Empty when nothing matches.

## comment:1

Above `foreach ($testFolder in @(Get-LanguageTestFolders)) {`, written with `#`.

```text
The language test folders (Go, then Python), each after its module's tests folder (Get-LanguageTestFolders
throws on an unmatched folder).
```
