function Uninstall-TypeScript {
    [CmdletBinding()]
    param()

    Assert-Tool 'node_js'
    foreach ($tool in 'typescript', 'types_node', 'types_vscode') {
        $config = Get-ToolConfig -Tool $tool
        if ((Test-Command $config.command) -and (Get-ToolVersion -Config $config)) {
            Invoke-Npm "uninstall -g $($config.npm_package)"
            Write-Message "$($config.npm_package) uninstalled"
        }
    }
}
