# pwsh/Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1

The test of scope isolation ([DDR-RUNMODE-OWNSCRIPTSCOPE](../../../../drs/design/run-modes.md#rule-ddr-runmode-ownscriptscope)): two catzc
modules that hold a `$script:` variable of the same name never see each other's value, in either run mode. The probe variable name is the
test's own and is removed afterwards, and no module code reads it. The modules are chosen generically, the first two loaded catzc modules by
name, never by a production identity.

## The probe

The shared probe block sets the probe in each module's script scope, reads every module's variable and the global one back, then removes the
probes. It is self-contained, so it also runs in a child pwsh.

## Two contexts

The loaded-session context runs in-process, in whichever mode the session runs: the source run proves the source mode, and the build run,
where this file runs against the built modules, proves build mode.

The fresh-build context enters a fresh build in a child pwsh. It is source-only, because it builds from the source tree itself
(`Build-Modules` needs the per-function files) and isolates the build in its own process, so the answer does not depend on the mode of the
session running it. It is greedy, at the cost of one build plus one importer-loading child pwsh.
