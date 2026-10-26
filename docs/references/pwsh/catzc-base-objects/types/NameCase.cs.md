# pwsh/Base.Objects/types/NameCase.cs

The closed set of name cases, and a name split into its words and joined in another case.

## ToNormal

`ToNormal` renders a name in a case as its normal form: each namespace segment is joined in the normal form's case, the segments by `.`. The
leading and trailing underscores of snake case stay outside the case, around the normal form.
