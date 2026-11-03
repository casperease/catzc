Describe 'Export-JavaScriptModule' -Tag 'L0', 'logic' {
    BeforeAll {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $script:root = Join-Path $TestDrive 'repo'
        $files = [ordered]@{
            'widget-lamp/package.json' = '{ "publisher": "widget", "name": "widget-lamp", "version": "1.2.3", "displayName": "Widget <Lamp>", "engines": { "vscode": "^1.90.0" } }'
            'widget-lamp/extension.js' = 'exports.activate = () => {};'
            'widget-lamp/assets/a.svg' = '<svg xmlns="http://www.w3.org/2000/svg"/>'
            'widget-lamp/scratch.js'   = 'untracked'
            'gadget-tool/index.js'     = 'console.log(1);'
            'gadget-tool/package.json' = '{ "name": "gadget-tool" }'
            'gadget-tool/lib/part.js'  = 'module.exports = 1;'
        }
        foreach ($file in $files.Keys) {
            $path = Join-Path $script:root $file
            $null = New-Item -ItemType Directory -Path (Split-Path $path) -Force
            [System.IO.File]::WriteAllBytes($path, [System.Text.Encoding]::UTF8.GetBytes($files[$file]))
        }
        $script:read = {
            param($Archive)
            $zip = [System.IO.Compression.ZipFile]::OpenRead($Archive)
            try {
                $zip.Entries | ForEach-Object FullName
            }
            finally {
                $zip.Dispose()
            }
        }
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:root }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages -ParameterFilter { $Path -ceq 'widget-lamp' } {
            'widget-lamp/package.json', 'widget-lamp/extension.js', 'widget-lamp/assets/a.svg', 'widget-lamp/tests/x.test.js'
        }
        Mock Get-Config -ModuleName Catzc.Base.Languages { [pscustomobject]@{} | Add-Member -MemberType ScriptMethod -Name FolderOf -Value { 'tests' } -PassThru }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages -ParameterFilter { $Path -ceq 'gadget-tool' } {
            'gadget-tool/index.js', 'gadget-tool/package.json', 'gadget-tool/lib/part.js'
        }
        Mock Write-Message -ModuleName Catzc.Base.Languages { }
        $script:out = Join-Path $TestDrive "out-$([guid]::NewGuid().ToString('N'))"
    }

    It 'writes the vsix named by publisher, name and version' {
        $result = Export-JavaScriptModule -Module 'widget-lamp' -Destination $script:out -Silent
        $result.Artifact | Should -BeExactly (Join-Path $script:out 'widget.widget-lamp-1.2.3.vsix')
        Test-Path -LiteralPath $result.Artifact | Should -BeTrue
    }

    It 'holds the manifest, the content types and the tracked files under extension/ and nothing else' {
        $result = Export-JavaScriptModule -Module 'widget-lamp' -Destination $script:out -Silent
        @(& $script:read $result.Artifact) | Should -Be @('[Content_Types].xml', 'extension.vsixmanifest', 'extension/assets/a.svg',
            'extension/extension.js', 'extension/package.json')
    }

    It 'leaves a tracked test file out of the vsix and the count' {
        $result = Export-JavaScriptModule -Module 'widget-lamp' -Destination $script:out -Silent
        @(& $script:read $result.Artifact) | Should -Not -Contain 'extension/tests/x.test.js'
        $result.Files | Should -Be 3
    }

    It 'names the identity, the display name and the engine in the manifest' {
        $result = Export-JavaScriptModule -Module 'widget-lamp' -Destination $script:out -Silent
        $zip = [System.IO.Compression.ZipFile]::OpenRead($result.Artifact)
        try {
            $reader = [System.IO.StreamReader]::new($zip.GetEntry('extension.vsixmanifest').Open())
            $text = $reader.ReadToEnd()
            $reader.Dispose()
        }
        finally {
            $zip.Dispose()
        }
        $manifest = [xml] $text
        $identity = $manifest.PackageManifest.Metadata.Identity
        $identity.Id | Should -BeExactly 'widget-lamp'
        $identity.Version | Should -BeExactly '1.2.3'
        $identity.Publisher | Should -BeExactly 'widget'
        $manifest.PackageManifest.Metadata.DisplayName | Should -BeExactly 'Widget <Lamp>'
        $manifest.PackageManifest.Metadata.Properties.Property.Value | Should -BeExactly '^1.90.0'
    }

    It 'gives identical bytes on a second export' {
        $first = Export-JavaScriptModule -Module 'widget-lamp' -Destination (Join-Path $script:out 'first') -Silent
        $second = Export-JavaScriptModule -Module 'widget-lamp' -Destination (Join-Path $script:out 'second') -Silent
        [System.IO.File]::ReadAllBytes($first.Artifact) | Should -Be ([System.IO.File]::ReadAllBytes($second.Artifact))
    }

    It 'returns the vsix form with the file count' {
        $result = Export-JavaScriptModule -Module 'widget-lamp' -Destination $script:out -Silent
        $result.Module | Should -BeExactly 'widget-lamp'
        $result.Destination | Should -BeExactly $script:out
        $result.Form | Should -BeExactly 'vsix'
        $result.Files | Should -Be 3
    }

    It 'copies a module without an editor engine as source' {
        $result = Export-JavaScriptModule -Module 'gadget-tool' -Destination $script:out -Silent
        $result.Form | Should -BeExactly 'source'
        $result.Artifact | Should -BeNullOrEmpty
        $result.Files | Should -Be 3
        foreach ($file in 'index.js', 'package.json', 'lib/part.js') {
            [System.IO.File]::ReadAllBytes((Join-Path $script:out $file)) |
                Should -Be ([System.IO.File]::ReadAllBytes((Join-Path $script:root "gadget-tool/$file")))
        }
    }

    It 'takes the module as an absolute path under the repository' {
        $result = Export-JavaScriptModule -Module (Join-Path $script:root 'widget-lamp') -Destination $script:out -Silent
        $result.Module | Should -BeExactly 'widget-lamp'
    }

    It 'packs a registered extension from its rendered folder and removes the render' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages -ParameterFilter { $Path -ceq 'sprocket-ext' } { 'sprocket-ext/extension.js' }
        Mock Export-VsCodeExtensionFolder -ModuleName Catzc.Base.Languages {
            $folder = Join-Path $OutputDirectory 'sprocket-ext'
            $null = New-Item -ItemType Directory -Path (Join-Path $folder 'media') -Force
            [System.IO.File]::WriteAllText((Join-Path $folder 'package.json'),
                '{ "publisher": "sprocket", "name": "sprocket-ext", "version": "0.4.0", "engines": { "vscode": "^1.90.0" } }')
            [System.IO.File]::WriteAllText((Join-Path $folder 'extension.js'), 'exports.activate = () => {};')
            [System.IO.File]::WriteAllText((Join-Path $folder 'media/lamp.svg'), '<svg xmlns="http://www.w3.org/2000/svg"/>')
            $folder
        }
        $result = Export-JavaScriptModule -Module 'sprocket-ext' -Destination $script:out -Silent
        $result.Form | Should -BeExactly 'vsix'
        $result.Files | Should -Be 3
        $result.Artifact | Should -BeExactly (Join-Path $script:out 'sprocket.sprocket-ext-0.4.0.vsix')
        @(& $script:read $result.Artifact) | Should -Be @('[Content_Types].xml', 'extension.vsixmanifest', 'extension/extension.js',
            'extension/media/lamp.svg', 'extension/package.json')
        @(Get-ChildPath $script:out -Depth 1 -Exclude @() | ForEach-Object { Split-Path -Leaf $_ }) | Should -Be @('sprocket.sprocket-ext-0.4.0.vsix')
    }

    It 'copies a module no extension is registered for as source' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages -ParameterFilter { $Path -ceq 'sprocket-ext' } { 'sprocket-ext/extension.js' }
        Mock Export-VsCodeExtensionFolder -ModuleName Catzc.Base.Languages { }
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'sprocket-ext') -Force
        [System.IO.File]::WriteAllText((Join-Path $script:root 'sprocket-ext/extension.js'), 'exports.activate = () => {};')
        $result = Export-JavaScriptModule -Module 'sprocket-ext' -Destination $script:out -Silent
        $result.Form | Should -BeExactly 'source'
        Test-Path -LiteralPath (Join-Path $script:out 'extension.js') | Should -BeTrue
    }

    It 'refuses an extension whose package.json lacks the version' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages { 'widget-lamp/package.json' }
        $broken = Join-Path $script:root 'widget-lamp/package.json'
        $original = [System.IO.File]::ReadAllText($broken)
        try {
            [System.IO.File]::WriteAllText($broken, '{ "publisher": "widget", "name": "widget-lamp", "engines": { "vscode": "^1.90.0" } }')
            { Export-JavaScriptModule -Module 'widget-lamp' -Destination $script:out -Silent } | Should -Throw "*declares no 'version'*"
        }
        finally {
            [System.IO.File]::WriteAllText($broken, $original)
        }
    }

    It 'says what it packaged unless silent' {
        $null = Export-JavaScriptModule -Module 'widget-lamp' -Destination $script:out
        Should -Invoke Write-Message -ModuleName Catzc.Base.Languages -Times 1 -Exactly
    }

    It 'says nothing when silent' {
        $null = Export-JavaScriptModule -Module 'widget-lamp' -Destination $script:out -Silent
        Should -Invoke Write-Message -ModuleName Catzc.Base.Languages -Times 0 -Exactly
    }
}
