# pwsh/Base.Overlay/private/Get-LocalModuleViolation.ps1

The check of a consumer's local module: it returns one message per reason the module cannot load, so `Assert-CatzcOverlay` can list them
all.

## help

### synopsis

Returns every reason a consumer's local module cannot load.

### description

A local module is an overlay folder that names no bundled module, and it follows catzc's own module conventions
([ADR-AUTO-OVERLAY](../../../../drs/automation/consumer-overlay.md)): it never takes the reserved Catzc. prefix; it carries no types/ (a
bundle compiles no C#); it holds only function files at its root (public) and under private/, and configs/, assets/ and tests/; every
function file passes the shape check every function file loaded away from its folder passes (Get-FunctionFileViolation); it has at least one
function; and none of its public functions takes the name of a command already loaded, which would silently replace a bundled one —
replacing a bundled function is an override, not a local module.

### parameter `Path`

The local module's folder.

### parameter `RelativePath`

The folder as the messages show it.

### outputs

`[string]` One message per violation; nothing when the module can load.

## Why the walk prunes nothing

A violation anywhere in the module must show, so the walk is a named whole-tree walk
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)) that prunes
nothing.

## The folder name

A folder never spells the modules track's namespace
([DDR-TRACK-MODULENAMESPACE](../../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)): the folder resolves to its full name, and
the bundle names the fix.
