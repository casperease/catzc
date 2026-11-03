# pwsh/Base.QualityGates/private/Get-TestDiscovery.ps1

Discovers the tests of the given test paths and returns them as rows. Test-Automation shares that single result between its pre-run
inspections, and a file whose content has not changed since an earlier run is read back from a cross-session file, not discovered again.

## help

### synopsis

Runs a discovery-only Pester pass over the given test paths and returns the result.

### description

The single discovery pass Test-Automation shares between its pre-run inspections: Get-TestTagViolations (the mandatory tier/category check)
and Split-TestAutomationFiles (the phase split) both consume the one result, so the tree is discovered once per run, not once per question.
Run.SkipRun makes it inspect every test regardless of tag filters — nothing executes. Each test file is keyed on its repository-relative
path and content digest (DurableHash) in out/cache/test-discovery.json (ADR-AUTO-CACHE-CROSSSESSIONFILES); one Pester pass runs over the
files without a hit, and an empty miss set runs none. The file is written once when it gained entries, through a temporary file moved over
it; an older digest of the same path is dropped, other paths stay, and an unreadable file is rebuilt. A row carries Tag, Block (Tag, IsRoot,
Parent, and the container data of a Go bridge test), ScriptBlock (File, StartPosition.StartLine), ExpandedName, ExpandedPath, Result,
Duration and ErrorRecord, the members the readers use. A language test folder (go, python, javascript, bash) is discovered through the
language bridge (ConvertTo-PesterRunTarget) and cached in the same file under its repository-relative folder and a digest: DurableHash over
the sorted relative paths and file digests of what its lister reads (the folder's test files by the language's filter, the go.mod of a Go
folder) and the bridge script. A changed test file, go.mod or bridge re-discovers that folder only, and the cached rows keep the container
folder (Block.BlockContainer.Data['TestFolder']). Pester must already be loaded (Test-Automation lazy-loads it before calling this).

### parameter `TestPath`

One or more 'tests' folders, or Go test folders, to discover.

### outputs

An object whose Tests property holds one row per discovered test, none run, in the order of the test paths.
