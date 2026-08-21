{
  outputs = _: {
    nixosModules.isp4 =
      { pkgs, lib, ... }:
      let
        zfso = final: prev: {
          name = "zfs-2.4.4pre";
          version = "2.4.4pre"; # ish
          __intentionallyOverridingVersion = true;

          patches = [];
          postPatch = builtins.replaceStrings [ "7\\.0" ] [ "7\\.2" ] prev.postPatch;
          src = pkgs.fetchFromGitHub {
            owner = "openzfs";
            repo = "zfs";
            rev = "2be8581ade2d8f67e7390d161a0e042292818830";
            hash = "sha256-zKepiBGUxC3rvbac7O/vZ07joZu9wZ5Vf7PMiGuzjOM=";
          };

          meta = prev.meta // {
            broken = false;
          };
        };
      in
      {

        boot.kernelPackages =
          let
            kernelPackages = pkgs.linuxPackages_7_2;
          in
          kernelPackages.extend (
            self: super: {
              zfs_2_4 = super.zfs_2_4.overrideAttrs zfso;
            }
          );

        boot.zfs.package = pkgs.zfs.overrideAttrs zfso;
      };
  };
}
