<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-languages/New-NuGetConfig.ps1.md"
  header: "generated"
---
#>

function New-NuGetConfig {
    [CmdletBinding()]
    [OutputType([string])]
    param()

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
