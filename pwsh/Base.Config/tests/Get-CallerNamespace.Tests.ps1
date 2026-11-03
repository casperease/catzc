Describe 'Get-CallerNamespace' -Tag 'L0' {
    Context 'the namespace of the reader''s caller' -Tag 'logic' {
        # Fixture modules named <Namespace>.<Folder> call the resolver the way a reader does, from inside Catzc.Base.Config.
        BeforeEach {
            $alpha = New-Module -Name Widget.Alpha -ScriptBlock {
                function Read-WidgetAlpha {
                    & (Get-Module Catzc.Base.Config) { Get-CallerNamespace }
                }
                function Read-WidgetAlphaInBlock {
                    'x' | ForEach-Object { & (Get-Module Catzc.Base.Config) { Get-CallerNamespace } }
                }
            }
            $deep = New-Module -Name Gadget.Base.Beta -ScriptBlock {
                function Read-GadgetBeta {
                    & (Get-Module Catzc.Base.Config) { Get-CallerNamespace }
                }
            }
            $flat = New-Module -Name Sprocket -ScriptBlock {
                function Read-Sprocket {
                    & (Get-Module Catzc.Base.Config) { Get-CallerNamespace }
                }
            }
            $system = New-Module -Name Catzc.Fixture -ScriptBlock {
                function Read-CatzcFixture {
                    & (Get-Module Catzc.Base.Config) { Get-CallerNamespace }
                }
            }
            $alpha, $deep, $flat, $system | Import-Module -Force
        }

        AfterEach {
            Remove-Module Widget.Alpha, Gadget.Base.Beta, Sprocket, Catzc.Fixture -Force -ErrorAction SilentlyContinue
        }

        It 'gives the first segment of the calling module''s name' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            Read-WidgetAlpha | Should -BeExactly 'Widget'
            Read-GadgetBeta | Should -BeExactly 'Gadget'
        }

        It 'gives the namespace of the nearest module when a script block of it calls' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            Read-WidgetAlphaInBlock | Should -BeExactly 'Widget'
        }

        It 'gives Catzc for a Catzc module, for a module with no dot in its name, and for a call from no module' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
            Read-CatzcFixture | Should -BeExactly 'Catzc'
            Read-Sprocket | Should -BeExactly 'Catzc'
            InModuleScope Catzc.Base.Config { Get-CallerNamespace } | Should -BeExactly 'Catzc'
        }
    }
}
