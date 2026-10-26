# pwsh/Base.Languages/types/JavaScriptConfig.cs

The typed record for `javascript.yml`, the settings of the js track.

## DefaultTypesFolder

`DefaultTypesFolder` is the repository-relative, gitignored folder the tooling installs the type declarations into (`npm --prefix`), so the
generated `jsconfig.json` names the same relative type root on every machine.
