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
- `format()` with a format specifier (`{0:N2}`) or over an argument that is not a string or an integer; plain `{n}` holes, which Bicep
  string interpolation compiles to, resolve.
- `toLower()`, `toUpper()`, `split()`, `substring()`, `take()`, `skip()`, `first()`, `last()`, `indexOf()` and the other string and array
  helpers.
- `union()` and `range()`, which the object spread and the `for … in range` loops compile to.
- `resourceId()`, `subscriptionResourceId()`, `extensionResourceId()`, `resourceGroup()` and `subscription()`: the scope and identity
  of the deployment. `tenantResourceId()` reads no scope and resolves. `deployment()` resolves only its `location`, and only when the caller
  passes `-Location` (the slot's environment region, which Deploy-Bicep sends as `--location`) to a template above resource-group scope;
  a nested deployment there reads its resource's evaluated `location`, and every other member, such as `name`, stays unresolved.
- A property copy (`copy` inside a property or a module parameter, which a Bicep for-expression compiles to) resolves only as a whole
  module parameter, through `ArmExpression.EvaluateCopy`; one inside a resource's properties is read as written, unexpanded.
- `guid()`, left out until it is computed exactly as ARM does (a name-based UUID over the joined arguments, which no offline check here
  confirms), and `uniqueString()`, `utcNow()` and `dateTimeAdd()`, whose values exist only at deploy time.
- The comparisons `greater()`, `less()` and their `OrEquals` forms, and `json()`, `string()` and `int()`.
