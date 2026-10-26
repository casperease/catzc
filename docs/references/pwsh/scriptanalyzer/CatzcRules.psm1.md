# pwsh/.scriptanalyzer/CatzcRules.psm1

The one custom PSScriptAnalyzer rule the settings load. `Measure-CatzcRules` runs every repository check once per file.

## Entry rule

One entry rule acts only on the root block, the one with no parent, so each check runs once per file instead of once per script block. The
engine hands the rule a `ScriptBlockAst`, and every check walks the whole tree from the root.

## Loading the checks

The checks are listed by name in the module. On the first root block each check module loads nested in this one, so its `Measure-*`
functions are visible here but are not exported to the engine; a module may export more than one check. The loaded functions are kept in
`$script:measures`, declared at load so the guard reads it strict-clean.
