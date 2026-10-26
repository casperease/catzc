# pwsh/Base.Maps/types/PdfNumber.cs

How `PdfDocument` writes a number: invariant culture, at most three decimals, no exponent, no negative zero and no trailing zeros, so the
same value always gives the same bytes whatever the session's culture. A PDF number has no exponent form, and a thousandth of a point is
far below what a reader can show.
