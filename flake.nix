{
  outputs = _: {
    nixosModules.isp4 =
      { pkgs, lib, ... }:
      {
        boot.kernelPackages =
          let
            linux = pkgs.buildLinux rec {
              version = "6.18.26";
              modDirVersion = version;
              src = fetchTarball {
                url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
                sha256 = "sha256:0ahcx78v71nspmyyhcb0rb27dv52apn531g9gxs4zscx3s1mrnfi";
              };
            };
            kernelPackages = pkgs.linuxPackagesFor linux;
          in
          kernelPackages;

        boot.kernelPatches = [
          {
            name = "v7_20251216_bin_du_add_amd_isp4_driver";
            patch = pkgs.fetchurl {
              url = "https://lore.kernel.org/all/20251216091326.111977-1-Bin.Du@amd.com/t.mbox.gz";
              hash = "sha256-ncKvOyV8YzGJR0XdyspcH2tlanYeYnV68EstYcMax+o=";
            };
          }
        ];
      };
  };
}
