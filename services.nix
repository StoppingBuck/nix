{ config, pkgs, lib, ... }:

{

  services.locate.enable = true;
  services.locate.package = pkgs.mlocate;
  services.locate.localuser = null;

  services.printing.enable = true; # Enable CUPS to print documents.

}
