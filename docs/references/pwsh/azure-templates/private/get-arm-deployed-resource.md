# pwsh/Azure.Templates/private/Get-ArmDeployedResource.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## Known gaps of the evaluator

The resources this function lists are read through `Catzc.Azure.Templates.ArmExpression` and `Catzc.Azure.Templates.ArmFunction`, which
evaluate a subset of the ARM functions. A call outside the subset yields `Unresolved`, so a value built from it is never checked, and an L1
that asserts such a value passes on nothing. The next L1 author checks this list first, and either adds the function to the evaluator with
its `ArmExpression.Tests.ps1` case or asserts a value the subset resolves.

- `reference()`, `list*()` and every runtime lookup: a value read from a deployed resource or a module output.
- `format()`, which Bicep string interpolation (`'${a}-${b}'`) compiles to, so an interpolated name or property stays unresolved.
- `toLower()`, `toUpper()`, `replace()`, `split()`, `substring()`, `take()`, `skip()`, `first()`, `last()`, `indexOf()` and the other
  string and array helpers.
- `union()`, `coalesce()`, `tryGet()` and `range()`, which the safe-access (`.?`) and coalesce (`??`) operators and the `for … in range`
  loops compile to.
- `resourceId()`, `subscriptionResourceId()`, `tenantResourceId()`, `extensionResourceId()`, `resourceGroup()`, `subscription()` and
  `deployment()`: the scope and identity of the deployment.
- `guid()`, `uniqueString()`, `utcNow()` and `dateTimeAdd()`, whose values exist only at deploy time.
- The comparisons `greater()`, `less()` and their `OrEquals` forms, and `json()`, `string()` and `int()`.
