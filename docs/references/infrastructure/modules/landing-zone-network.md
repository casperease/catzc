# infrastructure/modules/landing-zone-network.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `var hubRoutes = [`, written with `//`.

```text
A spoke sends everything leaving its network to the hub firewall, other spokes included, since peering is not transitive; a hub sends
its shared services' traffic to the spokes through the firewall too, so the return path is symmetric. The address is derived, and a live
deploy must confirm Azure assigned it to the firewall.
```
