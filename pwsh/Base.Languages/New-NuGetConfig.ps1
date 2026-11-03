function New-NuGetConfig {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    # The configured source is the one package feed; the audit feeds are cleared, so no dotnet run reaches a vulnerability service.
    $source = (Get-Config -Config bcl).package_source
    $key = [System.Security.SecurityElement]::Escape($source.name)
    $url = [System.Security.SecurityElement]::Escape($source.url)

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('<?xml version="1.0" encoding="utf-8"?>')
    $lines.Add('<configuration>')
    $lines.Add('  <packageSources>')
    $lines.Add('    <clear />')
    $lines.Add("    <add key=`"$key`" value=`"$url`" />")
    $lines.Add('  </packageSources>')
    if ($source.credential_env) {
        # NuGet expands the variable reference itself; the file never holds a value.
        $variable = [System.Security.SecurityElement]::Escape($source.credential_env)
        $lines.Add('  <packageSourceCredentials>')
        $lines.Add("    <$key>")
        $lines.Add('      <add key="Username" value="token" />')
        $lines.Add("      <add key=`"ClearTextPassword`" value=`"%$variable%`" />")
        $lines.Add("    </$key>")
        $lines.Add('  </packageSourceCredentials>')
    }
    $lines.Add('  <auditSources>')
    $lines.Add('    <clear />')
    $lines.Add('  </auditSources>')
    $lines.Add('</configuration>')
    ($lines -join "`n") + "`n"
}
