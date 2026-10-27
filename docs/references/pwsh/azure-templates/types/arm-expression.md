# pwsh/Azure.Templates/types/ArmExpression.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `private object Postfix(object result)`, written with `//`.

```text
A property or index access on a call result (reference(...).outputs) is outside the subset.
A property (.name) or index ([key]) of a resolved object or list; on anything unresolved, or a missing key, it stays Unresolved.
```

## comment:2

Above `private object LambdaCall(string name)`, written with `//`.

```text
filter(array, predicate), map(array, body) and toObject(array, key[, value]), each lambda('item'[, 'index'], body): a body is parsed
once per item with its variables bound, and the list's order is kept. Unresolved when the array is, or a predicate or key is not a
bool or a string.
```

## comment:3

Above `private List<string> LambdaHead()`, written with `//`.

```text
lambda('item'[, 'index'], body): the variable names, with the position left at the body; a string-literal body is told from a
variable by the comma a variable is followed by.
```

## comment:4

Above `private List<object> EachItem(object source, List<string> names)`, written with `//`.

```text
The lambda body at the position, once per item with the item (and its index) bound; null when the source is no resolved list. The body
is parsed once more, unbound, so the position passes it and the lambda's closing parenthesis whatever the list held.
```

## comment:5

Above `public static object EvaluateCopy(IDictionary copy, IDictionary parameters,...`, written with `//`.

```text
A property copy entry, { name, count, input }, which a Bicep for-expression in a module parameter or a property compiles to: one
input per index, with copyIndex(name) bound to it; Unresolved when the count is not a resolved integer.
```

## comment:6

Above `public static object Evaluate(object value, IDictionary parameters,...` (occurrence 3), written with `//`.

```text
As above, with the deployment's own facts (location, subscriptionId, resourceGroupName) that deployment(), subscription(),
resourceGroup(), resourceId() and subscriptionResourceId() read; a fact it does not hold leaves them Unresolved.
```
