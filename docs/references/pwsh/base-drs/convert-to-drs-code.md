# pwsh/Base.Drs/ConvertTo-DrsCode.ps1

Converts an old ADR code to its code in the rule-code language. It applies the moves and overrides given, and says a word the code already
carries once.

## Said words

A word the code already says, leading the rule segment, is said once, where the words prove the boundary: the said word and the remainder's
first word are words, and the said word runs on into no longer word.
