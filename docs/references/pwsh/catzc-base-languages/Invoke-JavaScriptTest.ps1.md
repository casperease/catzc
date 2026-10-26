# pwsh/Base.Languages/Invoke-JavaScriptTest.ps1

`Invoke-JavaScriptTest` runs a module's `*.test.js` files with node's own test runner and returns one `JavaScriptTestResult` per test. It
installs no package and runs no npm script.

## help

### synopsis

Runs a catzc module's JavaScript tests with node's own test runner and returns one result per test.

### description

Finds the module's test folder, then runs every `*.test.js` file in it once with `node --test` and its junit reporter, from that folder,
through Invoke-Executable. It runs the managed node by its path: the caller's -NodeExecutable, or the one Resolve-ToolExecutable finds from
its tools.yml entry, never a bare node off PATH. When no managed node is found, it throws with "Run Install-NodeJs". No package is installed
and no npm script runs.

The test folder is the one -Folder names. Otherwise it is the module's own tests/ folder under the JavaScript root, for a js extension. As a
last fallback, it is the module's folder under the root's tests holder (LanguagesConfig.TestFolderOf), named without the namespace its track
declares.

A failing test is a result, not an error. The call throws when the folder is missing or holds no `*.test.js` file, when the junit report
cannot be read, and when node exits non-zero without a failing test.

### parameter `Module`

The catzc module whose JavaScript tests to run (e.g. catzc-track-lamps).

### parameter `NodeExecutable`

The node to run, already located by the caller. Default: located here by Resolve-ToolExecutable.

### parameter `Folder`

The test folder to run, relative to the repository root or absolute. Default: the module's own tests/ folder, else its folder under the
tests holder.

### outputs

`[Catzc.Base.Languages.JavaScriptTestResult]` One record per JavaScript test.

### example 1

```powershell
Invoke-JavaScriptTest catzc-track-lamps
```

## The test folder

The folder is the one named, else the module's own `tests/` (a js module is its kebab folder, `js/<module>/tests`), else the module's folder
under the root's test holder. The root comes from `javascript.yml` (`JavaScriptConfig.ResolveRoot`: the declared root, else `js/` when
present, else `.js/`).

## Namespace in the folder name

A module's folder drops its track's namespace, so the full name resolves to it
([DDR-TRACK-MODULENAMESPACE](../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)): an extension through the js track, and a pwsh
module whose js tests sit in the tests holder through the modules track.
