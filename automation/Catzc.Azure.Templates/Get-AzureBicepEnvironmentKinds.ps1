<#
.SYNOPSIS
    Returns the supported template environment kinds (which env class a template binds to).
.DESCRIPTION
    'standard'     (default) — the template's configs use standard environments (dev/test/preprod/prod),
                               which may appear many-per-subscription.
    'subscription'           — the template's configs use per-subscription environments (nsub/psub),
                               which appear exactly once per subscription. See docs/adr/azure/data-model.md.
.EXAMPLE
    Get-AzureBicepEnvironmentKinds
#>
function Get-AzureBicepEnvironmentKinds {
    param()
    @('standard', 'subscription')
}
