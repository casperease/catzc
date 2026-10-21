<#
---
catzc:
  immutable:
    with_body_sha: d8b500ff3b17
  edges:
    test: pwsh/Catzc.Base.VSCode/tests/Install-VSCodeExtension.Tests.ps1
    docs: "[Install-VSCodeExtension.ps1.md](docs/references/pwsh/catzc-base-vscode/Install-VSCodeExtension.ps1.md)"
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

    foreach ($entry in $entries) {
        $folder = New-VsCodeExtensionFolder -Extension $entry -OutputDirectory $Root
        if (-not $Force) {
            $manifest = Get-Content -LiteralPath (Join-Path $folder 'package.json') -Raw | ConvertFrom-Json
            $installed = Join-Path $ExtensionsDirectory "$($manifest.publisher).$($manifest.name)-$($manifest.version)".ToLowerInvariant()
            # The editor writes its own __metadata into the installed package.json, so the manifest is compared without it.
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
}
