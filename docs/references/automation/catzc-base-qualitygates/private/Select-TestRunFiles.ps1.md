# automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Chooses a test run's test files: every file under the test paths, narrowed by rule, by tier and category scope, and by the run's opt-out
tag.

### description

The work-list stage of a test run (Invoke-TestRun), in order:

- the test files under the test paths, in foundation-first folder order (Get-TestAutomationTestFiles);
- -Rule: only the files carrying a test that cites one of the given ADR rules (Select-RuleTaggedFiles). The worker also filters within a
  file by include tag, so a file mixing matched and other tests runs only the matched ones;
- tier and category scope: only the files holding a test in the run's scope (Select-InScopeTestFiles), so no worker loads a file only to
  skip every test in it. The dropped files' tests come back as the NotRun rows a worker would have returned
  (ConvertTo-TestAutomationRowSet), for the caller to report;
- the opt-out tag (the build run's 'source-only', [ADR-AUTO-TEST#31](../../../../adr/automation/test-automation.md#rule-adr-auto-test31)):
  its tests are excluded, files left with nothing to run are dropped, and every excluded test is counted and listed — never silently
  (Get-TestOptOutExclusion, Write-TestOptOutExclusion).

Throws when -Rule or the opt-out tag leaves nothing to run. Tier and category scope may leave nothing; the run is then vacuously green, with
every test reported as NotRun.

### parameter `TestPath`

The run's 'tests' folders.

### parameter `Discovery`

The run's discovery-only Pester result (Get-TestDiscovery).

### parameter `Rule`

The wanted ADR rule citations ('`ADR-<CODE>#<n>`'); empty for no rule filter.

### parameter `ExcludeTag`

The run's tier/category exclude tags (Get-TestExcludeTag).

### parameter `OptOutTag`

The run's opt-out tag(s); empty for none.

### parameter `RunDirectory`

The run's folder, where the opt-out exclusion list is written.

### parameter `EntryPoint`

The entry point's name, for the error when the opt-out tag leaves nothing to run.

### outputs

`[pscustomobject]` with Files (the work-list, in run order), ExcludeTag (the exclude tags plus the opt-out tag), OutOfScopeRows (NotRun rows
for the scope filter's dropped files), and OptOutExcludedTests.
