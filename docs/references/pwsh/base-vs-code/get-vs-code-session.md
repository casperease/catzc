# pwsh/Base.VSCode/Get-VsCodeSession.ps1

The command that describes the VS Code session this pwsh runs in, as a `VscodeSession`.

## help

### synopsis

Describes the VS Code session this pwsh runs in: its host and process, whether its loaded types are current, the type builds and who holds
them, the variables the editor contributed, and the newest PowerShell extension log lines.

### description

Asserts it runs inside VS Code, then gathers what tells why a session in the editor misbehaves:

- the loaded types against the source (Get-LoadedTypeDrift): the loaded hash, the source hash, whether they match, and the drift;
- every committed types build under `.compiled` (`Catzc.Types.*.dll`) and, for each one a process holds open, the holders
  (Get-FileLockingProcess);
- the environment variables VS Code and its extensions contributed (`VSCODE_*`, `TERM_PROGRAM*`, `COPILOT_*`, `PYDEVD_*`, `GIT_ASKPASS`,
  `PYTHONSTARTUP`, `BUNDLED_DEBUGPY_PATH`);
- the newest VS Code log session and the last six start and stop lines of its `PowerShell.log`.

It reads only, and changes nothing.

### parameter `ModulesRoot`

The modules root whose types and `.compiled` builds are read. Default: Get-CatzcModulesRoot.

### parameter `LogRoot`

The VS Code logs folder whose newest session is read. Default: `Code/logs` under the user's application data folder.

### outputs

`[Catzc.Base.VSCode.VscodeSession]` One object with the host name, process id, loaded and source hashes, whether the types are current, the
drift, the committed and held builds, the contributed variables, the log session and its PowerShell log lines.

### example 1

```powershell
Get-VsCodeSession
```
