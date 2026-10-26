# pwsh/Tooling.Listen/tests/Listen.Fixture.ps1

The shared fixture of the listen tests, dot-sourced from each test file's `BeforeAll`. `Initialize-ListenFixture` builds a repository in
`TestDrive` with a watched docs folder and a fast config, and the mocks that bind the module to them; a test calls it once when it needs a
fresh tree.

## What it sets up

- **A watched docs folder** in `TestDrive` with short timings, so a listen test never touches the real tree or waits on real timers.
- **The committed reference**: `New-RepositorySnapshot` is mocked to return the fixture's files as committed, plus a code file and a binary
  one outside the watched folder.
- **The diff**: `Get-ListenDiff` launches git (`git diff --no-index`), which the fast tiers never do
  ([ADR-AUTO-TEST-PROCESSTRIPWIRE](../../../../drs/automation/test-automation.md)). A stand-in diffs the two sides' lines in memory and
  yields the same shape: the one hunk from its header on, empty when the sides are equal.
