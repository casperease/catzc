# pwsh/.internal/tests/Invoke-ModuleBuild.Tests.ps1

<!-- cspell:ignore nfunction dependenc -->

The tests of `Invoke-ModuleBuild`, run against a committed fixture repository so the build reads what git stores.

## Tier

The fixture repository is committed with real git, so the point of the file is the launch: L2. Without git the whole file skips
(`tool_git_missing`).

## The fixture tree

A neutral fixture tree holds two selectable modules (widget and gadget), one that is never selected (gizmo, which also carries every
merge-precondition violation), and stand-ins for the infrastructure the build ships. The gadget module reaches into widget twice, a call and
a config read, which is what the closure check follows; the owner-scoped read (`-ListOwners`) reads only the owners present, so it is not a
third gap.

The build ships what git tracks, so the fixture is a committed repository. `core.autocrlf=true` is a Windows checkout: the CRLF fixture
files (the help text, the initializer) are stored LF, as git stores them in the real repository, and the checkout keeps them CRLF on disk.

## Boundaries

`Assert-SourceTree` is mocked because the fixture root is not the session's code root; the profile and closure resolver and the asset
inventory both read the real configs and tree, and so does git.

## Whole-tree walks

Two helpers walk the whole tree
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): the snapshot
compares every file of a build, and the assertions cover every file of the build, so nothing is pruned.
