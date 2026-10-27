# pwsh/Azure.Templates/types/ArmFunction.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `private static object Format(List<object> args)`, written with `//`.

```text
format('…{0}…', a, …), which Bicep string interpolation compiles to: plain {n} holes and {{ }} escapes over string and integer
arguments; a format specifier or another argument kind is outside the subset, since its text depends on ARM's formatter.
```

## comment:2

Above `private static readonly byte[] GuidNamespace =`, written with `//`.

```text
ARM's guid(): an RFC 4122 version 5 UUID, SHA-1 over ARM's namespace 11fb06fb-712d-4ddd-98c7-e71bbd588830 followed by the name's
UTF-8 bytes, written in lower case. Checked against Bicep's own evaluator (bicep build-params), whose values the L0 case pins.
```
