{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        { pkgs, ... }:
        let
          project-python = pkgs.python3.buildEnv.override { extraLibs = [ pkgs.python3.pkgs.pip ]; };
        in
        # .override configureFlags with '--ensurepip' as a nuclear option?
        {
          packages.default = project-python.pkgs.buildPythonApplication {
            pname = "demo";
            version = "0.0.1";
            meta.mainProgram = "demo";

            format = "pyproject";

            src = ./src;

            nativeBuildInputs = builtins.attrValues { inherit (project-python.pkgs) setuptools; };

            pythonPath = builtins.attrValues { inherit (project-python.pkgs) pip; };

            propagatedBuildInputs = builtins.attrValues { inherit (project-python.pkgs) pip; };
          };
        };
    };
}
