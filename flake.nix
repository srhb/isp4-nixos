{
  outputs = _: {
    nixosModules.isp4 =
      { pkgs, lib, ... }:
      let
        zfso = final: prev: {
          version = "2.3.4"; # ish
          __intentionallyOverridingVersion = true;
          patches = prev.patches ++ [
            (pkgs.fetchpatch {
              url = "https://github.com/openzfs/zfs/pull/17621.patch";
              hash = "sha256-HmQV8QK0GinSLGJD8qZyXcV40mNE4Cw3GDiUAA7NjQA=";
            })
          ];

          postPatch = prev.postPatch + ''
            sed -i 's/6.16/6.17/' META
          '';
          meta = prev.meta // {
            broken = false;
          };
        };
      in
      {

        boot.kernelPackages =
          let
            linux = pkgs.buildLinux rec {
              version = "6.17.7";
              modDirVersion = version;
              src = pkgs.fetchFromGitHub {
                owner = "srhb";
                repo = "linux";
                rev = "0e1092c278c9c88f97d9c09b854e0b06aeda65ec";
                hash = "sha256-pIsTm8alb3OM57Kw2Oo4c0mIm3uz57K2qOp+aXnwT+8=";
              };
            };
            kernelPackages = pkgs.linuxPackagesFor linux;
          in
          kernelPackages.extend (
            self: super: {
              zfs_2_3 = super.zfs_2_3.overrideAttrs zfso;
            }
          );

        boot.zfs.package = pkgs.zfs.overrideAttrs zfso;

        nixpkgs.overlays = [
          (self: super: {
            linux-firmware = super.linux-firmware.overrideAttrs (
              final: prev: {
                version = "f044bc789f8e7a4427593b687801644c39e3e8b7";
                src = super.fetchFromGitLab {
                  owner = "kernel-firmware";
                  repo = "linux-firmware";
                  rev = final.version;
                  hash = "sha256-zFtuvA49qI68i5JMX4iJ3LFlwUpi7nDuv17eFtXFB5U=";
                };
              }
            );
            libcamera2 = super.libcamera.overrideAttrs (
              final: prev: {
                src = self.fetchFromGitHub {
                  owner = "amd";
                  repo = "Linux_ISP_libcamera";
                  rev = "206687ae94fb59235daad140852ddec1f9f87a19";
                  hash = "sha256-7//RctObxrNjgb8tx277qDREF8W4e4zADnS3NyO15UY=";
                };
              }
            );
          })
        ];

        system.replaceDependencies.replacements = [
          {
            oldDependency = pkgs.libcamera;
            newDependency = pkgs.libcamera2;
          }
        ];
      };
  };
}
