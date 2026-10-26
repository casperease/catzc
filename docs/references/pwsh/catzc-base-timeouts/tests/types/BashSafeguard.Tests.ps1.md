# pwsh/Base.Timeouts/tests/types/BashSafeguard.Tests.ps1

<!-- cspell:ignore tmain tforeground tbackground tsleep tsubagent tpipeline -->

The tests of `BashSafeguard`, the hook's verdict on a bash call: each bash case checks the denial the hook words for its verdict.

## The cases

The command grammar's cases live in the per-engine fixture table, one source for `BoundedCommand` and this hook.
