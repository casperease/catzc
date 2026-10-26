# pwsh/Base.Asserts/Assert-LastExitCodeWasZero.ps1

The check a script makes right after a native command: it throws when `$LASTEXITCODE` is not 0, and by default resets it afterwards.

## help

### synopsis

Asserts that $LASTEXITCODE is 0.

### description

Checks the global $LASTEXITCODE variable and throws if it is non-zero.
Resets $LASTEXITCODE after checking unless -DoNotReset is specified.

### parameter `DoNotReset`

Keep $LASTEXITCODE intact after the assertion.

### example 1

```powershell
git status
Assert-LastExitCodeWasZero
```

### example 2

```powershell
Assert-LastExitCodeWasZero -DoNotReset
```
