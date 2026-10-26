# pwsh/Base.Asserts/Assert-LastExitCodeWasZero.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
