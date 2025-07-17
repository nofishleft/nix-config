# Set GTK_THEME="Adwaita:dark" for specific apps
# Usage:
# nixpkgs.overlays = [(import ./adwaita-dark-apps.nix)];
let
  wrapProgram = program: ''
    wrapProgram $out/bin/${program} --set GTK_THEME "Adwaita:dark"
  '';
in
final: prev: builtins.mapAttrs
(packageName: programs:
  prev."${packageName}".overrideAttrs (oldAttrs: {
    postInstall = (builtins.foldl'
      /*fn*/(acc: elem: acc + elem + "\n")
      /*init*/(oldAttrs.postInstall or "")
      /*array*/(builtins.map wrapProgram programs));
  })
)
{
  # Usage:
  # nameOfPackage = ["listOf" "executables" "inPackage"]
  pavucontrol = ["pavucontrol"];
  handbrake = ["ghb"];
}
