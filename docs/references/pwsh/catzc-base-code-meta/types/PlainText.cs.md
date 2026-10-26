# pwsh/Base.CodeMeta/types/PlainText.cs

A comment page's synopsis and its plain-text projection: the one sentence a contract's description holds, with every link, rule code, code
span and markup stripped, and the form a YAML plain scalar takes without quoting.

## Synopsis

`Synopsis` returns the page's help synopsis with its wrapped lines joined by one space; it is empty when the page has no help or no
synopsis.

## Plain

`Plain` returns the text with links reduced to their words, rule codes and the brackets they leave empty removed, code spans and emphasis
unmarked, and every run of white space one space.

## PlainScalarFinding

`PlainScalarFinding` says why a text is no plain description, or null when it is one. A plain description is one line of letters, digits,
spaces and `. , - ( ) '` only, so a YAML plain scalar holds it as written.
