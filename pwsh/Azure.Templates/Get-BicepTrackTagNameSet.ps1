function Get-BicepTrackTagNameSet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template
    )

    # The names are azure.yml's tag schema; a subscription-target template prefixes its own, as its subscription holds every template's tags.
    $provenance = (Get-Config -Config azure).tags.provenance
    $prefix = if ((Get-BicepTemplate $Template).deployment_target -eq 'Subscription') {
        "$($Template.ToLowerInvariant())-"
    }
    else {
        ''
    }
    [ordered]@{
        commit   = "$prefix$($provenance['commit'])"
        build_id = "$prefix$($provenance['build_id'])"
        branch   = "$prefix$($provenance['branch'])"
    }
}
