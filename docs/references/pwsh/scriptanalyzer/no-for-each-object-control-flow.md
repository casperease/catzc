# pwsh/.scriptanalyzer/NoForEachObjectControlFlow.psm1

The custom analyzer check `Measure-NoForEachObjectControlFlow`: `return`, `break` and `continue` are forbidden inside a `ForEach-Object`
scriptblock.

## Why

Inside a `ForEach-Object` scriptblock `return` acts like `continue` and `break` ends the script, unlike in a `foreach` loop.

## How it looks

1. It finds every `ForEach-Object` and `%` command invocation.
2. It collects the scriptblock arguments of the call: the `-Process`, `-Begin` and `-End` blocks, or positional scriptblocks.
3. In each block it finds the `return`, `break` and `continue` statements that are direct children of that block, not inside a nested
   `foreach`, `for`, `while`, `do`, `switch`, function or scriptblock, where they would be valid.
4. For each statement it walks up the syntax tree to see whether a loop, switch or function sits between the statement and the scriptblock.
   If one does, the keyword targets that construct, not the scriptblock, and is not flagged.

## Predicates

The predicates are locals, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
