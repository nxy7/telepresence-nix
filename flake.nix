{
  description = "Project starter";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flakeUtils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flakeUtils, ... }@inputs:
    flakeUtils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        fusebits = ./fuseftp.bits;
      in {
        defaultPackage = pkgs.buildGoModule rec {
          pname = "telepresence2";
          version = "2.15.1";
          src = pkgs.fetchFromGitHub {
            owner = "telepresenceio";
            repo = "telepresence";
            rev = "v${version}";
            sha256 = "sha256-67a5e7Lun/mlRwRoD6eomQpgUXqzAUx8IS7Mv86j6Gw=";
          };
          vendorSha256 = "sha256-/13OkcLJI/q14tyFsynL5ZAIITH1w9XWpzRqZoJJesE=";
          preBuild = "cp ${fusebits} pkg/client/remotefs/fuseftp.bits";
          nativeBuildInputs = with pkgs; [ git ];

          ldflags = [
            "-s"
            "-w"
            "-X=github.com/telepresenceio/telepresence/v2/pkg/version.Version=${src.rev}"
          ];

          subPackages = [ "cmd/telepresence" ];

          meta = with pkgs.lib; {
            description =
              "Local development against a remote Kubernetes or OpenShift cluster";
            homepage = "https://telepresence.io";
            license = licenses.asl20;
            maintainers = with maintainers; [ nxyt ];
            mainProgram = "telepresence";
          };
        };

      });
}

