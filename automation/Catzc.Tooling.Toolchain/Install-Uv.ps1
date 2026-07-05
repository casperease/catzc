<#
.SYNOPSIS
    Installs uv, Astral's Python handler.
.DESCRIPTION
    Windows: winget (astral-sh.uv — a portable-zip package, so winget installs it user-scope, no admin).
    macOS: Homebrew. Both delegate to Install-Tool. uv is the standard Python handler: it provisions Python
    and runs Python-based CLIs in isolated environments. Idempotent — skips if the correct version is already
    on PATH.
.PARAMETER Version
    uv version to install. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Force
    Replace an existing installation at the wrong version.
.EXAMPLE
    Install-Uv
#>
function Install-Uv {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Force
    )

    Install-Tool -Tool 'uv' -Version $Version -Force:$Force
}
