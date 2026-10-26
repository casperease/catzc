# pwsh/Base.RootConfig/tests/Build-RootConfig.Tests.ps1

<!-- cspell:ignore nbeta nmodule -->

The tests of `Build-RootConfig`: they materialise fixture registries into a fixture repository root and read what was written.

## Isolation

The tests isolate through the seams
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)): they
mock the config seam (`Get-Config`) and the generator dispatch, and redirect the repository root to a fixture tree (TestKit) so
`Resolve-RepoPath` binds inside it.

## Links

A target left as a link reads the same as its source, so only the is-link check converts it into an independent file, and the source is
never written through it.

## Wildcard entries

A wildcard entry's generator renders one `{ Target; Content }` record per file; every file is written on its own and reported in its own
row. The fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

## The wiring

The wiring the L0 tests mock away on both sides: a fixture registry names `New-GoWorkspace`, the real dispatch calls it, and
`Build-RootConfig` writes what it renders. Only the registry, the run mode and the go pin are mocked, so the result is independent of the
shipped config ([ADR-AUTO-TEST-LOGICANDINTEGRITY](../../../../drs/automation/test-automation.md#rule-adr-auto-test-logicandintegrity)).

## The warm-run skip

The warm-run skip reads the one writer memo: the fixture declares the writer's inputs (its source and both targets), and the memo stays
inside the fake root.

## The generated head

The pattern of the generated head a generator's file carries is matched over the content the generator rendered; the body hash is any 12 hex
digits. `-DryRun` composes every opted-in target's content, so a source file that is missing, or an unknown generator, throws.
