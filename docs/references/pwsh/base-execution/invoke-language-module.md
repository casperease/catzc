# pwsh/Base.Execution/Invoke-LanguageModule.ps1

The one runner of a shipped language module, whatever its language, resolved from what the module's folder holds.

## help

### synopsis

Runs a language module from its folder with the runner its packaged or source form calls for.

### description

Resolves the module folder from `<track place>/<Module>` and picks the runner in one order: `wheels.json` (a venv made offline from the
shipped wheels with the managed uv, redone when the manifest changed), `binaries.json` (the binary for the host platform),
`executables.json` (the one listed script under bash), `go.mod` (`go run .`), then a single `*.sh`, or an `index.js` or `extension.js` under
the managed node. A folder with none of these throws, as does a missing or unpinned tool. The command then runs in the working directory,
which defaults to the module folder for a folder-bound runner and to the repository root otherwise.

### parameter `Module`

The module as `<track place>/<Module>`: the last segment is its folder name and the rest its place.

### parameter `Arguments`

The arguments passed to the module's program; an argument that holds whitespace is quoted.

### parameter `WorkingDirectory`

The directory the program runs in, instead of the default.

### parameter `PassThru`

Passed to Invoke-Executable, which then returns the run result.

### parameter `Silent`

Passed to Invoke-Executable, which then keeps the program's output off the console.

### example 1

```powershell
Invoke-LanguageModule 'go/widget' -Arguments '--version' -PassThru
```
