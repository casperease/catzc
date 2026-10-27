Describe 'Catzc.Azure.DevOps.ServiceConnectionsConfig' -Tag 'L0', 'logic' {
    It 'reads each connection''s subscription and description' {
        $config = [Catzc.Azure.DevOps.ServiceConnectionsConfig]::new([ordered]@{
                connections = [ordered]@{ 'sc-widget' = [ordered]@{ subscription = 'widget_nonprod'; description = 'The widget subscription.' } }
            })
        $config.connections['sc-widget'].subscription | Should -BeExactly 'widget_nonprod'
    }

    It 'has no way to configure a scheme or a stored secret' {
        $thrown = { [Catzc.Azure.DevOps.ServiceConnectionsConfig]::new([ordered]@{
                    connections = [ordered]@{
                        'sc-widget' = [ordered]@{ subscription = 'widget_nonprod'; description = 'x'; scheme = 'ServicePrincipal' }
                        'sc-gadget' = [ordered]@{ subscription = 'gadget_nonprod'; description = 'x'; secret = 'hunter2' }
                    }
                }) } | Should -Throw -PassThru
        $thrown.Exception.InnerException.Message | Should -BeLike "*connection 'sc-widget': unknown key 'scheme'*WorkloadIdentityFederation*"
        $thrown.Exception.InnerException.Message | Should -BeLike "*connection 'sc-gadget': unknown key 'secret'*"
    }
}

Describe 'Sync-AdoServiceConnections' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:writes = [System.Collections.Generic.List[object]]::new()
        Mock Write-Message -ModuleName Catzc.Azure.DevOps { }
        Mock Get-Config -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Config -eq 'service-connections' } {
            [Catzc.Azure.DevOps.ServiceConnectionsConfig]::new([ordered]@{
                    connections = [ordered]@{
                        'sc-widget' = [ordered]@{ subscription = 'widget_nonprod'; description = 'Widget.' }
                        'sc-gadget' = [ordered]@{ subscription = 'gadget_nonprod'; description = 'Gadget.' }
                        'sc-cog'    = [ordered]@{ subscription = 'cog_nonprod'; description = 'Cog.' }
                    }
                })
        }
        Mock Get-AzureSubscription -ModuleName Catzc.Azure.DevOps -RemoveParameterValidation Subscription {
            [pscustomobject]@{ name = $Subscription; id = "id-of-$Subscription"; tenant = [pscustomobject]@{ id = 'tenant-of-widgets' } }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/_apis/projects/*' } {
            [pscustomobject]@{ id = 'project-widget' }
        }
        # sc-widget exists with a stored secret, sc-gadget is already federated, sc-cog does not exist.
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*endpointNames=sc-widget*' } {
            [pscustomobject]@{ id = 'ep-widget'; name = 'sc-widget'; authorization = @{ scheme = 'ServicePrincipal' }; data = @{ subscriptionId = 'id-of-widget_nonprod' } }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*endpointNames=sc-gadget*' } {
            [pscustomobject]@{ id = 'ep-gadget'; name = 'sc-gadget'; authorization = @{ scheme = 'WorkloadIdentityFederation' }; data = @{ subscriptionId = 'id-of-gadget_nonprod' } }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*endpointNames=sc-cog*' } { @() }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $PesterBoundParameters.ContainsKey('Method') -and $Method -ne 'Get' } {
            $script:writes.Add([pscustomobject]@{ Method = $Method; Uri = $Uri; Body = $Body })
        }
        $script:run = @{ Project = 'widgets'; Organization = 'https://dev.azure.com/widgetco' }
    }

    It 'creates a missing connection, converts a secret one to federation and leaves a federated one alone' {
        $results = @(Sync-AdoServiceConnections @run)
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
        $create.Body.serviceEndpointProjectReferences[0].projectReference.id | Should -Be 'project-widget'
    }

    It 'writes nothing on a dry run, and reports what it would do' {
        $results = @(Sync-AdoServiceConnections @run -DryRun)
        $writes.Count | Should -Be 0
        @($results | Where-Object DryRun).Count | Should -Be 3
        ($results | Where-Object Target -EQ 'sc-cog').Action | Should -Be 'Create'
    }
}

Describe 'Test-AdoServiceConnections' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-Config -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Config -eq 'service-connections' } {
            [Catzc.Azure.DevOps.ServiceConnectionsConfig]::new([ordered]@{
                    connections = [ordered]@{
                        'sc-widget' = [ordered]@{ subscription = 'widget_nonprod'; description = 'Widget.' }
                        'sc-gadget' = [ordered]@{ subscription = 'gadget_nonprod'; description = 'Gadget.' }
                    }
                })
        }
        $script:run = @{ Project = 'widgets'; Organization = 'https://dev.azure.com/widgetco'; OutputFolder = (Join-Path $TestDrive 'out'); PassThru = $true }
    }

    It 'passes when every configured connection exists and every connection is federated' {
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps {
            [pscustomobject]@{ name = 'sc-widget'; authorization = @{ scheme = 'WorkloadIdentityFederation' } }
            [pscustomobject]@{ name = 'sc-gadget'; authorization = @{ scheme = 'WorkloadIdentityFederation' } }
        }
        (Test-AdoServiceConnections @run).IssueCount | Should -Be 0
    }

    It 'names a stored secret, an undeclared connection and a missing one' {
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps {
            [pscustomobject]@{ name = 'sc-widget'; authorization = @{ scheme = 'ServicePrincipal' } }
            [pscustomobject]@{ name = 'sc-sprocket'; authorization = @{ scheme = 'WorkloadIdentityFederation' } }
        }
        $issues = @((Test-AdoServiceConnections @run).Issues)
        $issues | Should -HaveCount 3
        $issues | Should -Contain "sc-widget: authenticates with 'ServicePrincipal', a stored credential — run Sync-AdoServiceConnections to convert it to WorkloadIdentityFederation"
        ($issues -like 'sc-sprocket: not in service-connections.yml*') | Should -HaveCount 1
        ($issues -like 'sc-gadget: in service-connections.yml but not in*') | Should -HaveCount 1
    }
}

Describe 'Catzc.Azure.DevOps.ServiceConnectionsConfig — shipped service-connections.yml' -Tag 'L1', 'integrity' {
    It 'names a configured azure.yml subscription for every connection' {
        $subscriptions = (Get-Config -Config azure).subscriptions
        foreach ($connection in (Get-Config -Config service-connections).connections.Values) {
            $subscriptions.ContainsKey($connection.subscription) | Should -BeTrue -Because "$($connection.name) reaches a configured subscription"
        }
    }
}
