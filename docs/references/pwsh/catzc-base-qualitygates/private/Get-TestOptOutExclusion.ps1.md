# pwsh/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the tests a test run's opt-out tag removes from a run, so the exclusion is visible, never silent.

### description

The build run (Test-CatzcBuild) excludes every test tagged 'source-only'
([ADR-AUTO-TEST#31](../../../../adr/automation/test-automation.md#rule-adr-auto-test31)) and must count and list each one it leaves out.
This walks the run's discovery and returns, for every test in the run's files that resolves to the tag along its block chain
(Get-TestBlockTag — own It-tags, then each ancestor), one row — but only when the run would otherwise have executed it: a test whose tier or
category is already excluded by the run's level/category filter is out of scope either way, so it is neither listed nor counted. It also
returns the files left with nothing to run (every in-scope test carries the tag), which the caller drops from the work-list so no worker
loads the modules for an empty file.

### parameter `Discovery`

The run's discovery-only Pester result (Get-TestDiscovery).

### parameter `Tag`

The opt-out tag(s) — 'source-only' for the build run.

### parameter `ExcludeTag`

The run's tier/category exclude tags (Get-TestExcludeTag); tests resolving to one of them are out of scope.

### parameter `TestFiles`

The run's test files; tests outside them are ignored.

### outputs

`[pscustomobject]` with Tests (rows of File, ExpandedPath, Level, Category, in discovery order), FullyExcludedFiles (files whose every
in-scope test carries the tag), and RemainingFiles (-TestFiles without them, order kept).

## comment:1

Above `foreach ($test in @($Discovery.Tests)) {`, written with `#`.

```text
Get-TestBlockTag returns its matches as ONE array object (`, $ret`), so its result is used as-is, never
wrapped in @() — that would nest it and every count would read 1.
```
