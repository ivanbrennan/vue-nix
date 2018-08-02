{ pkgs ? import ./nix/nixpkgs.nix { } }:

let

  helloVue = pkgs.callPackage ./nix { inherit pkgs; };
  prompt = builtins.readFile ./nix/prompt.sh;

in

helloVue.shell.overrideAttrs (oldAttrs: rec {
  shellHook = prompt + oldAttrs.shellHook + ''
    ln -svnf $NODE_PATH node_modules
  '';
})
