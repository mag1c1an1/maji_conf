{
  inputs,
  pkgs,
  ...
}: {
  virtualisation.docker = {enable=true;};
  users.users.maji.extraGroups = ["docker"];
  }
