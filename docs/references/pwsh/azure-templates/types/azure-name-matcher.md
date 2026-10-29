# pwsh/Azure.Templates/types/AzureNameMatcher.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public static class AzureNameMatcher`, written with `//`.

```text
Matches a declared Azure name against the canonical form: every part but the role comes from a known candidate set, each candidate is
rendered through the one renderer, and the leftover is the role, so a name is matched, never parsed.
```

## comment:2

Above `private static List<List<KeyValuePair<string, string>>> Sets(IDictionary...`, written with `//`.

```text
Each candidate pairs the component value with the token it renders as: env and customer render readable under the long pattern and as
their shortcode under the restricted ones; slot and customer may be absent; a component the type omits renders nothing.
```
