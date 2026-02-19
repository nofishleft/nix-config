{ config, pkgs, lib, ...}:
let
  createSecrets = keys: lib.mergeAttrsList (
    map (key: {
      "${key}" = {
        sopsFile = ./secrets/work_vpn.yaml;
        owner = "root";
        group = "root";
        mode = "0600";
      };
    }) keys
  );
in {
  options.work_vpn.enable = lib.mkEnableOption "Enable work vpn";

  config = lib.mkIf config.work_vpn.enable {
    sops.secrets = createSecrets [
      "vpn_gateway"
      "vpn_psk"
      "vpn_username"
      "vpn_password"
      "vpn_dns"
      "vpn_routes"
    ];
    
    networking.networkmanager.enable = lib.mkForce true;

    networking.networkmanager.plugins = [
      pkgs.networkmanager-l2tp
      pkgs.networkmanager-strongswan
    ];

    environment.etc."strongswan.conf".text = ''
      integrity_test = no
    '';

    #services.strongswan.enable = true;
#    services.strongswan-swanctl = {
#      enable = true;
#      strongswan.extraConfig = ''
#        integrity_test = no
#      '';
#    };

#    systemd.services.strongswan-swanctl.wantedBy = lib.mkForce [];

    system.activationScripts.work-vpn = {
      deps = [ "setupSecrets" ];
      text = ''
          VPN_GATEWAY=$(cat ${config.sops.secrets."vpn_gateway".path})
          VPN_PSK=$(cat ${config.sops.secrets."vpn_psk".path})
          VPN_USERNAME=$(cat ${config.sops.secrets."vpn_username".path})
          VPN_PASSWORD=$(cat ${config.sops.secrets."vpn_password".path})
          VPN_DNS=$(cat ${config.sops.secrets."vpn_dns".path})
          VPN_ROUTES="$(cat ${config.sops.secrets."vpn_routes".path})"

          cat > /etc/NetworkManager/system-connections/work_vpn.nmconnection <<NMEOF
${builtins.readFile ./work_vpn.nmconnection}
NMEOF
          chmod 600 /etc/NetworkManager/system-connections/work_vpn.nmconnection
          chown root:root /etc/NetworkManager/system-connections/work_vpn.nmconnection
        '';
    };
  };
}
