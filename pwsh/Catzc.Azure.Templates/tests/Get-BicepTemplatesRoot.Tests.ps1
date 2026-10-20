Describe 'Get-BicepTemplatesRoot' -Tag 'L0', 'logic' {
    It 'resolves the templates kind of the infrastructure track under the repository root, never a fixed path' {
        Mock Get-RepositoryRoot -ModuleName Catzc.Azure.Templates { $TestDrive }
        Mock Get-TrackPlace -ModuleName Catzc.Azure.Templates -ParameterFilter { $Track -eq 'infrastructure' -and $TrackKind -eq 'templates' } { 'widgets/blueprints' }
        & (Get-Module Catzc.Azure.Templates) { Get-BicepTemplatesRoot } | Should -Be (Join-Path $TestDrive 'widgets/blueprints')
        Should -Invoke Get-TrackPlace -ModuleName Catzc.Azure.Templates -Times 1 -Exactly
    }
}

Describe 'Get-BicepTemplatesRoot — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    It 'is the folder that holds the shipped templates' {
        $root = & (Get-Module Catzc.Azure.Templates) { Get-BicepTemplatesRoot }
        Test-Path -LiteralPath (Join-Path $root 'foundation/main.bicep') -PathType Leaf | Should -BeTrue
    }
}
