# automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Walks a key path into an already-loaded config node and returns the addressed node.

### description

The traversal seam behind Get-ConfigValue (see ADR-CONF-ADDRESSING). Given a config node — a raw ordered dictionary or a
typed/validated object returned by Get-Config — and an ordered list of key segments, it walks one segment at a time and returns the node
reached (a leaf value or a subtree).

Each segment resolves as a dictionary key when the current node is an IDictionary, otherwise as a property on the node (so a typed C# config
object and a raw dictionary traverse the same way,
[ADR-CONF-ADDRESSING#2](../../../../adr/configuration/config-value-addressing.md#rule-adr-conf-addressing2)). Any segment that resolves at
neither throws, naming the full address and the failing segment
([ADR-CONF-ADDRESSING#4](../../../../adr/configuration/config-value-addressing.md#rule-adr-conf-addressing4)) — there is no silent $null. An
empty segment list returns the node unchanged (addressing the whole config).

The returned node may be a live reference into the config cache and must be treated as read-only
([ADR-CONF-ADDRESSING#5](../../../../adr/configuration/config-value-addressing.md#rule-adr-conf-addressing5)).

### parameter `Node`

The config node to walk into — the object Get-Config returned for the config name.

### parameter `Segment`

The ordered key segments to walk (may be empty to address the node itself).

### parameter `Address`

The full global config address, used only to make traversal errors self-locating.
