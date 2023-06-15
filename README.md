Telepresence CLI packaged as nix flake.

## Usage example

```nix
{
  inputs = {
    telepresence-nix.url = "github:nxy7/telepresence-nix";
  };

  outputs = { self, telepresence-nix}:
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
