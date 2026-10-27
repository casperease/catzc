Describe 'Get-BicepModuleResourceTypes' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:read = {
            param([string] $Path)
            InModuleScope Catzc.Azure.Templates -Parameters @{ Path = $Path } {
                param($Path)
                Get-BicepModuleResourceTypes -Path $Path
            }
        }
    }

    BeforeEach {
        $script:folder = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        [void] (New-Item -ItemType Directory -Path $script:folder)
        Set-Content -LiteralPath (Join-Path $script:folder 'widget.bicep') -Value @(
            "resource widget 'Widget.Parts/widgets@2024-01-01' = {"
            "  resource child 'Widget.Parts/widgets/cogs@2024-01-01' = {}"
            "resource parent 'Widget.Parts/gadgets@2024-01-01' existing = {"
            "// resource commented 'Widget.Parts/sprockets@2024-01-01' = {"
        )
    }

    It 'lists every declared type once, sorted, and no existing reference or comment' {
        Set-Content -LiteralPath (Join-Path $script:folder 'gadget.bicep') -Value "resource again 'Widget.Parts/widgets@2025-01-01' = if (true) {"
        & $script:read $script:folder | Should -Be @('Widget.Parts/widgets', 'Widget.Parts/widgets/cogs')
    }

    It 'allows a new module''s type without editing a list' {
        Set-Content -LiteralPath (Join-Path $script:folder 'gadget.bicep') -Value "resource gadget 'Gadget.Parts/gadgets@2024-01-01' = {"
        & $script:read $script:folder | Should -Contain 'Gadget.Parts/gadgets'
    }

    It 'reads only the folder''s own files, not a subfolder''s' {
        $nested = Join-Path $script:folder 'nested'
        [void] (New-Item -ItemType Directory -Path $nested)
        Set-Content -LiteralPath (Join-Path $nested 'deep.bicep') -Value "resource deep 'Gadget.Parts/deep@2024-01-01' = {"
        & $script:read $script:folder | Should -Not -Contain 'Gadget.Parts/deep'
    }
}
