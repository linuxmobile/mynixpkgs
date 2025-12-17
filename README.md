A curated collection of Nix packages, built for when the official nixpkgs process is too slow or cumbersome.

## Packages

- **bmm** - Get to your bookmarks in a flash
- **chatuino** - A feature-rich TUI Twitch IRC client
- **dfft** - Monitor changes as AI agents modify your codebase
- **glow** - Render markdown on the CLI, with pizzazz!
- **helium** - Private, fast, and honest web browser based on Chromium
- **multiviewer** - Unofficial desktop client for F1 TV
- **nekot** - Terminal utility for interacting with local and cloud LLMs
- **omm** - Keyboard-driven task manager for the command line
- **orchat** - Terminal LLM client for OpenRouter, OpenAI, Ollama, etc.
- **prs** - Stay updated on PRs from your terminal
- **shore** - CLI-based frontend for inference providers
- **toney** - Fast, lightweight terminal-based note-taking app
- **youtui** - TUI and API for YouTube Music
- **yutemal** - Terminal music player for YouTube Music

## Installation

### As a Flake Input

Add this repository as an input to your flake:

```nix
{
  inputs.mynixpkgs.url = "github:linuxmobile/mynixpkgs";
}
```

Then reference packages as `inputs.mynixpkgs.packages.<system>.<package-name>`.

### As a Standalone Package

Install individual packages directly:

```bash
nix profile install github:linuxmobile/mynixpkgs#<package-name>
```

### For Development

Use the provided development shell:

```bash
nix develop github:linuxmobile/mynixpkgs
```

### Binary Caches

Some packages may require additional binary caches. You can add them to your `flake.nix`:

```nix
{
  nixConfig = {
    extra-substituters = ["https://linuxmobile.cachix.org"];
    extra-trusted-public-keys = ["linuxmobile.cachix.org-1:2K7KEjzbd3U+qMQRte/DGqttosw8EGgGVvu8vKu8D6A="];
  };
}
```

Or configure them globally in `/etc/nix/nix.conf`:

```
extra-substituters = https://linuxmobile.cachix.org
extra-trusted-public-keys = linuxmobile.cachix.org-1:2K7KEjzbd3U+qMQRte/DGqttosw8EGgGVvu8vKu8D6A=
```

## Supported Systems

- x86_64-linux
- aarch64-linux
- x86_64-darwin
- aarch64-darwin

## License

MIT

---

Built out of necessity. The official channels move too slowly for my needs.
