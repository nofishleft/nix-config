{ pkgs, ... }:
{
  cxx = pkgs.mkShell {
    stdenv = pkgs.gcc14Stdenv;

    nativeBuildInputs = [
      pkgs.cmake
    ];

    buildInputs = [
      

    ];
  };
}
