function New-NuGetConfig {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    # Package and audit sources are cleared, so no dotnet run in the repository reaches a package manager; the allowed set is empty today.
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
