<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-node/Uninstall-TypeScript.ps1.md"
  header: "generated"
---
#>

function Uninstall-TypeScript {
    [CmdletBinding()]
    param()

    Assert-Tool 'node_js'
    # The compiler from npm's global root, the declarations from the repository-relative folder javascript.yml declares.
    $folder = Join-Path (Get-RepositoryRoot) (Get-Config -Config javascript).types_folder
    foreach ($tool in 'typescript', 'types_node', 'types_vscode') {
        $config = Get-ToolConfig -Tool $tool
        if ((Test-Command $config.command) -and (Get-ToolVersion -Config $config)) {
            $from = if ($tool -eq 'typescript') {
                '-g'
            }
            else {
                "--prefix `"$folder`""
            }
            Invoke-Npm "uninstall $from $($config.npm_package)"
            Write-Message "$($config.npm_package) uninstalled"
        }
    }
}
