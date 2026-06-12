{
  outputs = _: {
    nixosModules.isp4 =
      { pkgs, lib, ... }:
      {
        boot.kernelPackages =
          let
            linux = pkgs.buildLinux rec {
              version = "7.0.12";
              modDirVersion = version;
              src = fetchTarball {
                url = "https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-${version}.tar.xz";
                sha256 = "sha256:0qfw2hxs8lzwixwfyg7h6zaljmy5jq2p16p5c48x4xb30hskmifj";
              };
            };
            kernelPackages = pkgs.linuxPackagesFor linux;
          in
          kernelPackages;

        boot.kernelPatches = [
          {
            name = "v10_20260506_bin_du_add_amd_isp4_driver";
            patch = pkgs.fetchurl {
              url = "https://lore.kernel.org/all/20260506093250.93460-1-Bin.Du@amd.com/t.mbox.gz";
              hash = "sha256-PU0h7Wd3LC0vuXkWGd2YHAKTkGRvwZ79ZMkK3liea7A=";
            };
          }
        ];
      };
  };
}
