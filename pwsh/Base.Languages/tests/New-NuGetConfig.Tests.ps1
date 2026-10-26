Describe 'New-NuGetConfig' -Tag 'L0', 'logic' {
    It 'renders a config whose package and audit sources open with clear and add none' {
        [xml] $document = New-NuGetConfig
        foreach ($section in 'packageSources', 'auditSources') {
            $elements = @($document.configuration.SelectSingleNode($section).ChildNodes | Where-Object { $_.NodeType -eq 'Element' })
            $elements | Should -HaveCount 1 -Because "$section names no source"
            $elements[0].LocalName | Should -Be 'clear'
        }
    }

    It 'renders a config the guard accepts' {
        $root = Join-Path $TestDrive 'widget-repo'
        [System.IO.Directory]::CreateDirectory((Join-Path $root 'gadgets')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $root 'nuget.config'), (New-NuGetConfig))
        { Assert-DotnetOffline 'gadgets' -RepositoryRoot $root } | Should -Not -Throw
    }
}
