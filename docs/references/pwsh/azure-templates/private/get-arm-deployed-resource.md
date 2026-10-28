# pwsh/Azure.Templates/private/Get-ArmDeployedResource.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Lists the resources a compiled ARM template deploys, each with its evaluated name, scope and copy indexes.

### description

Walks a compiled template's resources, classic array or languageVersion 2.0 symbolic map, and returns one record per deployed resource
instance: its type, path, resource, resolved name, the evaluated scope, variables and indexes, the deployment facts, the resource group and
whether its deployment is conditional. A parameter the caller omits takes its default, evaluated over the passed ones; one with neither is
unresolved.

An `existing` resource is skipped. A copy loop yields one instance per index, none when the count resolves to 0 and one uncertain instance
when it does not resolve. A condition that resolves to false skips the resource; one that does not resolve marks it conditional. A nested
deployment is not returned itself: its template is read in turn with the parameters, location, subscription and resource group the module
passes, and its evaluated outputs are kept for a later reference() of it. When `-Outputs` is given it is filled with the template's
evaluated outputs, each with its type and value.

### parameter `Template`

The compiled template as a dictionary.

### parameter `Values`

The parameter values the deployment passes, by name.

### parameter `Path`

The path prefix of each record, default `main`; a nested deployment extends it with its label.

### parameter `Conditional`

Marks every record as conditional, set for a nested deployment whose own condition does not resolve.

### parameter `Indexes`

The copy indexes in force where the template is read; a top-level template has none.

### parameter `Location`

The location the deployment is sent to, which deployment().location reads in a template above the resource group.

### parameter `SubscriptionId`

The subscription the deployment is sent to; empty leaves subscription() and the ids unresolved.

### parameter `ResourceGroupName`

The resource group of a resource-group deployment, empty when none is known, or unresolved when a nested deployment's expression does not
resolve.

### parameter `Outputs`

A dictionary filled with the template's evaluated outputs, each with its type and value.

### outputs

`[pscustomobject]`

### example 1

```powershell
Get-ArmDeployedResource -Template $compiled -Values @{ environment = 'dev' } | Select-Object Type, Name, Conditional
```

## Known gaps of the evaluator

The resources this function lists are read through `Catzc.Azure.Templates.ArmExpression` and `Catzc.Azure.Templates.ArmFunction`, which
evaluate a subset of the ARM functions. A call outside the subset yields `Unresolved`, so a value built from it is never checked, and an L1
that asserts such a value passes on nothing. The next L1 author checks this list first, and either adds the function to the evaluator with
its `ArmExpression.Tests.ps1` case or asserts a value the subset resolves.

- `reference()` of anything but a nested deployment, `list*()` and every runtime lookup: a value read from a deployed resource, such as a
  workspace's `customerId`. A module output resolves: each nested deployment's `outputs` are evaluated in its own scope after its resources,
  and `reference()` of its id (`resourceId('Microsoft.Resources/deployments', …)`, or `extensionResourceId()` across a resource group) or of
  its symbolic name reads them, as `.outputs.<name>.value`, through `tryGet()` for a conditional module, or under `properties` with
  `'full'`. An output is only as resolved as its own expression, so one that reads a resource's runtime properties stays unresolved, and so
  does one of a module declared after its reader, or of any module when the caller passes no subscription.
- `format()` with a format specifier (`{0:N2}`) or over an argument that is not a string or an integer; plain `{n}` holes, which Bicep
  string interpolation compiles to, resolve.
- `toLower()`, `toUpper()`, `split()`, `substring()`, `take()`, `skip()`, `first()`, `last()`, `indexOf()` and the other string and array
  helpers.
- `union()` and `range()`, which the object spread and the `for … in range` loops compile to.
- Every member of `subscription()` and `resourceGroup()` beyond their ids, `subscriptionId` and `name`. `extensionResourceId()` resolves
  wherever its scope id does, the scope id followed by the provider path. `resourceId()`, `subscriptionResourceId()`, `subscription()` and
  `resourceGroup()` resolve exactly, as ARM writes them, from the facts the caller passes (`-SubscriptionId` and `-ResourceGroupName`, the
  slot's azure.yml subscription id and its resource group, which `Get-BicepSlotDeploymentFacts` reads), and stay unresolved without them,
  never as a guessed provider path: a wrong id inside `guid()` would name another resource than the deployed one. A resource group exists
  only in a resource-group template, so `resourceId()` in a subscription template without a group argument stays unresolved; a nested
  deployment's `resourceGroup` and `subscriptionId` override the caller's, and one that does not resolve leaves the ids in it unresolved.
  `tenantResourceId()` reads no scope and resolves. `deployment()` resolves only its `location`, and only when the caller passes `-Location`
  (the slot's environment region, which Deploy-Bicep sends as `--location`) to a template above the resource group; a nested deployment
  there reads its resource's evaluated `location`, and every other member, such as `name`, stays unresolved.
- A property copy (`copy` inside a property or a module parameter, which a Bicep for-expression compiles to) resolves only as a whole module
  parameter, through `ArmExpression.EvaluateCopy`; one inside a resource's properties is read as written, unexpanded.
- `uniqueString()`, `utcNow()` and `dateTimeAdd()`, whose values exist only at deploy time. `guid()` over string arguments resolves,
  computed as ARM computes it (a version 5 UUID over the arguments joined by `-`), and its `ArmExpression.Tests.ps1` case pins values
  Bicep's own evaluator gives, and a `guid()` over a `resourceId()` resolves wherever the id does, a module's `id` output included.
- The comparisons `greater()`, `less()` and their `OrEquals` forms, and `json()`, `string()` and `int()`.

## comment:1

Above `[string] $Location`, written with `#`.

```text
The location the deployment is sent to: Deploy-Bicep's --location, the slot's environment region. deployment().location reads
it in a template above the resource group; a resource-group deployment has none, as in ARM.
```

## comment:2

Above `$instances = @($null)`, written with `#`.

```text
A copy loop deploys one instance per index, each read with copyIndex() bound to it: none when the count resolves to 0, one
uncertain item when the count does not resolve.
```

## comment:3

Above `[object] $ResourceGroupName = ''`, written with `#`.

```text
The resource group a resource-group deployment lands in: the slot's group, a nested deployment's own, '' when none is known, or
Unresolved when a nested deployment's expression does not resolve.
```
