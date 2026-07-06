# Validates the files.yml convention validator directly (private; via InModuleScope). It is the gate that
# stops a malformed module->packages manifest from loading through Get-Config -Config files.
Describe 'Assert-FilesConfig' -Tag 'L0', 'logic' {
    It 'accepts a valid modules/packages map' {
        InModuleScope Catzc.Base.ModuleSystem {
            $config = [ordered]@{ modules = [ordered]@{
                    '.internal'             = [ordered]@{ packages = [ordered]@{ entrypoint = @('importer.ps1') } }
                    'Catzc.Base.Alpha' = [ordered]@{ packages = [ordered]@{
                            root_configs = @('.editorconfig')
                            gitignore    = @('.gitignore')
                        }
                    }
                }
            }
            { Assert-FilesConfig $config } | Should -Not -Throw
        }
    }

    It 'throws when modules is missing or empty' {
        InModuleScope Catzc.Base.ModuleSystem {
            { Assert-FilesConfig ([ordered]@{}) } | Should -Throw '*modules*'
            { Assert-FilesConfig ([ordered]@{ modules = [ordered]@{} }) } | Should -Throw '*non-empty*'
        }
    }

    It 'throws when a module has no packages map' {
        InModuleScope Catzc.Base.ModuleSystem {
            { Assert-FilesConfig ([ordered]@{ modules = [ordered]@{ '.internal' = [ordered]@{} } }) } |
                Should -Throw "*'packages'*"
        }
    }

    It 'throws on a non-snake_case package name' {
        InModuleScope Catzc.Base.ModuleSystem {
            { Assert-FilesConfig ([ordered]@{ modules = [ordered]@{
                            '.internal' = [ordered]@{ packages = [ordered]@{ 'Bad-Name' = @('x') } }
                        }
                    }) } | Should -Throw '*snake_case*'
        }
    }

    It 'throws on a duplicate package name across modules' {
        InModuleScope Catzc.Base.ModuleSystem {
            { Assert-FilesConfig ([ordered]@{ modules = [ordered]@{
                            '.internal'             = [ordered]@{ packages = [ordered]@{ dup = @('a') } }
                            'Catzc.Base.Alpha' = [ordered]@{ packages = [ordered]@{ dup = @('b') } }
                        }
                    }) } | Should -Throw '*duplicate package*'
        }
    }

    It 'throws when a package is not a non-empty list of paths' {
        InModuleScope Catzc.Base.ModuleSystem {
            { Assert-FilesConfig ([ordered]@{ modules = [ordered]@{
                            '.internal' = [ordered]@{ packages = [ordered]@{ entrypoint = 'importer.ps1' } }
                        }
                    }) } | Should -Throw '*non-empty list*'
        }
    }
}
