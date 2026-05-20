Describe 'Write-EnvironmentSet' -Tag 'L0' {
    BeforeEach {
        # Mock the I/O boundary so tests never mutate the real process environment.
        Mock Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment
    }

    Context 'secret channel ([SecureString])' -Tag 'logic' {
        It 'decrypts a SecureString and sets it as the env value' {
            $secure = [System.Net.NetworkCredential]::new('', 'sekret').SecurePassword

            Write-EnvironmentSet -Set @{ TOK = $secure } -Persist

            Should -Invoke Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment -ParameterFilter {
                $Name -eq 'TOK' -and $Value -eq 'sekret'
            }
        }

        It 'never emits the secret plaintext through Write-Message (masks ***)' {
            Mock Write-Message -ModuleName Catzc.Tooling.Environment
            $secure = [System.Net.NetworkCredential]::new('', 'top-secret-xyz').SecurePassword

            Write-EnvironmentSet -Set @{ TOK = $secure } -Persist

            Should -Not -Invoke Write-Message -ModuleName Catzc.Tooling.Environment -ParameterFilter {
                $Message -match 'top-secret-xyz'
            }
            Should -Invoke Write-Message -ModuleName Catzc.Tooling.Environment -ParameterFilter {
                $Message -match 'TOK = \*\*\*'
            }
        }
    }

    Context 'address channel' -Tag 'logic' {
        It 'sets a scalar address as a single variable' {
            Mock Get-ConfigValue -ModuleName Catzc.Tooling.Environment -MockWith { 'appname' }

            Write-EnvironmentSet -Set @{ APP = 'global.myconfig.name' } -Persist

            Should -Invoke Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment -ParameterFilter {
                $Name -eq 'APP' -and $Value -eq 'appname'
            }
        }

        It 'fans a subtree out under the prefix, env-normalized (uppercase, . -> _)' {
            Mock Get-ConfigValue -ModuleName Catzc.Tooling.Environment -MockWith {
                [ordered]@{ host = 'db1'; port = 5432; options = [ordered]@{ ssl = $true } }
            }

            Write-EnvironmentSet -Set @{ DB = 'global.database' } -Persist

            Should -Invoke Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment -ParameterFilter { $Name -eq 'DB_HOST' -and $Value -eq 'db1' }
            Should -Invoke Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment -ParameterFilter { $Name -eq 'DB_PORT' -and $Value -eq '5432' }
            Should -Invoke Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment -ParameterFilter { $Name -eq 'DB_OPTIONS_SSL' -and $Value -eq 'True' }
        }

        It 'normalizes array indices in a subtree to _n' {
            Mock Get-ConfigValue -ModuleName Catzc.Tooling.Environment -MockWith {
                [ordered]@{ servers = @('a', 'b') }
            }

            Write-EnvironmentSet -Set @{ NET = 'global.net' } -Persist

            Should -Invoke Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment -ParameterFilter { $Name -eq 'NET_SERVERS_0' -and $Value -eq 'a' }
            Should -Invoke Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment -ParameterFilter { $Name -eq 'NET_SERVERS_1' -and $Value -eq 'b' }
        }
    }

    Context 'literal channel (-Value)' -Tag 'logic' {
        It 'sets an explicit non-secret literal' {
            Write-EnvironmentSet -Set @{} -Value @{ FLAG = '1' } -Persist

            Should -Invoke Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment -ParameterFilter {
                $Name -eq 'FLAG' -and $Value -eq '1'
            }
        }
    }

    Context 'poka-yoke rejections' -Tag 'logic' {
        It 'rejects a bare string in -Set (directs the caller to -Value)' {
            { Write-EnvironmentSet -Set @{ X = 'plainliteral' } -Persist } | Should -Throw '*neither a `[SecureString`]*'
        }

        It 'throws when two channels resolve to the same env var name' {
            Mock Get-ConfigValue -ModuleName Catzc.Tooling.Environment -MockWith { 'v' }

            { Write-EnvironmentSet -Set @{ FLAG = 'global.c.k' } -Value @{ FLAG = '1' } -Persist } |
                Should -Throw '*more than one input*'
        }

        It 'throws when a subtree address expands to nothing' {
            Mock Get-ConfigValue -ModuleName Catzc.Tooling.Environment -MockWith { [ordered]@{} }

            { Write-EnvironmentSet -Set @{ DB = 'global.empty' } -Persist } |
                Should -Throw '*no values to expand*'
        }
    }

    Context 'lifetime parameter sets' -Tag 'logic' {
        It 'rejects supplying both -ScriptBlock and -Persist' {
            { Write-EnvironmentSet -Set @{} -ScriptBlock { } -Persist } | Should -Throw
        }
    }

    Context 'scoped lifetime (snapshot / restore)' -Tag 'logic' {
        It 'invokes the scriptblock and returns its output' {
            $result = Write-EnvironmentSet -Set @{} -Value @{ A = '1' } -ScriptBlock { 'blockout' }

            $result | Should -Be 'blockout'
        }

        It 'restores a previously-unset variable to unset after the block' {
            [System.Environment]::SetEnvironmentVariable('WES_TEST_UNSET', $null, 'Process')

            Write-EnvironmentSet -Set @{} -Value @{ WES_TEST_UNSET = '1' } -ScriptBlock { }

            # The finally restores-to-unset: the seam is called with an empty/null value for that name
            # (a previously-unset variable snapshots as null-or-empty, and setting empty removes it).
            Should -Invoke Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment -ParameterFilter {
                $Name -eq 'WES_TEST_UNSET' -and [string]::IsNullOrEmpty($Value)
            }
        }

        It 'restores a previously-set variable to its prior value after the block' {
            [System.Environment]::SetEnvironmentVariable('WES_TEST_SET', 'original', 'Process')
            try {
                Write-EnvironmentSet -Set @{} -Value @{ WES_TEST_SET = 'temp' } -ScriptBlock { }

                Should -Invoke Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment -ParameterFilter {
                    $Name -eq 'WES_TEST_SET' -and $Value -eq 'original'
                }
            }
            finally {
                [System.Environment]::SetEnvironmentVariable('WES_TEST_SET', $null, 'Process')
            }
        }

        It 'does not restore anything for the persist lifetime' {
            [System.Environment]::SetEnvironmentVariable('WES_TEST_PERSIST', $null, 'Process')

            Write-EnvironmentSet -Set @{} -Value @{ WES_TEST_PERSIST = '1' } -Persist

            # Persist takes no snapshot, so the seam is only invoked to SET ('1'), never with a restoring empty.
            Should -Not -Invoke Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment -ParameterFilter {
                $Name -eq 'WES_TEST_PERSIST' -and [string]::IsNullOrEmpty($Value)
            }
        }
    }
}
