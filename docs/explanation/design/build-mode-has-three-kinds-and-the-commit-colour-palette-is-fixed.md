---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - DDR-RUNMODE-THREEBUILDKINDS
      - DDR-VISUAL-FIXEDCOMMITPALETTE
---

# Build mode has three kinds and the commit colour palette is fixed

This article is one rule: [DDR-RUNMODE-THREEBUILDKINDS](../../drs/design/run-modes.md#rule-ddr-runmode-threebuildkinds) and
[DDR-VISUAL-FIXEDCOMMITPALETTE](../../drs/design/visual-design.md#rule-ddr-visual-fixedcommitpalette) merged into one. It holds nothing
beyond what those two rules say.

Build mode has three kinds, told apart by where the code root lives: temporary, a devbox build under
`<RepositoryRoot>/out/pwsh/built/<bundle>/`, installed, a package under a `PSModulePath` entry put there by `Install-Catzc`, and saved, a
package copied into another root's `.vendor/`. The commit-colour palette is fixed: brown is a development commit and grey is integrated onto
main, master or release.
