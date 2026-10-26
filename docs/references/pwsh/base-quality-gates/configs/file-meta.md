# pwsh/Base.QualityGates/configs/file-meta.yml

The head policy of the file meta: which classes of file carry the facts their kinds produce, none at all, or only their authored config
part.

## Head policy

`head_policy.default` is the policy of a class the list does not name: `facts` writes a head only when a fact is non-empty. Each entry of
`head_policy.classes` names one file class and its policy: `forbidden` keeps every head off the file (an agent definition, a diagram
declaration), and `config` keeps only the authored config part (a capability, a slide). A file with no fact still carries no head.

A reference page is found from its source file by its derived path, so no file carries a link to its page and no page a link back.
