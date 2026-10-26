# pwsh/.scriptanalyzer/VariableCasing.psm1

The custom analyzer check `Measure-VariableCasing`: the variable casing conventions.

## The conventions

- A parameter starts with an uppercase letter.
- A scoped variable (`script:`, `global:`, `private:`) starts with an uppercase letter.
- A local variable starts with a lowercase letter.

## What is skipped

Scriptblock parameters and automatic variables are skipped, as their names are not the author's choice. The skip set of automatic,
preference and well-known variables mirrors the one in `SpellOutIdentifiers.psm1`.

A scriptblock parameter, such as `{ param($n) … }` in a `FindAll` predicate, is told from a function parameter by the position of its block
in the syntax tree:

- Named function: ParamBlockAst, ScriptBlockAst, FunctionDefinitionAst.
- Scriptblock: ParamBlockAst, ScriptBlockAst, ScriptBlockExpressionAst.

## Predicates

The predicates are locals, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
