# pwsh/Base.Asserts/Assert-PathExist.ps1

The throwing check that a filesystem path exists, of the kind `Any`, `Container` or `Leaf`. It throws the caller's `-ErrorText`, or a
default message naming the path.

## help

### synopsis

Asserts that a filesystem path exists.

### parameter `Path`

The path to test.

### parameter `PathType`

The kind of path to require: Any (default), Container, or Leaf.

### parameter `ErrorText`

Optional message to throw instead of the default.

### example 1

```powershell
Assert-PathExist './config.json'
```

### example 2

```powershell
Assert-PathExist './src' -PathType Container
```

## Why a truth test picks the message

The message is chosen with `if ($ErrorText)`, never `$ErrorText ?? ...`. A `[string]` parameter turns `$null` into `''`, and `??` only
coalesces `$null`, so the default would never apply and the throw would be blank
([automatic-variable-pitfalls](../../../drs/automation/pwsh/automatic-variable-pitfalls.md)).
