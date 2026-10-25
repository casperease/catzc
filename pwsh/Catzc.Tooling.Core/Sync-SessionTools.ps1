<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Sync-SessionTools.ps1.md"
  warning: "Generated Header"
---
#>

function Sync-SessionTools {
    [CmdletBinding()]
    param(
        [switch] $Silent
    )

    if (Test-IsRunningInPipeline) {
        return
    }

    # Recover tools whose PATH entry was dropped but whose install is still registry-known and on disk.
    Sync-SessionPath

    $allTools = Get-Config -Config tools
    $foreignNames = [System.Collections.Generic.List[string]]::new()
    $foreignLocations = [System.Collections.Generic.List[string]]::new()

    $memoPath = Join-Path (Get-OutputRoot) 'cache/session-tools.json'
    $keyText = ($allTools | ConvertTo-Json -Depth 8 -Compress) + "`n" + $env:PATH + "`n" + $env:PATHEXT
    $key = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($keyText))).ToLowerInvariant()
    $memo = $null
    if ([System.IO.File]::Exists($memoPath)) {
        try {
            $memo = [System.IO.File]::ReadAllText($memoPath) | ConvertFrom-Json -AsHashtable
        }
        catch {
            Write-Verbose "Ignoring the unreadable session-tools memo '$memoPath': $($_.Exception.Message)"
        }
    }
    # The memo answers to the PATH the pass started from and to the PATH it left, so a second pass in the same session hits too.
    if ($memo -is [hashtable] -and @($memo['keys']) -ccontains $key -and $memo['path'] -is [string]) {
        if ($env:PATH -cne $memo['path']) {
            $env:PATH = $memo['path']
            Write-Message 'Session PATH: the hosts and hints of the last session-tools pass re-applied'
        }
        if (-not $Silent -and @($memo['foreign']).Count -gt 0) {
            Write-Message "Session tools not managed by the installer layer: $(@($memo['foreign']) -join '; ')"
            Write-Message "Locations: $(@($memo['locations']) -join '; ')" -Verbose:($VerbosePreference -eq 'Continue')
        }
        return
    }

    foreach ($toolName in $allTools.Keys) {
        $config = Get-ToolConfig -Tool $toolName

        $cmd = Get-Command $config.command -CommandType Application -ErrorAction Ignore | Select-Object -First 1
        $hosted = Resolve-SessionToolHost -Config $config
        if ($hosted) {
            $cmd = $hosted
        }
        if (-not $cmd) {
            # Not on PATH — try the declared hints to point this session at a known install.
            $cmd = Resolve-SessionToolHint -Config $config
        }
        if (-not $cmd) {
            continue   # genuinely missing — Install-*/Get-ToolsStatus own that story, not the janitor
        }

        if (-not (Test-ToolLocationManaged -Config $config -Location $cmd.Source)) {
            $foreignNames.Add($toolName)
            $foreignLocations.Add("$toolName ($($cmd.Source))")
        }
    }

    if (-not $Silent -and $foreignNames.Count -gt 0) {
        Write-Message "Session tools not managed by the installer layer: $($foreignNames -join '; ')"
        Write-Message "Locations: $($foreignLocations -join '; ')" -Verbose:($VerbosePreference -eq 'Continue')
    }

    $folder = [System.IO.Path]::GetDirectoryName($memoPath)
    [System.IO.Directory]::CreateDirectory($folder) | Out-Null
    $keyAfterText = ($allTools | ConvertTo-Json -Depth 8 -Compress) + "`n" + $env:PATH + "`n" + $env:PATHEXT
    $keyAfter = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($keyAfterText))).ToLowerInvariant()
    $json = [ordered]@{ keys = @($key, $keyAfter | Select-Object -Unique); path = $env:PATH; foreign = @($foreignNames); locations = @($foreignLocations) } | ConvertTo-Json -Compress
    [System.IO.File]::WriteAllText($memoPath, $json)
}
