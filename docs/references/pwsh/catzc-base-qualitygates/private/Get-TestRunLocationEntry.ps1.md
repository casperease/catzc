# pwsh/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the entry script a test run's workers load, for the location the run executes in.

### description

The run seam ([ADR-AUTO-TEST-SAMETESTSBOTHRUNS](../../../../adr/automation/test-automation.md#rule-adr-auto-test-sametestsbothruns)) names the script each worker
dot-sources to load the modules: empty for the source importer, the build's Import-Catzc.ps1 for the build run. A snapshot run
(Enter-TestRunLocation) must load from the snapshot so that every path a worker resolves — out/, .compiled, git — lands inside it
([ADR-AUTO-NOPWD](../../../../adr/automation/never-depend-on-pwd.md)):

- in place: the entry passes through unchanged;
- snapshot, source run: the snapshot's own importer, without janitors;
- snapshot, a run's own entry script: kept (it lives outside the repository), with every repository path among its arguments (the build
  run's RepositoryRoot) mapped into the snapshot.

### parameter `Location`

The location Enter-TestRunLocation returned.

### parameter `EntryScript`

The test run's entry script; empty for the source importer.

### parameter `EntryParameter`

Named arguments for -EntryScript.

### outputs

`[hashtable]` @{ EntryScript; EntryParameter }, ready to splat into New-TestAutomationShardScript.
