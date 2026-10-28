Describe 'Copy-BicepSourceTree' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:source = Join-Path $TestDrive 'source'
        $script:output = Join-Path $TestDrive 'output'
        foreach ($folder in 'templates/widget', 'modules', 'shared') {
            $null = New-Item -ItemType Directory -Path (Join-Path $script:source $folder) -Force
        }
        $script:write = { param($Path, $Text) [System.IO.File]::WriteAllText((Join-Path $script:source $Path), $Text) }
        & $script:write 'bicepconfig.json' '{}'
        & $script:write 'modules/gadget.bicep' "module inner 'inner.bicep' = {`n  name: 'inner'`n}`n"
        & $script:write 'modules/inner.bicep' "var body = loadTextContent('../shared/body.txt')`n"
        & $script:write 'shared/body.txt' 'widget'
        & $script:write 'shared/types.bicep' "@export()`ntype widgetType = string`n"
        & $script:write 'templates/widget/main.bicep' (
            "import { widgetType } from '../../shared/types.bicep'`n" +
            "module gadget '../../modules/gadget.bicep' = {`n  name: 'gadget'`n}`n" +
            "module registry 'br/public:avm/res/widget:1.0.0' = {`n  name: 'registry'`n}`n")
        $script:copy = {
            InModuleScope Catzc.Azure.Templates -Parameters @{ Main = (Join-Path $script:source 'templates/widget/main.bicep'); Output = $script:output } {
                param($Main, $Output)
                Copy-BicepSourceTree -Main $Main -OutputFolder $Output
            }
        }
    }

    It 'copies main.bicep and every file it reaches under bicep/, keeping their layout, and returns the copied main' {
        $main = & $script:copy
        [System.IO.Path]::GetFullPath($main) |
            Should -BeExactly ([System.IO.Path]::GetFullPath((Join-Path $script:output 'bicep/templates/widget/main.bicep')))
        foreach ($path in 'templates/widget/main.bicep', 'modules/gadget.bicep', 'modules/inner.bicep', 'shared/body.txt', 'shared/types.bicep') {
            Join-Path $script:output "bicep/$path" | Should -Exist
        }
    }

    It 'copies the bicepconfig.json between a reached file and the common root' {
        $null = & $script:copy
        Join-Path $script:output 'bicep/bicepconfig.json' | Should -Exist
    }

    It 'skips a registry reference, which names no local file' {
        $null = & $script:copy
        @(Get-ChildPath -Path $script:output -Depth 8 -File) | ForEach-Object { [System.IO.Path]::GetFileName($_) } |
            Should -Not -Contain 'widget:1.0.0'
    }

    It 'throws naming the referrer when a reached file is missing' {
        Remove-Item (Join-Path $script:source 'modules/inner.bicep')
        { & $script:copy } | Should -Throw "*gadget.bicep' references '*inner.bicep', which does not exist*"
    }
}
