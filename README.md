Telepresence CLI packaged as nix flake.

## Usage example

```nix
{
  inputs = {
    flakeUtils.url = "github:numtide/flake-utils";
    telepresence-nix.url = "github:nxy7/telepresence-nix";
  };

  outputs = { self, flakeUtils, telepresence-nix }:
    flakeUtils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        telepresencePkg = telepresence-nix.outputs.defaultPackage.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            telepresencePkg
          ];
        };
      });
}
```
