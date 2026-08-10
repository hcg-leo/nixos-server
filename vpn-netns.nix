{ pkgs, ... }:

{
  # this lives in its own file on purpose. don't move it back inside
  systemd.services."netns@" = {
    description = "%I network namespace";
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
      ExecStop  = "${pkgs.iproute2}/bin/ip netns del %I";
    };
  };
}
