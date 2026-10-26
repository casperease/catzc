# Rests on
# [ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams).
Describe 'Build-VsCodeExtension' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:folder = Join-Path $TestDrive 'widget-ext'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:folder 'lib') -Force
        Set-Content -LiteralPath (Join-Path $script:folder 'package.json') -Value '{ "name": "widget-ext", "displayName": "Widget <ext>", "description": "A widget.", "version": "1.2.3", "publisher": "acme", "engines": { "vscode": "^1.90.0" }, "main": "./extension.js", "activationEvents": ["onStartupFinished"] }'
        Set-Content -LiteralPath (Join-Path $script:folder 'extension.js') -Value 'module.exports = {};'
        Set-Content -LiteralPath (Join-Path $script:folder 'lib/gadget.js') -Value 'module.exports = 1;'
        $script:out = Join-Path $TestDrive 'vsix'
        $script:packagePath = Build-VsCodeExtension -Path $script:folder -OutputDirectory $script:out
    }

    It 'names the package for the extension and its version' {
        $script:packagePath | Should -Be (Join-Path (Resolve-Path $script:out).Path 'widget-ext-1.2.3.vsix')
        Test-Path -LiteralPath $script:packagePath | Should -BeTrue
    }

    It 'holds the folder under extension/ beside the two package parts' {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($script:packagePath)
        try {
            $entries = @($zip.Entries.FullName | Sort-Object)
        }
        finally {
            $zip.Dispose()
        }
        $entries | Should -Be @('[Content_Types].xml', 'extension.vsixmanifest', 'extension/extension.js',
            'extension/lib/gadget.js', 'extension/package.json')
    }

    It 'writes a manifest that names the identity and the engine, escaped, as valid XML' {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($script:packagePath)
        try {
            $reader = [System.IO.StreamReader]::new($zip.GetEntry('extension.vsixmanifest').Open())
            $text = $reader.ReadToEnd()
            $reader.Dispose()
        }
        finally {
            $zip.Dispose()
        }
        $xml = [xml] $text
        $xml.PackageManifest.Metadata.Identity.Id | Should -Be 'widget-ext'
        $xml.PackageManifest.Metadata.Identity.Version | Should -Be '1.2.3'
        $xml.PackageManifest.Metadata.Identity.Publisher | Should -Be 'acme'
        $xml.PackageManifest.Metadata.DisplayName | Should -Be 'Widget <ext>'
        $xml.PackageManifest.Installation.InstallationTarget.Version | Should -Be '^1.90.0'
    }

    It 'replaces a package of the same name' {
        $again = Build-VsCodeExtension -Path $script:folder -OutputDirectory $script:out
        $again | Should -Be $script:packagePath
        @(Get-ChildPath $script:out -Depth 1 -File -Filter '*.vsix').Count | Should -Be 1
    }

    It 'refuses a package.json that breaks the extension manifest contract, naming what breaks it, and packs nothing' {
        $broken = Join-Path $TestDrive 'gadget-ext'
        $null = New-Item -ItemType Directory -Path $broken -Force
        Set-Content -LiteralPath (Join-Path $broken 'package.json') -Value '{ "name": "gadget-ext", "version": "1.0.0" }'
        { Build-VsCodeExtension -Path $broken -OutputDirectory $script:out } |
            Should -Throw '*breaks the extension manifest contract*publisher*'
        Test-Path -LiteralPath (Join-Path $script:out 'gadget-ext-1.0.0.vsix') | Should -BeFalse
    }
}
