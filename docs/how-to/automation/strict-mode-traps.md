# Avoid three strict-mode traps

Every catzc file runs under `Set-StrictMode -Version Latest`. Three PowerShell behaviours pass a quick read and then fail under it, or
return the wrong count. Each one below shows the trap and the form that works.

## An `if` that yields an empty array gives `$null`

```powershell
$widgets = if ($any) { @() } else { Get-Widget }
$widgets.Count   # throws under strict mode: $widgets is $null
```

The pipeline unrolls the empty array, so the assignment gets nothing. Wrap the whole expression instead:

```powershell
$widgets = @(if ($any) { @() } else { Get-Widget })
```

## A unary comma return counts as one item under `@()`

```powershell
function Get-Gadget { , @('alpha', 'beta', 'gamma') }
@(Get-Gadget).Count   # 1, not 3
```

The comma keeps the array whole through the pipeline, and `@()` then wraps that one array. A function whose callers wrap it in `@()` returns
its items plainly (`'alpha', 'beta', 'gamma'`). Keep the comma only where a caller assigns the result directly and needs an array of one or
none.

## `.ForEach` on a .NET `List` binds `List<T>.ForEach`

```powershell
$list = [System.Collections.Generic.List[int]]::new()
$list.Add(1)
$doubled = $list.ForEach({ $_ * 2 })   # throws: $_ is not set; returns nothing
```

The method lookup finds `List<T>.ForEach(Action<T>)` before PowerShell's own `.ForEach()`, so the script block runs as an action with its
argument in `$args[0]`, never in `$_`, and nothing comes back. Use the `foreach` statement
([prefer-foreach-over-foreach-object](../../drs/automation/pwsh/prefer-foreach-over-foreach-object.md)):

```powershell
$doubled = foreach ($item in $list) { $item * 2 }
```
