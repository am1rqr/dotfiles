# Contributing

These are personal dotfiles, tailored to one machine, so there is no roadmap. Fixes and suggestions are still welcome.

- **Questions and "how do I adapt X"**: use [Discussions](https://github.com/am1rqr/dotfiles/discussions).
- **Something doesn't build or evaluate**: open an issue with the template. Include the command you ran and the full error.
- **Pull requests**: keep them small and focused (one fix or one module). Match the surrounding style: one concern per file, comments only where the logic is non-obvious.

Before opening a PR, check that the host still evaluates:

```bash
nix eval .#nixosConfigurations.nixos.config.system.build.toplevel.drvPath
```

CI runs the same check on every push and pull request.
