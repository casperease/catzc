# pwsh/Base.QualityGates/private/Assert-LinkDirectionsConfig.ps1

The validator of the link-directions config: it checks that every value a row names exists in the registry it comes from. The config type
refuses a malformed row, and this function covers what the type cannot, because each of its checks needs another registry.

## help

### synopsis

Validates link-directions.yml against the registries its rows name.

### description

The PowerShell validator of the link-directions config, found by convention and run by Invoke-ConfigValidator in this module's scope. The
config type already refuses a malformed row; this checks what the type cannot, because each check needs another registry: every class is a
role or role/subkind of file-kinds.yml (a star matching at least one), every track type is in track-types.yml, every track is declared in
the variants, every aspect is in the aspect model, every module is a loaded module, and every `because` is a code of the citation map. It
throws once, listing every problem by row and side.

### parameter `Config`

The link-directions config as read, before its type maps it.

## what it checks

Every value a row names is declared where its facet comes from, and every `because` is a registered rule code. The first part rests on
[ADR-CONF-LOADING-POWERSHELLVALIDATOR](../../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-powershellvalidator),
the second on [ADR-REPO-LINKS-DIRECTIONSAREROWS](../../../../drs/repository/links-in-repository.md#rule-adr-repo-links-directionsarerows).
The function builds the typed config first, so a row the type refuses fails before any registry is read.
