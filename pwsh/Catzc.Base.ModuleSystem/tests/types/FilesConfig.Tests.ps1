<#
---
catzc:
  immutable:
    with_body_sha: "265fc52065f3"
  edges:
    docs: "[FilesConfig.Tests.ps1.md](docs/references/pwsh/catzc-base-module-system/tests/types/FilesConfig.Tests.ps1.md)"
    code: pwsh/Catzc.Base.ModuleSystem/types/FilesConfig.cs
---
#>

Describe 'Catzc.Base.ModuleSystem.FilesConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.ModuleSystem.FilesConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the FilesConfig constructor to throw'
        }
    }

    It 'accepts a valid modules/packages map' {
        $config = [Catzc.Base.ModuleSystem.FilesConfig]::new([ordered]@{ modules = [ordered]@{
                    '.internal'        = [ordered]@{ packages = [ordered]@{ entrypoint = @('importer.ps1') } }
                    'Catzc.Base.Alpha' = [ordered]@{ packages = [ordered]@{
                            root_configs = @('.editorconfig')
                            gitignore    = @('.gitignore')
                        }
                    }
                }
            })
        @($config.modules.Keys) | Should -Be @('.internal', 'Catzc.Base.Alpha')
        @($config.modules['Catzc.Base.Alpha'].packages.Keys) | Should -Be @('root_configs', 'gitignore')
        @($config.modules['.internal'].packages['entrypoint']) | Should -Be @('importer.ps1')
    }

    It 'throws when modules is missing or empty' {
        Get-ViolationMessage ([ordered]@{}) | Should -BeLike '*modules*'
        Get-ViolationMessage ([ordered]@{ modules = [ordered]@{} }) | Should -BeLike '*non-empty*'
    }

    It 'throws when a module has no packages map' {
        Get-ViolationMessage ([ordered]@{ modules = [ordered]@{ '.internal' = [ordered]@{} } }) | Should -BeLike "*'packages'*"
    }

    It 'throws on a non-snake_case package name' {
        Get-ViolationMessage ([ordered]@{ modules = [ordered]@{
                    '.internal' = [ordered]@{ packages = [ordered]@{ 'Bad-Name' = @('x') } }
                }
            }) | Should -BeLike '*snake_case*'
    }

    It 'throws on a duplicate package name across modules' {
        Get-ViolationMessage ([ordered]@{ modules = [ordered]@{
                    '.internal'        = [ordered]@{ packages = [ordered]@{ dup = @('a') } }
                    'Catzc.Base.Alpha' = [ordered]@{ packages = [ordered]@{ dup = @('b') } }
                }
            }) | Should -BeLike '*duplicate package*'
    }

    It 'throws when a package is not a non-empty list of paths' {
        Get-ViolationMessage ([ordered]@{ modules = [ordered]@{
                    '.internal' = [ordered]@{ packages = [ordered]@{ entrypoint = 'importer.ps1' } }
                }
            }) | Should -BeLike '*non-empty list*'
    }

    It 'throws on a path that is not repository-root-relative and forward-slashed' {
        $message = Get-ViolationMessage ([ordered]@{ modules = [ordered]@{
                    '.internal' = [ordered]@{ packages = [ordered]@{ widget = @('a\b.txt', '/abs.txt', '../up.txt') } }
                }
            })
        $message | Should -BeLike "*path 'a\b.txt' must be repository-root-relative*"
        $message | Should -BeLike "*path '/abs.txt'*"
        $message | Should -BeLike "*path '../up.txt'*"
    }

    It 'reports every violation in one throw, including unknown keys' {
        $message = Get-ViolationMessage ([ordered]@{
                widget  = 1
                modules = [ordered]@{
                    '.internal' = [ordered]@{ packages = [ordered]@{ 'Bad-Name' = @('x') }; gadget = 1 }
                    'Catzc.Tst' = [ordered]@{}
                }
            })
        $message | Should -BeLike "*unknown top-level key 'widget'*"
        $message | Should -BeLike "*unknown key 'gadget'*"
        $message | Should -BeLike '*snake_case*'
        $message | Should -BeLike "*module 'Catzc.Tst' must be a map with a 'packages' key*"
    }
}
