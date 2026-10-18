# The shared loader of a source module ([ADR-PWSH-MANIFEST](/docs/adr/pwsh/dynamic-module-manifests.md)): every
# derived <Module>.psd1 names this script as its one NestedModule and lists the module's function files in
# PrivateData.CatzcFiles (private/ first, then the root, each group ordinal, relative to the module folder). As a
# nested .ps1 it runs in the module's session state, so each file it dot-sources defines its function there: public
# and private share one scope, and FunctionsToExport filters what leaves the module.
#
# Each file is parsed in memory (Parser::ParseFile) rather than run as a script file: loading a .ps1 as a script costs
# about 3 ms per file on top of its parse, which over every module was most of the import (out/plan-test-runtime.md,
# benchmark A9). The script block keeps its file name and line numbers, so Get-Command, error positions and stack
# traces name the source file exactly as a dot-sourced file does.
foreach ($catzcModuleFile in $ExecutionContext.SessionState.Module.PrivateData.CatzcFiles) {
    $catzcModuleFile = [System.IO.Path]::Combine($ExecutionContext.SessionState.Module.ModuleBase, $catzcModuleFile)
    $catzcParseErrors = $null
    $catzcModuleAst = [System.Management.Automation.Language.Parser]::ParseFile($catzcModuleFile, [ref] $null, [ref] $catzcParseErrors)
    if ($catzcParseErrors) {
        $catzcFirstError = $catzcParseErrors[0]
        throw "$($catzcFirstError.Extent.File):$($catzcFirstError.Extent.StartLineNumber): $($catzcFirstError.Message)"
    }
    . $catzcModuleAst.GetScriptBlock()
}
Remove-Variable -Name catzcModuleFile, catzcParseErrors, catzcModuleAst, catzcFirstError -ErrorAction Ignore
