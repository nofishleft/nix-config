let
  concat = array: (builtins.foldl' (acc: elem: acc + elem + "\n") "" array);
  wrapProgram = program: ''
    wrapProgram $out/bin/${program} --set GTK_THEME "Adwaita:dark"
  '';
  wrapPrograms = programs: (concat (builtins.map wrapProgram programs));
in
final: prev: builtins.mapAttrs
(name: value:
  prev."${name}".overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + (wrapPrograms value);
  })
)
{
  pavucontrol = ["pavucontrol"];
  handbrake = ["ghb"];
}
