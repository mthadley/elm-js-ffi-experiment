let
  pkgs = import ./nix/packages.nix;
in
pkgs.stdenv.mkDerivation {
  name = "elm-bp";
  buildInputs = with pkgs; [
    gnumake
    nodejs
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-test
  ];
  src = ./.;
  preBuild = ''
    export HOME=$TMP # Make elm happy
    make clean
  '';
  makeFlags = [ "ENVIRONMENT=production" ];
  installPhase = "cp -r dist $out";
}
