# pwsh/Base.Objects/types/ConsoleDisplayAttribute.cs

The attribute that names the identity properties of the type it decorates: the few that tell one instance from another at a glance. It is
BCL only and declares its module namespace, file-scoped, per the type loader.

## One declaration, two surfaces

The one declaration drives both console surfaces of a catzc object held in pwsh:

1. its text: `ConsoleText.ToConsoleString` renders only these properties, so `"$x"`, `[string]$x`, `-join` and a nested table cell read
   `SubscriptionContext { Id = 1f2e…, Name = Contoso Prod }`;
2. its prompt display: `Import-CSharpTypes` registers them as the type's `DefaultDisplayPropertySet`, so typing `$x`, or a command returning
   one, shows these columns instead of every property.

Without the attribute both surfaces show every public property. The names are checked when the type is rendered: an unknown name throws,
naming the type and the property.
