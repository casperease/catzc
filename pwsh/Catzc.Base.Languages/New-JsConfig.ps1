function New-JsConfig {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        # The folder of the installed type declarations (npm's global root's @types); none when node is not installed, so the gate says so.
        [AllowEmptyString()]
        [string] $TypeRoot,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    # The js track's root, its default declared once on JavaScriptConfig: js when the folder exists, else .js.
    $root = (Get-Config -Config javascript).ResolveRoot($RepositoryRoot)
    # checkJs over every module, not yet strict: each module raises its own strictness as its JSDoc grows.
    $config = [ordered]@{
        compilerOptions = [ordered]@{
            allowJs          = $true
            checkJs          = $true
            noEmit           = $true
            strict           = $false
            module           = 'commonjs'
            target           = 'es2022'
            moduleResolution = 'node'
            skipLibCheck     = $true
            typeRoots        = @(if ($TypeRoot) {
                    $TypeRoot
                })
            types            = @('node', 'vscode')
        }
        include         = @("$root/**/*.js")
    }
    (ConvertTo-Json -InputObject $config -Depth 4) + "`n"
}
