let
  pkgs = import ./nix/packages.nix;
in
pkgs.mkShell {
  inputsFrom = [ (import ./default.nix) ];

  buildInputs = with pkgs; [
    entr
  ];
}
