{
  outputs = _: {
    nixosModules.isp4 =
      { pkgs, lib, ... }:
      lib.warn
        "isp4-nixos is outdated. Simply set `boot.kernelPackages = pkgs.linuxPackages_7_2;` which has full support for isp4"
        {
          boot.kernelPackages = pkgs.linuxPackages_7_2;
        };
  };
}
