# pwsh/Base.QualityGates/private/Convert-TestRunLocationPath.ps1

Maps paths between a test run's working folder and the root of the location it runs in. A snapshot run executes the same repository-relative
files under a different root, so test files going in and result paths coming home must be translated.

## help

### synopsis

Maps paths between a test run's working folder and the root of the location it runs in.

### description

A snapshot run executes the same repository-relative files under a different root. Paths under the working folder (SourceRoot) map to the
same relative path under the location's Root, and with -ToSource back again — test files going into a run, and the rows' File paths coming
home so reports and module protection read working-folder paths. A path outside the root (a fixture in a temp folder), an empty value, and
every path of an in-place location pass through unchanged.

### parameter `Location`

The location Enter-TestRunLocation returned.

### parameter `Path`

The paths to map.

### parameter `ToSource`

Map from the location's Root back to the working folder.

### outputs

`[string]` one mapped path per input path, in order.
