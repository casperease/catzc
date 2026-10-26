# pwsh/Base.QualityGates/private/Test-TestInRunScope.ps1

Tells whether a discovered test is inside a test run's tier and category scope.

## help

### synopsis

Whether a discovered test is inside a test run's tier and category scope.

### description

A test is in scope when neither its tier nor its category — each resolved along its block chain (Get-TestBlockTag, nearest contributing
block wins) — is one of the run's exclude tags (Get-TestExcludeTag). The one scope check behind the work-list's scope filter
(Select-InScopeTestFiles) and the opt-out exclusion (Get-TestOptOutExclusion), so both agree on which tests a run would execute.

### parameter `Test`

A test from the run's discovery-only Pester result (Get-TestDiscovery).

### parameter `ExcludeTag`

The run's tier/category exclude tags.

### outputs

`[bool]`

## Tag matches

Get-TestBlockTag returns its matches as one array object. The result is used as it is and never wrapped in `@()`, since that would nest it
and every count would read 1.
