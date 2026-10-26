# The type is the only place a file-limits default lives, and its bounds are asserted on construction so a wrong number
# never reaches a gate.
Describe 'FileLimitsConfig' -Tag 'L0', 'logic' {
    It 'takes the declared defaults for every omitted key' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{})
        $config.length_min | Should -Be 100
        $config.length_max | Should -Be 500
        $config.width_min | Should -Be 80
        $config.width_max | Should -Be 200
        $config.defaults['code'].length | Should -Be 400
        $config.defaults['code'].width | Should -Be 120
        $config.defaults['config'].length | Should -Be 300
        $config.defaults['prose'].width | Should -Be 140
        $config.languages.Count | Should -Be 0
    }

    It 'does not measure one-record-per-line data: a delimited table or a JSON-lines file' {
        $config = [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{})
        $config.ResolveFile('widget/gadget.csv', $null).file_class | Should -Be 'none'
        $config.ResolveFile('widget/gadget.tsv', $null).file_class | Should -Be 'none'
        $config.Resolve('jsonl').file_class | Should -Be 'none'
    }

    It 'takes the defaults from a missing file as well' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        ([Catzc.Base.FileLimits.FileLimitsConfig]::new($null)).defaults['code'].length | Should -Be 400
        ([Catzc.Base.FileLimits.FileLimitsConfig]::new($null)).function_body_length | Should -Be 300
    }

    It 'declares the function body length once, takes a given one, and rejects one that is not a positive whole number' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        [Catzc.Base.FileLimits.FileLimitsConfig]::DefaultFunctionBodyLength | Should -Be 300
        ([Catzc.Base.FileLimits.FileLimitsConfig]::new(@{})).function_body_length | Should -Be 300
        ([Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ function_body_length = 250 })).function_body_length |
            Should -Be 250
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ function_body_length = 0 }) } |
            Should -Throw '*function_body_length*positive whole number*'
    }

    It 'declares the string overflow once as exempt, takes breach, and rejects any other value' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        [Catzc.Base.FileLimits.FileLimitsConfig]::DefaultStringOverflow | Should -Be 'exempt'
        ([Catzc.Base.FileLimits.FileLimitsConfig]::new(@{})).string_overflow | Should -Be 'exempt'
        ([Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ string_overflow = 'breach' })).string_overflow |
            Should -Be 'breach'
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ string_overflow = 'ignore' }) } |
            Should -Throw "*string_overflow 'ignore' must be one of exempt, breach*"
    }

    It 'keeps the shipped value of a class key it is not given' {
        $config = [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ defaults = @{ code = @{ width = 100 } } })
        $config.defaults['code'].width | Should -Be 100
        $config.defaults['code'].length | Should -Be 400
    }

    It 'keeps a language override as given, leaving its other limit unset' {
        $config = [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ languages = @{ widget = @{ width = 150 } } })
        $config.languages['widget'].width | Should -Be 150
        $config.languages['widget'].length | Should -BeNullOrEmpty
    }

    It 'has no width mode: width is measured, never enforced, so the key is unknown' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ width_mode = @{ code = 'fail' } }) } | Should -Throw "*unknown key 'width_mode'*"
    }

    It 'rejects an unknown key at every level, naming the allowed set' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ gadget = 1 }) } |
            Should -Throw '*unknown key ''gadget''*bounds, classes, defaults, exempt, extensions, function_body_length, languages, string_overflow*'
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ defaults = @{ gadget = @{} } }) } |
            Should -Throw '*code, config, prose*'
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ languages = @{ widget = @{ depth = 1 } } }) } |
            Should -Throw '*length, width*'
    }

    It 'rejects a value that is not a positive whole number' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ defaults = @{ code = @{ length = 'long' } } }) } |
            Should -Throw '*positive whole number*'
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ languages = @{ widget = @{ width = 0 } } }) } |
            Should -Throw '*positive whole number*'
    }

    It 'rejects a default or override outside its bounds' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ defaults = @{ code = @{ length = 501 } } }) } |
            Should -Throw '*defaults.code.length 501 is outside the bounds 100 to 500*'
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ languages = @{ widget = @{ width = 79 } } }) } |
            Should -Throw '*languages.widget.width 79*'
    }

    It 'checks the defaults against narrowed bounds' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ bounds = @{ width = @{ max = 130 } } }) } |
            Should -Throw '*defaults.config.width 140*'
    }

    It 'rejects bounds whose min is above their max' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ bounds = @{ length = @{ min = 600 } } }) } |
            Should -Throw '*min 600 is above max 500*'
    }

    It 'resolves a language value over its class default, naming the source of each' {
        $config = [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ classes = @{ widget = 'code' }; languages = @{ widget = @{ width = 150 } } })
        $limit = $config.Resolve('widget')
        $limit.file_class | Should -Be 'code'
        $limit.width | Should -Be 150
        $limit.width_source | Should -Be 'languages.widget'
        $limit.length | Should -Be 400
        $limit.length_source | Should -Be 'defaults.code'
    }

    It 'resolves an unmeasured class to no limits' {
        $limit = [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ classes = @{ gadget = 'none' } }).Resolve('gadget')
        $limit.length | Should -BeNullOrEmpty
        $limit.width | Should -BeNullOrEmpty
    }

    It 'fails fast on a language with no class' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ classes = @{} }).Resolve('widget') } |
            Should -Throw '*language ''widget'' has no class*'
    }

    It 'applies an extension override before the language, with its class defaults' {
        $config = [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ classes = @{ widget = 'code' }; extensions = @{ '.gadget' = 'config' }; languages = @{ widget = @{ width = 150 } } })
        $limit = $config.ResolveFile('a/b.GADGET', 'widget')
        $limit.file_class | Should -Be 'config'
        $limit.width | Should -Be 140
        $config.ResolveFile('a/b.widget', 'widget').width | Should -Be 150
    }

    It 'matches an exact file name before the extension, and fails a file nothing declares' {
        $config = [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ extensions = @{ WIDGET = 'prose'; '.gadget' = 'none' } })
        $config.ResolveFile('a/WIDGET', $null).file_class | Should -Be 'prose'
        $config.ResolveFile('a/b.gadget', $null).file_class | Should -Be 'none'
        { $config.ResolveFile('a/b.unknown', $null) } | Should -Throw '*is unclassified*'
    }

    It 'rejects an override that is a path or names an undeclared class' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ extensions = @{ 'widget/gadget' = 'config' } }) } |
            Should -Throw '*a bare file name*'
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ extensions = @{ '.gadget' = 'widget' } }) } |
            Should -Throw '*must be one of*'
    }

    It 'rejects a class that is not declared' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ classes = @{ widget = 'gadget' } }) } |
            Should -Throw '*classes.widget ''gadget'' must be one of*'
    }

    It 'reports every violation in one exception' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ gadget = 1; languages = @{ widget = @{ width = 9 } } }) } |
            Should -Throw '*unknown key*widget.width*'
    }
}

Describe 'FileLimitsConfig (shipped file-limits.yml)' -Tag 'L1', 'integrity' {
    It 'loads the shipped file-limits.yml as a FileLimitsConfig' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        (Get-Config -Config file-limits) | Should -BeOfType ([Catzc.Base.FileLimits.FileLimitsConfig])
    }

    It 'gives the FunctionLength rule the declared function body length' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        (Get-Config -Config file-limits).function_body_length |
            Should -Be ([Catzc.Base.FileLimits.FileLimitsConfig]::DefaultFunctionBodyLength)
        $rule = Import-Module (Join-Path (Get-CatzcModulesRoot) '.scriptanalyzer/FunctionLength.psm1') -PassThru -Force
        try {
            & $rule { Get-FunctionBodyLength } |
                Should -Be ([Catzc.Base.FileLimits.FileLimitsConfig]::DefaultFunctionBodyLength)
        }
        finally {
            Remove-Module $rule -Force
        }
    }
}
