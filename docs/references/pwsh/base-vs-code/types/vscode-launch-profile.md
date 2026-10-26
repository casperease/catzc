# pwsh/Base.VSCode/types/VscodeLaunchProfile.cs

One debug launch profile of `configs/vscode-launch.yml` (an entry of `configurations:`), rendered verbatim into the managed
`.vscode/launch.json`.

## Fields

A profile carries VS Code's own launch keys (camelCase: `script`, `cwd`, `args`, ...). Besides the three it must carry, the type keeps the
profile's full key to value map in authored order (`fields`) for the renderer.

## Validation

Constructing one maps and validates the entry: it is a mapping carrying non-empty `name`, `type` and `request` strings. Every violation is
reported in one throw.
