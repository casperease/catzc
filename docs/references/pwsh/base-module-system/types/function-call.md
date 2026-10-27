# pwsh/Base.ModuleSystem/types/FunctionCall.cs

One statically named command call inside a function body: the command name as written (`Name`) and the line it starts on (`Line`).
`FunctionCallCollector` collects them for `Test-FunctionDependency`. The name is required. The properties are PascalCase because this is a
result shape, not a mirror of a YAML file.
