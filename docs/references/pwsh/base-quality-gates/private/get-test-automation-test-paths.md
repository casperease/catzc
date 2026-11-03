# pwsh/Base.QualityGates/private/Get-TestAutomationTestPaths.ps1

Lists the run's test paths, tests folders and language test folders, foundation first: modules in dependency order, infrastructure last.

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

## Build mode

In build mode (`Get-CatzcRunMode`) the paths are the working root's own: the `tests/` folder of every folder under a place of every
`modules` track `Get-Track` lists except the engine's `pwsh` (found by layout, as the importer finds them, since the module-type places of
`Get-CatzcModule` name catzc's own roots, never a consumer track's), then the `tests/` folder of each `.catzc/` override folder (filed under
the bundled module it overrides, and run after it in the module order), and nothing of the bundle, which ships no tests
([ADR-AUTO-CONSUMER-CATZCGATES](../../../../drs/automation/consumer-repository.md),
[ADR-AUTO-OVERLAY](../../../../drs/automation/consumer-overlay.md)). The language test folders are not listed in build mode. `-Modules`
narrows by full module name as in source mode.

## Language test folders

The language test folders (Go, then Python) each come after their module's tests folder. Get-LanguageTestFolders throws on a folder that
matches no module.

## comment:1

Above `$allDirs = $isBuild ? @() : @(Get-ChildPath $modulesRoot -Depth 1 -Directory...`, written with `#`.

```text
Source mode: every module folder, the dot folders too, since their tests run as the infrastructure tests.
Build mode: the bundle ships no tests, so the working root's own tracks and the overlay take its place.
```

## comment:2

Above `$consumerTracks = @(Get-Track).Where({ $_.type -ceq 'modules' -and $_.name...`, written with `#`.

```text
The consumer's modules are found by layout, a folder under a place of its module track, as the importer finds them: the
module-type places name catzc's own roots, so Get-CatzcModule does not see a consumer track's places.
```
