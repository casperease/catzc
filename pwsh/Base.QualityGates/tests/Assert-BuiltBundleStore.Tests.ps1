Describe 'Assert-BuiltBundleStore' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-POSTBUILDTAG' {
    BeforeAll {
        $script:store = Join-Path $TestDrive 'store'
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'exporter' } {
            [pscustomobject]@{ bundles = [ordered]@{ widgets = @{}; gadgets = @{} } }
        }
        Mock Build-Modules -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ StoreRoot = Join-Path $script:store $Bundle; SourceStamp = "stamp-$Bundle" }
        }
        function script:Set-StoredBuild {
            param([string] $Bundle, [string] $Content)
            $null = New-Item -ItemType Directory -Path (Join-Path $script:store $Bundle) -Force
            Set-Content -LiteralPath (Join-Path $script:store "$Bundle/build.json") -Value $Content
        }
    }

    BeforeEach {
        Remove-Item -LiteralPath $script:store -Recurse -Force -ErrorAction Ignore
    }

    It 'passes when every declared bundle has a stored build at the tree stamp' {
        Set-StoredBuild -Bundle widgets -Content '{ "sourceStamp": "stamp-widgets" }'
        Set-StoredBuild -Bundle gadgets -Content '{ "sourceStamp": "stamp-gadgets" }'
        { InModuleScope Catzc.Base.QualityGates { Assert-BuiltBundleStore } } | Should -Not -Throw
    }

    It 'names the missing bundle and its build event command, and leaves the present one out' {
        Set-StoredBuild -Bundle widgets -Content '{ "sourceStamp": "stamp-widgets" }'
        { InModuleScope Catzc.Base.QualityGates { Assert-BuiltBundleStore } } |
            Should -Throw -ExpectedMessage '*for: gadgets. Run the build event first: Build-Modules -Bundle gadgets'
    }

    It 'lists every missing bundle with one build event command each' {
        { InModuleScope Catzc.Base.QualityGates { Assert-BuiltBundleStore } } |
            Should -Throw -ExpectedMessage '*for: gadgets, widgets.*Build-Modules -Bundle gadgets; Build-Modules -Bundle widgets'
    }

    It 'counts a build of another stamp as missing' {
        Set-StoredBuild -Bundle widgets -Content '{ "sourceStamp": "stamp-widgets" }'
        Set-StoredBuild -Bundle gadgets -Content '{ "sourceStamp": "stamp-older" }'
        { InModuleScope Catzc.Base.QualityGates { Assert-BuiltBundleStore } } |
            Should -Throw -ExpectedMessage '*for: gadgets.*'
    }

    It 'counts a build record that does not parse, or has no stamp, as missing' {
        Set-StoredBuild -Bundle widgets -Content 'not json'
        Set-StoredBuild -Bundle gadgets -Content '{ "name": "Catzc" }'
        { InModuleScope Catzc.Base.QualityGates { Assert-BuiltBundleStore } } |
            Should -Throw -ExpectedMessage '*for: gadgets, widgets.*'
    }

    It 'asks for each bundle''s plan without building' {
        Set-StoredBuild -Bundle widgets -Content '{ "sourceStamp": "stamp-widgets" }'
        Set-StoredBuild -Bundle gadgets -Content '{ "sourceStamp": "stamp-gadgets" }'
        InModuleScope Catzc.Base.QualityGates { Assert-BuiltBundleStore }
        Should -Invoke Build-Modules -ModuleName Catzc.Base.QualityGates -Times 2 -Exactly -ParameterFilter { $DryRun -and $Silent }
    }
}
