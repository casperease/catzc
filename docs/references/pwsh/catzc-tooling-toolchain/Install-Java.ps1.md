# pwsh/Tooling.Toolchain/Install-Java.ps1

The installer of Microsoft OpenJDK through the platform package manager, which also points `JAVA_HOME` at the install.

## help

### synopsis

Installs Microsoft OpenJDK via the platform package manager.

### description

After installation, sets JAVA_HOME for the current session and persists it for future sessions (User registry on Windows, $PROFILE on Unix).
Modeled on Install-Dotnet / DOTNET_ROOT. Idempotent — skips if already installed at the correct version.

### parameter `Version`

Java version to install. Defaults to the locked version in Get-ToolConfig.

### parameter `Force`

Replace an existing installation at the wrong version.

### example 1

```powershell
Install-Java
```

### example 2

```powershell
Install-Java -Version '21'
```

## JAVA_HOME

`JAVA_HOME` is set for the current session. Each change is announced where it happens, and only when it changes something
([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](../../../drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)).
