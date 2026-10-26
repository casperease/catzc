<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Remove-MacToolInstall.ps1.md"
  header: "generated"
---
#>

function Remove-MacToolInstall {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    if (-not (Test-Command $Config.command)) {
        Write-Message "No '$($Config.command)' on PATH — nothing to remove"
        return $false
    }

    $source = (Get-Command $Config.command).Source

    # A brew binary is a symlink into the Cellar whose path names the formula, and brew uninstall is user-space.
    if (Test-Command brew) {
        $prefixResult = Invoke-Executable 'brew --prefix' -PassThru -NoAssert -Silent
        $prefix = if ($prefixResult.Output) {
            $prefixResult.Output.Trim()
        }
        else {
            ''
        }
        if ($prefix -and $source.StartsWith($prefix)) {
            $link = (Invoke-Executable "readlink $source" -PassThru -NoAssert -Silent).Output
            if ($link -and $link -match 'Cellar/([^/]+)/') {
                $formula = $Matches[1]
                Invoke-Executable "brew uninstall --force $formula"
                return $true
            }
        }
    }

    # 2. uv-Python pip shadow, then 3. a stray binary — the shared user-space tail (also used by Linux).
    Remove-UvPipOrStrayInstall -Config $Config -Source $source
}
