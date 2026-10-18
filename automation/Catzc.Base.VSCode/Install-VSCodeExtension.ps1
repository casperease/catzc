<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.VSCode/Install-VSCodeExtension.ps1
    name: install-vs-code-extension
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.VSCode/tests/Install-VSCodeExtension.Tests.ps1
  config:
    synopsis: Installs the repository's own editor extensions, the entries under extensions in vscode-extensions.yml, through the editor's CLI.
    description: |-
      Each extension is generated: New-VSCodeExtensionFolder renders it from its registry entry and its script in `assets/extensions/` to
      `<Root>/<name>/`, Build-VSCodeExtension packs that folder, and `code --install-extension --force` installs it, so the editor writes
      its own registry entry. An extension whose installed copy (`<publisher>.<name>-<version>` in the editor's
      extensions folder) already holds every source file byte for byte is skipped, so the importer runs this on every load and only a
      changed extension costs an install. An extension of the same name is replaced; the editor loads it on its next window reload.

      A link from the editor's extensions folder into the repository is not the install: the editor would write the extension's files
      through the link into the working tree. Remove such a link first.
    parameters:
      Name: 'The extension names to install. Default: every entry under extensions in vscode-extensions.yml.'
      Root: 'The folder the extensions are rendered under. Default: the vscode-extensions folder under the output root.'
      ExtensionsDirectory: "The editor's extensions folder, where an installed copy is compared. Default: ~/.vscode/extensions."
      Force: Installs even an extension whose installed copy is current.
    outputs: '[string[]] The .vsix files that were installed.'
    examples:
      - Install-VSCodeExtension
      - Install-VSCodeExtension -Name catzc-git-changes -Force
---
#>

function Install-VSCodeExtension {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Name,

        [string] $Root = (Join-Path (Get-OutputRoot) 'vscode-extensions'),

        [string] $ExtensionsDirectory = (Join-Path $HOME '.vscode/extensions'),

        [switch] $Force
    )

    if (-not (Test-Command 'code')) {
        throw "Install-VSCodeExtension: the editor's CLI 'code' is not on PATH. Add it (VS Code: Shell Command: Install 'code' command in PATH), then re-run."
    }

    $entries = @((Get-Config -Config vscode-extensions).extensions)
    if ($Name) {
        $known = @($entries | ForEach-Object name)
        foreach ($wanted in $Name | Where-Object { $_ -notin $known }) {
            throw "Install-VSCodeExtension: '$wanted' is not an entry under extensions in vscode-extensions.yml."
        }
        $entries = @($entries | Where-Object { $_.name -in $Name })
    }

    foreach ($entry in $entries) {
        $folder = New-VSCodeExtensionFolder -Extension $entry -OutputDirectory $Root
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
        $packagePath = Build-VSCodeExtension -Path $folder
        Invoke-Executable "code --install-extension `"$packagePath`" --force"
        $packagePath
    }
}
