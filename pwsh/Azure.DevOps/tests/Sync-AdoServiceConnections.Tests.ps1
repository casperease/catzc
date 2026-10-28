BeforeAll {
    function script:New-WidgetConnection {
        param([string] $Name, [string] $Subscription)
        # The shape Get-BicepServiceConnections lists, built here so the test needs no Catzc.Azure.Templates.
        [pscustomobject]@{ name = $Name; identity = 'widget-identity'; role = 'wd'; subscription = $Subscription; azure_role = 'owner'; templates = @('widget'); description = "$Name." }
    }
}

Describe 'Sync-AdoServiceConnections' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:writes = [System.Collections.Generic.List[object]]::new()
        Mock Write-Message -ModuleName Catzc.Azure.DevOps { }
        $script:connections = @(
            New-WidgetConnection 'sc-widget' 'widget_nonprod'
            New-WidgetConnection 'sc-gadget' 'gadget_nonprod'
            New-WidgetConnection 'sc-cog' 'cog_nonprod'
        )
        Mock Get-AzureSubscription -ModuleName Catzc.Azure.DevOps -RemoveParameterValidation Subscription {
            [pscustomobject]@{ name = $Subscription; id = "id-of-$Subscription"; tenant = [pscustomobject]@{ id = 'tenant-of-widgets' } }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/_apis/projects/*' } {
            [pscustomobject]@{ id = 'project-widget' }
        }
        # sc-widget exists with a stored secret, sc-gadget is already federated, sc-cog does not exist.
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*endpointNames=sc-widget*' } {
            [pscustomobject]@{ id = 'ep-widget'; name = 'sc-widget'; authorization = @{ scheme = 'ServicePrincipal' }; data = @{ subscriptionId = 'id-of-widget_nonprod'; scopeLevel = 'Subscription' } }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*endpointNames=sc-gadget*' } {
            [pscustomobject]@{ id = 'ep-gadget'; name = 'sc-gadget'; authorization = @{ scheme = 'WorkloadIdentityFederation' }; data = @{ subscriptionId = 'id-of-gadget_nonprod'; scopeLevel = 'Subscription' } }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*endpointNames=sc-cog*' } { @() }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $PesterBoundParameters.ContainsKey('Method') -and $Method -ne 'Get' } {
            $script:writes.Add([pscustomobject]@{ Method = $Method; Uri = $Uri; Body = $Body })
        }
        $script:run = @{ Project = 'widgets'; Organization = 'https://dev.azure.com/widgetco' }
    }

    It 'creates a missing connection, converts a secret one to federation and leaves a federated one alone' {
        $results = @(Sync-AdoServiceConnections -Connection $connections @run)
        ($results | Where-Object Target -EQ 'sc-widget').Action | Should -Be 'Update'
        ($results | Where-Object Target -EQ 'sc-gadget').Action | Should -Be 'Unchanged'
        ($results | Where-Object Target -EQ 'sc-cog').Action | Should -Be 'Create'
        $writes.Count | Should -Be 2
        $update = $writes | Where-Object Method -EQ 'Put'
        $update.Uri | Should -BeLike '*/endpoints/ep-widget?operation=ConvertAuthenticationScheme*'
        $create = $writes | Where-Object Method -EQ 'Post'
        foreach ($body in $update.Body, $create.Body) {
            $body.authorization.scheme | Should -Be 'WorkloadIdentityFederation'
            $body.authorization.parameters.Keys | Should -Not -Contain 'serviceprincipalkey'
        }
        $create.Body.data.subscriptionId | Should -Be 'id-of-cog_nonprod'
        $create.Body.description | Should -Be 'sc-cog.'
        $create.Body.serviceEndpointProjectReferences[0].projectReference.id | Should -Be 'project-widget'
    }

    It 'scopes every connection to its subscription' {
        Sync-AdoServiceConnections -Connection $connections @run | Out-Null
        ($writes | Where-Object Method -EQ 'Put').Body.data.scopeLevel | Should -Be 'Subscription'
        ($writes | Where-Object Method -EQ 'Post').Body.data.scopeLevel | Should -Be 'Subscription'
    }

    It 'converts a federated connection at another scope level back to its subscription' {
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*endpointNames=sc-gadget*' } {
            [pscustomobject]@{ id = 'ep-gadget'; name = 'sc-gadget'; authorization = @{ scheme = 'WorkloadIdentityFederation' }; data = @{ subscriptionId = 'id-of-gadget_nonprod'; scopeLevel = 'ResourceGroup' } }
        }
        $moved = @(New-WidgetConnection 'sc-gadget' 'gadget_nonprod')
        (Sync-AdoServiceConnections -Connection $moved @run).Action | Should -Be 'Update'
        ($writes | Where-Object Method -EQ 'Put').Body.data.scopeLevel | Should -Be 'Subscription'
    }

    It 'takes the connections from the pipeline, and reads the project once' {
        $results = @($connections | Sync-AdoServiceConnections @run -DryRun)
        $results | Should -HaveCount 3
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/_apis/projects/*' } -Times 1 -Exactly
    }

    It 'writes nothing on a dry run, and reports what it would do' {
        $results = @(Sync-AdoServiceConnections -Connection $connections @run -DryRun)
        $writes.Count | Should -Be 0
        @($results | Where-Object DryRun).Count | Should -Be 3
        ($results | Where-Object Target -EQ 'sc-cog').Action | Should -Be 'Create'
    }
}

Describe 'Test-AdoServiceConnections' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        $script:connections = @(
            New-WidgetConnection 'sc-widget' 'widget_nonprod'
            New-WidgetConnection 'sc-gadget' 'gadget_nonprod'
        )
        $script:run = @{ Project = 'widgets'; Organization = 'https://dev.azure.com/widgetco'; OutputFolder = (Join-Path $TestDrive 'out'); PassThru = $true }
    }

    It 'passes when every given connection exists and every connection is federated' {
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps {
            [pscustomobject]@{ name = 'sc-widget'; authorization = @{ scheme = 'WorkloadIdentityFederation' } }
            [pscustomobject]@{ name = 'sc-gadget'; authorization = @{ scheme = 'WorkloadIdentityFederation' } }
        }
        ($connections | Test-AdoServiceConnections @run).IssueCount | Should -Be 0
    }

    It 'names a stored secret, an undeclared connection and a missing one' {
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps {
            [pscustomobject]@{ name = 'sc-widget'; authorization = @{ scheme = 'ServicePrincipal' } }
            [pscustomobject]@{ name = 'sc-sprocket'; authorization = @{ scheme = 'WorkloadIdentityFederation' } }
        }
        $issues = @((Test-AdoServiceConnections -Connection $connections @run).Issues)
        $issues | Should -HaveCount 3
        $issues | Should -Contain "sc-widget: authenticates with 'ServicePrincipal', a stored credential — run Sync-AdoServiceConnections to convert it to WorkloadIdentityFederation"
        ($issues -like 'sc-sprocket: not among the given connections*') | Should -HaveCount 1
        ($issues -like 'sc-gadget: given but not in*') | Should -HaveCount 1
    }
}
