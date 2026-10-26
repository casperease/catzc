# pwsh/Base.VSCode/configs/lamp-palette.yml

The lamp palette: the shades of every range the track lamps and the icon theme draw with.

## Ranges

Every shade of each range (committed, staged, unstaged, failed, empty, veto) has its default on `LampPaletteConfig`. A shade set here
overrides it, for example `ranges: { unstaged: { text: "#b3c3d8" } }`. Settings and manifests name a shade as `palette.<range>.<shade>`, and
`Resolve-LampPaletteShade` replaces it with the hex.
