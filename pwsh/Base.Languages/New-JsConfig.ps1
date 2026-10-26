function New-JsConfig {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        # jsconfig.json, which the editor reads, or jsconfig.lenient.json, the modules not yet raised to strict.
        [ValidateSet('jsconfig.json', 'jsconfig.lenient.json')]
        [string] $Target = 'jsconfig.json',

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    # The js track's root, its default declared once on JavaScriptConfig: js when the folder exists, else .js.
    $javascript = Get-Config -Config javascript
    $root = $javascript.ResolveRoot($RepositoryRoot)
    # Once every extension is strict, one glob of the whole track says so; until then the strict ones are listed.
    $track = Get-Track -Path $root
    $trackFolder = Join-Path $RepositoryRoot $root
    $extensions = @(if ($null -ne $track -and [System.IO.Directory]::Exists($trackFolder)) {
            Get-ChildPath $trackFolder -Directory -Depth 1 |
                Where-Object { [System.IO.File]::Exists((Join-Path $_ 'extension.js')) } |
                ForEach-Object { $track.FullNameOf([System.IO.Path]::GetFileName($_)) }
        })
    $raised = @(if ($extensions.Count -gt 0 -and @($extensions | Where-Object { $_ -cnotin $javascript.strict }).Count -eq 0) {
            "$root/**/*.js"
        }
        else {
            # A root no track holds yet has no namespace to drop, so its names are its folders.
            $javascript.strict | ForEach-Object { "$root/$(if ($null -ne $track) { $track.FolderNameOf($_) } else { $_ })/**/*.js" }
        })
    # tsc has no per-folder strict, so the lenient project extends the strict one and each file is checked once.
    $config = if ($Target -eq 'jsconfig.lenient.json') {
        [ordered]@{
            extends         = './jsconfig.json'
            compilerOptions = [ordered]@{ strict = $false }
            include         = @(if ($raised.Count -gt 0) {
                    "$root/**/*.js"
                })
            exclude         = $raised
        }
    }
    else {
        [ordered]@{
            compilerOptions = [ordered]@{
                allowJs          = $true
                checkJs          = $true
                noEmit           = $true
                strict           = $raised.Count -gt 0
                # Node's own resolution: CommonJS outside a "type": "module" package, so require resolves as node does.
                module           = 'node16'
                target           = 'es2022'
                moduleResolution = 'node16'
                skipLibCheck     = $true
                # Relative to this file at the repository root, where Install-TypeScript puts the declarations: the same on every machine.
                typeRoots        = @("./$($javascript.types_folder)/node_modules/@types")
                types            = @('node', 'vscode')
            }
            include         = @(if ($raised.Count -gt 0) {
                    $raised
                }
                else {
                    "$root/**/*.js"
                })
        }
    }
    (ConvertTo-Json -InputObject $config -Depth 4) + "`n"
}
