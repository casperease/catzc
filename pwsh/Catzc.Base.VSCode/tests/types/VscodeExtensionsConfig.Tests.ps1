Describe 'Catzc.Base.VSCode.VscodeExtensionsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.VSCode.VscodeExtensionsConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the VscodeExtensionsConfig constructor to throw'
        }
    }

    It 'accepts a well-formed registry' {
        $config = [Catzc.Base.VSCode.VscodeExtensionsConfig]::new([ordered]@{ recommendations = @('acme.tool-one', 'globex.tool-two') })
        $config.recommendations | Should -Be @('acme.tool-one', 'globex.tool-two')
    }

    It 'throws when recommendations is missing or empty' {
        Get-ViolationMessage ([ordered]@{}) | Should -BeLike '*non-empty list*'
        Get-ViolationMessage ([ordered]@{ recommendations = @() }) | Should -BeLike '*non-empty list*'
    }

    It 'throws on an id that is not publisher.name' {
        Get-ViolationMessage ([ordered]@{ recommendations = @('no-dot-here') }) | Should -BeLike '*not a publisher.name*'
    }

    It 'throws on a duplicate id, collecting every violation' {
        $message = Get-ViolationMessage ([ordered]@{ recommendations = @('acme.tool', 'acme.tool', 'bad id') })
        $message | Should -BeLike '*duplicate recommendation*'
        $message | Should -BeLike "*'bad id' is not a publisher.name*"
    }

    It 'throws on an unknown top-level key' {
        Get-ViolationMessage ([ordered]@{ recommendations = @('acme.tool'); widget = 1 }) | Should -BeLike "*unknown top-level key 'widget'*"
    }

    It 'reads no own extensions when extensions is absent' {
        $config = [Catzc.Base.VSCode.VscodeExtensionsConfig]::new([ordered]@{ recommendations = @('acme.tool') })
        $config.extensions.Count | Should -Be 0
    }

    It 'reads an own extension in registry order, the omitted keys taking the defaults the type declares' {
        $config = [Catzc.Base.VSCode.VscodeExtensionsConfig]::new([ordered]@{
                recommendations = @('acme.tool')
                extensions      = [ordered]@{
                    'widget-ext' = [ordered]@{ displayName = 'Widget'; description = 'A widget.'; activationEvents = 'onStartupFinished' }
                    'gadget-ext' = [ordered]@{ displayName = 'Gadget'; description = 'A gadget.'; version = '2.0.0'; activationEvents = @('onStartupFinished'); contributes = [ordered]@{ colors = @() } }
                }
            })
        @($config.extensions.name) | Should -Be @('widget-ext', 'gadget-ext')
        $widget = $config.extensions[0]
        $widget.version | Should -Be ([Catzc.Base.VSCode.VscodeOwnExtension]::DefaultVersion)
        $widget.publisher | Should -Be ([Catzc.Base.VSCode.VscodeOwnExtension]::DefaultPublisher)
        $widget.engine | Should -Be ([Catzc.Base.VSCode.VscodeOwnExtension]::DefaultEngine)
        $widget.activationEvents | Should -Be @('onStartupFinished')
        $widget.contributes.Count | Should -Be 0
        $config.extensions[1].version | Should -Be '2.0.0'
        @($config.extensions[1].contributes.Keys) | Should -Be @('colors')
    }

    It 'throws on an own extension without its required keys, or with an unknown one, collecting every violation' {
        $message = Get-ViolationMessage ([ordered]@{
                recommendations = @('acme.tool')
                extensions      = [ordered]@{ 'Widget_Ext' = [ordered]@{ gizmo = 1 } }
            })
        $message | Should -BeLike "*'Widget_Ext' must be lower-case*"
        $message | Should -BeLike "*unknown key 'gizmo'*"
        $message | Should -BeLike "*missing a non-empty 'displayName'*"
        $message | Should -BeLike "*missing a non-empty 'description'*"
        $message | Should -BeLike "*'activationEvents' must be a non-empty list*"
    }

    It 'throws when extensions is not a mapping' {
        Get-ViolationMessage ([ordered]@{ recommendations = @('acme.tool'); extensions = @('widget-ext') }) | Should -BeLike "*'extensions' must be a mapping*"
    }
}
