function Get-BicepPrepareHook {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.CommandInfo])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Azure.Templates.BicepTemplate] $TemplateDescriptor
    )

    # A template's own PrePost.psm1 may export the prepare hook; absent, the slot's configuration is used unchanged.
    if ($null -eq $TemplateDescriptor.prepost_module) {
        return
    }
    Write-Message "Importing per-template PrePost module: $($TemplateDescriptor.prepost_module)"
    $prepostModule = Import-Module $TemplateDescriptor.prepost_module -Scope Local -Force -PassThru
    # Hooks run strict whoever wrote them, like every catzc module.
    . $prepostModule { Set-StrictMode -Version Latest }
    if ($prepostModule.ExportedCommands.ContainsKey('Invoke-BicepPrepareParameterSet')) {
        $prepostModule.ExportedCommands['Invoke-BicepPrepareParameterSet']
    }
}
