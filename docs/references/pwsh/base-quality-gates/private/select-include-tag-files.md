# pwsh/Base.QualityGates/private/Select-IncludeTagFiles.ps1

Returns the subset of test files that carry an in-scope test with one of the given tags. It is the work-list filter behind Test-Automation's
`-PostBuild` switch, which narrows a run to the files that hold post-build tests.

## help

### synopsis

The subset of test files that carry an in-scope test tagged with one of the given tags — the -PostBuild work-list filter.

### description

The post-build run selects only the tests tagged `post-build`
([ADR-AUTO-TEST-POSTBUILDTAG](../../../../drs/automation/test-automation.md#rule-adr-auto-test-postbuildtag)). Given the discovery pass and
the wanted tags, this returns the files in which at least one test inside the run's tier and category scope resolves one of those tags along
its block chain (Get-TestBlockTag). The worker additionally filters within a file by include tag; this just keeps whole files without a
tagged test off the work-list.

### parameter `TestFile`

The candidate test files (absolute `*.Tests.ps1` paths), in run order.

### parameter `Discovery`

The discovery-only Pester run object whose tests carry the tags.

### parameter `Tag`

The wanted tags. A file is kept when one of its in-scope tests carries any of them.

### parameter `ExcludeTag`

The tier and category tags the run leaves out; a test they exclude does not count.

### outputs

`[string[]]` the kept files, preserving the input order (empty when none match).
