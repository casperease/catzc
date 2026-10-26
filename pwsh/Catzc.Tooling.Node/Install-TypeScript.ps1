function Install-TypeScript {
    [CmdletBinding()]
    param(
        [switch] $Force
    )

    # npm ships with Node.js — assert it is present and at the locked version first.
    Assert-Tool 'node_js'

    # The compiler and the declarations it checks against, each at its tools.yml pin, into npm's global root; never into the repository.
    foreach ($tool in 'typescript', 'types_node', 'types_vscode') {
        $config = Get-ToolConfig -Tool $tool
        $installed = if (Test-Command $config.command) {
            Get-ToolVersion -Config $config
        }
        if ($installed -and $installed.StartsWith($config.version) -and -not $Force) {
            Write-Message "$($config.npm_package) $($config.version) is already installed"
            continue
        }
        Invoke-Npm "install -g $($config.npm_package)@$($config.version)"
        Write-Message "$($config.npm_package) $($config.version) installed"
    }
    Assert-Command tsc -ErrorText 'TypeScript was installed but tsc is not on PATH. You may need to restart your shell.'
}
