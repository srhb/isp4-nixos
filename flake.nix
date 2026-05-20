{
  outputs = _: {
    nixosModules.isp4 =
      { pkgs, lib, ... }:
      {
        boot.kernelPackages =
          let
            linux = pkgs.buildLinux rec {
              version = "7.0.9";
              modDirVersion = version;
              src = fetchTarball {
                url = "https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-${version}.tar.xz";
                sha256 = "sha256:11hxkkcryzf0y6p058g4fjfdavw9q072kflr1d7adffi1mdkj9br";
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
          {
            # This is an unrelated problem to isp4 that fixes bluetooth on a
            # zbook g1a, included because we're rebuilding anyway. It's queued
            # for inclusion in 7.0.10
            name = "btmtk-bluetooth-regression-fix";
            patch = pkgs.fetchpatch2 {
              url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/plain/queue-7.0/bluetooth-btmtk-accept-too-short-wmt-func_ctrl-events.patch";
              hash = "sha256-q/sB4SLlqwtrnjmLKzkFa5B7sD8GDmhsZNd+hfcC1sY=";
            };
          }
        ];
      };
  };
}
