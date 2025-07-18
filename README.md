# mynixpkgs

A minimal Nix flake wrapper for custom packages.

## Usage

Add this flake as an input and use the packages from `packages.<system>`.

Example:

```nix
{
  inputs.mynixpkgs.url = "github:linuxmobile/mynixpkgs";
}
```

Then, in your configuration:

```nix
{
  environment.systemPackages = [
    inputs.mynixpkgs.packages.${pkgs.system}.<package>
  ];
}
```

## Packages

See `pkgs/` for available packages.

---

Credits: fufexan
