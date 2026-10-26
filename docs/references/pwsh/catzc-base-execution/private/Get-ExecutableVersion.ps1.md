# pwsh/Base.Execution/private/Get-ExecutableVersion.ps1

The version probe of the existence check: it runs one located executable's version command and parses the output. It is the only place the
check starts a process.

## help

### synopsis

Runs one located executable's version command and returns the parsed version — the probe's only process start.

### description

Runs the executable at -Path (never whatever its bare name resolves to on PATH) with -Arguments, once, in the executable's own folder, and
matches the merged output against -Pattern. Returns the captured named group (`?<ver>`...), or $null when the output does not match.
Find-Executable calls it at most once per executable file per session.

### parameter `Path`

The located executable's full path.

### parameter `Arguments`

The arguments that make the executable print its version (e.g. '--version'). Empty for none.

### parameter `Pattern`

The regex that captures the version as the named group (`?<ver>`...).

### example 1

```powershell
Get-ExecutableVersion -Path 'C:\Program Files\Git\bin\bash.exe' -Arguments '--version' -Pattern 'version (?<ver>[\d.]+)'
```

## Where it runs

The command runs in the executable's own folder, never in the repository. A tool that reads project files from its working directory (go's
`go.work` toolchain line, dotnet's `global.json`) would otherwise report, or even download, the version the project asks for instead of the
version the located binary is. It also runs the located path, quoted, never the bare name.
