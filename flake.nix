{
  outputs = _: {
    nixosModules.isp4 =
      { pkgs, lib, ... }:
      {
        boot.kernelPackages =
          let
            linux = pkgs.buildLinux rec {
              version = "6.18.10";
              modDirVersion = version;
              src = fetchTarball {
                url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
                sha256 = "sha256:1jrh1ylkaivgyqgdx72r3f9wnfffmvg3bzw37k84bq53z09i7zpd";
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
              hash = "sha256-NZ04mjoij4Teh9VqAsw0RGpHtwmzYnZhSnPzVLasY5Y=";
            };
          }
        ];

        hardware.firmware = [
          (pkgs.linux-firmware.overrideAttrs (_: {
            version = "20260226";
            src = pkgs.fetchFromGitLab {
              owner = "kernel-firmware";
              repo = "linux-firmware";
              rev = "d8e138dd8970ffc9f5f879e2d62938abe6cd3f22";
              hash = "sha256-/OkEh1xB8dud4Jun3eX3QjGeByJkfHxXNSVIctgoMyQ=";
            };
          }))
        ];
      };
  };
}
