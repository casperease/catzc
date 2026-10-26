<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-vs-code/Install-VsCodeExtension.ps1.md"
  header: "generated"
---
#>

function Install-VsCodeExtension {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Name,

        [string] $Root = (Join-Path (Get-OutputRoot) 'vscode-extensions'),

        [string] $ExtensionsDirectory = (Join-Path $HOME '.vscode/extensions'),

        [switch] $Force
    )

    if (-not (Test-Command 'code')) {
        throw "Install-VsCodeExtension: the editor's CLI 'code' is not on PATH. Add it (VS Code: Shell Command: Install 'code' command in PATH), then re-run."
    }

    $entries = @((Get-Config -Config vscode-extensions).extensions)
    if ($Name) {
        $known = @($entries | ForEach-Object name)
        foreach ($wanted in $Name | Where-Object { $_ -notin $known }) {
            throw "Install-VsCodeExtension: '$wanted' is not an entry under extensions in vscode-extensions.yml."
        }
        $entries = @($entries | Where-Object { $_.name -in $Name })
    }

    $current = -not $Force -and -not @(Get-GeneratedWriterDue -Name New-VsCodeExtensionFolder | Where-Object Due)
    $rendered = $false
    foreach ($entry in $entries) {
        $folder = Join-Path $Root $entry.name
        $renderedNow = -not ($current -and (Test-Path -LiteralPath (Join-Path $folder 'package.json')))
        if ($renderedNow) {
            $folder = New-VsCodeExtensionFolder -Extension $entry -OutputDirectory $Root
            $rendered = $true
        }
        if (-not $Force) {
            $manifest = Get-Content -LiteralPath (Join-Path $folder 'package.json') -Raw | ConvertFrom-Json
            $installed = Join-Path $ExtensionsDirectory "$($manifest.publisher).$($manifest.name)-$($manifest.version)".ToLowerInvariant()
            if (-not $renderedNow -and (Test-Path -LiteralPath $installed)) {
                continue
            }
            $manifestText = { param([string] $Path) $json = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
                $json.PSObject.Properties.Remove('__metadata')
                $json | ConvertTo-Json -Depth 32 -Compress }
            $isCurrent = (Test-Path -LiteralPath $installed) -and -not @(Get-ChildPath $folder -File -Depth 16 -Exclude @() -PruneVendor $false | Where-Object {
                    $copy = Join-Path $installed ([System.IO.Path]::GetRelativePath($folder, $_))
                    if (-not (Test-Path -LiteralPath $copy)) {
                        $true
                    }
                    elseif ((Split-Path $_ -Leaf) -eq 'package.json') {
                        (& $manifestText $copy) -ne (& $manifestText $_)
                    }
                    else {
                        (Get-FileHash -LiteralPath $copy).Hash -ne (Get-FileHash -LiteralPath $_).Hash
                    }
                })
            if ($isCurrent) {
                continue
            }
        }
        $packagePath = Build-VsCodeExtension -Path $folder
        Invoke-Executable "code --install-extension `"$packagePath`" --force"
        $packagePath
    }
    # Only a render of every extension proves them all current; a named subset leaves the stamp as it was.
    if ($rendered -and -not $Name) {
        Save-GeneratedWriterStamp -Name New-VsCodeExtensionFolder
    }
}
