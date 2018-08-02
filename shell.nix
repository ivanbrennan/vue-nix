{ pkgs ? import ./nix/nixpkgs.nix { } }:

let

  helloVue = pkgs.callPackage ./nix { inherit pkgs; };
  prompt = builtins.readFile ./nix/prompt.sh;

in

helloVue.shell.overrideAttrs (oldAttrs: rec {
  shellHook = prompt + oldAttrs.shellHook + ''
    if [[ -s node_modules ]] && [[ ! -L node_modules ]]; then
        printf "
    %s%sWARNING%s: There is a node_modules/ folder in the root directory of the project!
    This can interfer with nix-shell's ability to find node command line utilities
    and will shadow the node packages installed by Nix.
    If you don't want this to happen, then you should remove it and restart nix-shell.
    " $(tput bold) $(tput setaf 1) $(tput sgr0)
    else
        ln -svnf $NODE_PATH node_modules
    fi
  '';
})
