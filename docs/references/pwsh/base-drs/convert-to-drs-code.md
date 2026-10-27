# pwsh/Base.Drs/ConvertTo-DrsCode.ps1

Converts an old ADR code to its code in the rule-code language. It applies the moves and overrides given, and says a word the code already
carries once.

## help

### synopsis

Converts an old ADR code to its code in the rule-code language, naming each transform and what to review.

### description

Applies an override when one names the code, else the longest moved prefix, then says once a word the code already carries and a word
repeated back to back. The new code is checked against the code language of `drs-checks.yml`, and a violation joins the review list.

### parameter `Code`

The old ADR code, from the pipeline or by position; it must be a well-formed code (Assert-DrsCode).

### parameter `Move`

Old prefix to new prefix, matched by whole segments; the longest prefix wins.

### parameter `Override`

Old code to new code, taken as written: no other transform applies.

### parameter `Words`

Known lower-case words; a word the code already says is dropped only at a word boundary they prove, so no words, no drop.

### outputs

`[pscustomobject]` with OldCode, NewCode, Transforms and Review.

## Said words

A word the code already says, leading the rule segment, is said once, where the words prove the boundary: the said word and the remainder's
first word are words, and the said word runs on into no longer word.
