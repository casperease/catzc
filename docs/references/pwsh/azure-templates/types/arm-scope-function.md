# pwsh/Azure.Templates/types/ArmScopeFunction.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `using System;`, written with `//`.

```text
The ARM functions of ArmExpression's subset that read the deployment's own facts: where it is sent, its subscription and its resource
group. A fact the caller does not pass leaves the call Unresolved, never a guessed id, since a guessed id inside guid() names another resource.
```

## comment:2

Above `private static object ScopedId(List<object> args, bool atGroup, string...`, written with `//`.

```text
resourceId([subscriptionId], [resourceGroupName], type, names…) and subscriptionResourceId([subscriptionId], type, names…): the type
is the first argument holding a '/', and the arguments before it name the scope, else the deployment's own scope does.
```
