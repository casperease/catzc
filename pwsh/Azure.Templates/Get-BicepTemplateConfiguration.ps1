function Get-BicepTemplateConfiguration {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '',
        Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template,

        [Parameter(Mandatory, Position = 1)]
        [string] $Environment,

        [Parameter(Position = 2)]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateSlots -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment'] -Customer $fakeBoundParameters['Customer']
            })]
        [string] $Slot,

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateCustomers -Template $fakeBoundParameters['Template']
            })]
        [string] $Customer
    )

    $templateDescriptor = Get-BicepTemplate $Template

    if (-not [string]::IsNullOrEmpty($Slot) -and $Slot -notmatch '(?-i)^[a-z0-9]{1,3}$') {
        throw "Invalid -Slot '$Slot' — must be 1-3 lowercase alphanumeric chars (e.g. 001)."
    }

    # The coordinate is the file address: root for the shared platform, configuration/<customer>/ for a customer deployment.
    $configName = Get-BicepConfigName $Environment $Slot
    $folder = if ([string]::IsNullOrEmpty($Customer)) {
        $templateDescriptor.configuration_folder
    }
    else {
        Join-Path $templateDescriptor.configuration_folder $Customer
    }
    $environmentFile = Join-Path $folder "$configName.yml"
    $where = if ([string]::IsNullOrEmpty($Customer)) {
        'at the configuration root'
    }
    else {
        "under configuration/$Customer/"
    }
    # The Bicep compiler reads a bicepparam slot, so its descriptor carries the source path and its sibling yml's declared group.
    $bicepParamFile = Join-Path $folder "$configName.bicepparam"
    if ([System.IO.File]::Exists($bicepParamFile)) {
        $descriptor = [ordered]@{ BicepParamFile = $bicepParamFile }
        if ([System.IO.File]::Exists($environmentFile)) {
            $sibling = [System.IO.File]::ReadAllText($environmentFile) | ConvertFrom-Yaml -Ordered
            if ($sibling -is [System.Collections.IDictionary] -and $sibling.Contains('ResourceGroup')) {
                $descriptor['ResourceGroup'] = $sibling.ResourceGroup
            }
        }
        return $descriptor
    }
    # A slot with no file of its own is an ephemeral slot: it reads its base slot's config (Resolve-BicepSlot).
    if (-not [System.IO.File]::Exists($environmentFile) -and -not [string]::IsNullOrEmpty($Slot)) {
        $runtime = Resolve-BicepSlot -TemplateDescriptor $templateDescriptor -Environment $Environment -Slot $Slot -Customer $Customer
        if ($runtime -and $runtime.file -like '*.yml') {
            $environmentFile = $runtime.file
        }
    }
    Assert-PathExist $environmentFile -PathType Leaf -ErrorText "Template '$Template' has no config '$configName.yml' or '$configName.bicepparam' $where ($environmentFile)"

    Get-Content $environmentFile -Raw | ConvertFrom-Yaml -Ordered
}
