<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Core/Remove-MacToolInstall.ps1
    name: remove-mac-tool-install
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-tooling-core/Remove-MacToolInstall.ps1.md
    test: automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1
    cites:
      - ADR-AUTO-REMOVE#{6,7}
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
