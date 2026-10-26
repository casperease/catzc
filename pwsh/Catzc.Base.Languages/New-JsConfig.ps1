<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-languages/New-JsConfig.ps1.md"
  header: "generated"
---
#>

function New-JsConfig {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        # The folder of the installed type declarations (npm's global root's @types); none when node is not installed,
        # so the gate says so.
        [AllowEmptyString()]
        [string] $TypeRoot,

        # jsconfig.json, every module not yet raised, or jsconfig.strict.json, the modules javascript.yml's strict list
        # names.
        [ValidateSet('jsconfig.json', 'jsconfig.strict.json')]
        [string] $Target = 'jsconfig.json',

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    # The js track's root, its default declared once on JavaScriptConfig: js when the folder exists, else .js.
    $javascript = Get-Config -Config javascript
    $root = $javascript.ResolveRoot($RepositoryRoot)
    $raised = @($javascript.strict | ForEach-Object { "$root/$_/**/*.js" })
    $config = if ($Target -eq 'jsconfig.strict.json') {
        [ordered]@{
            extends         = './jsconfig.json'
            compilerOptions = [ordered]@{ strict = $true }
            include         = $raised
            exclude         = @()
        }
    }
    else {
        [ordered]@{
            compilerOptions = [ordered]@{
                allowJs          = $true
                checkJs          = $true
                noEmit           = $true
                strict           = $false
                module           = 'node16'
                target           = 'es2022'
                moduleResolution = 'node16'
                skipLibCheck     = $true
                typeRoots        = @(if ($TypeRoot) {
                        $TypeRoot
                    })
                types            = @('node', 'vscode')
            }
            include         = @("$root/**/*.js")
            exclude         = $raised
        }
    }
    (ConvertTo-Json -InputObject $config -Depth 4) + "`n"
}
