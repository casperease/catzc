Describe 'Get-AdoGraphContext' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:get = {
            param([hashtable] $Arguments)
            InModuleScope Catzc.Azure.DevOps -Parameters @{ A = $Arguments } { param($A) Get-AdoGraphContext @A }
        }
    }

    BeforeEach {
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/_apis/projects/*' } { [pscustomobject]@{ id = 'p-1' } }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/graph/descriptors/p-1?*' } { 'scp.gadget' }
    }

    It 'names the project API, the Graph service and the project''s Graph descriptor' {
        $context = & $script:get @{ Project = 'Gadget'; Organization = 'https://dev.azure.com/widgetorg/' }
        $context.ApiBase | Should -Be 'https://dev.azure.com/widgetorg/Gadget/_apis'
        $context.GraphBase | Should -Be 'https://vssps.dev.azure.com/widgetorg/_apis/graph'
        $context.ScopeDescriptor | Should -Be 'scp.gadget'
    }

    It 'throws when the organization is not a dev.azure.com URL' {
        { & $script:get @{ Project = 'Gadget'; Organization = 'https://widgetorg.visualstudio.com' } } |
            Should -Throw '*is not a https://dev.azure.com/<org> URL*'
    }
}
