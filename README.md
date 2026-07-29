# System

This is how I manage all my computers.

This is generally my software stack:

1. NixOS is my operating system
2. Nix is my package manager
3. Tailscale is my intranet
4. 1Password is my secrets manager
5. Nomad is my workload orchestrator
6. Windows is my normies-and-normie-software OS (and WSL is used with NixOS)

## Files

### Nixos

All Nixos machines are invoked through a single Nix flake in [/nixos](/nixos). Machines are keyed by hostname, and each hostname should be unique. I don't have _that_ many computers.

### Machines

Configurations and hardware configurations for NixOS are in [/machines](/machines). Introducing a new machine is a process of using the NixOS installer to get a hardware configuration and adding it here.

### Profiles

Home manager is used to manage user profiles used within NixOS (and theoretically elsewhere) and these profiles are in [/profiles](/profiles).

### lib

Reusable Nix functions and snippets live in [/lib](/lib).

### pkgs

All software packages are described using [flakes](https://wiki.nixos.org/wiki/Flakes) and [flake-parts](https://flake.parts/), and they are in [/pkgs](/pkgs). This is different than lib, which only describes configuration snippets or helper functions. The pkgs dir is also used as an input in the nixos flake (called `local`). I don't think this is conventional in Nixland, but I like a monorepo.

### Dotfiles

Dotfiles are managed with [Chezmoi](https://www.chezmoi.io/) activated through Nix, generally. These files are in [/dotfiles](/dotfiles), but keep in mind they are templates. It is very normal in Nixland to manage all dotfiles and all config through Nixlang that writes these files. My personal feelings is this is a very bad idea. I don't want a middleman between my config and my software that's maintained by some rando with a weeb avatar (nothing against weebs, but it's always a weeb avatar). I also don't think Nixlang is that good of a language, frankly it's quite difficult to debug and it's likely that software will give more useful config errors when there isn't unnecessary indirection caused by the cult of nix pressuring the parasitic overreach of a mediocre language that borrows clout from a great package manager. 

### config

Sometimes config isn't appropriate for Chezmoi, in these instances they are organized by software package in [/config](/config).

### Syno

While I still use a Synology NAS, weird things must be done to work with this strange linux distro that has a dated kernel and no package manager. I attempt to script all these oddities, and they are in [syno](/syno).

