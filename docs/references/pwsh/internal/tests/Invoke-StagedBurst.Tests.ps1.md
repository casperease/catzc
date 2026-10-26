# pwsh/.internal/tests/Invoke-StagedBurst.Tests.ps1

The tests of `Invoke-StagedBurst`, which swaps staged files in, runs commands under one import and restores on failure.

## Isolation

Each test has a repository root, a stand-in importer and a run lock of its own, so a real run on the machine never touches them.

## The command run

The real `Invoke-CatzcCommand.ps1` runs the one fixture command: its switches bind by name and are never taken for commands.

## Deleting without swapping

Only the marker is staged, so the delete tests remove files without swapping, unless one stages the gadget back itself.
