function New-NuGetConfig {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    # Package and audit feeds are cleared, so no dotnet run reaches a package manager.
    @'
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
  </packageSources>
  <auditSources>
    <clear />
  </auditSources>
</configuration>
'@ + "`n"
}
