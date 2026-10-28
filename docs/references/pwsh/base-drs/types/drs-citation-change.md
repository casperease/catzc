# pwsh/Base.Drs/types/DrsCitationChange.cs

One record reference that `Update-DrsCitation` rewrote in a file, as a native typed model
([ADR-BCL-TYPES-NATIVETYPEDMODEL](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel)).

## What it carries

Where the reference is (a repository-relative path and a 1-based line), which form it is, and the text before and after. An `Unhandled`
change carries no new text: the reference is left as written for a person to resolve.
