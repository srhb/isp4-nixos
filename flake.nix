{
  outputs = _: {
    nixosModules.isp4 =
      { pkgs, lib, ... }:
      {
        boot.kernelPackages =
          let
            linux = pkgs.buildLinux rec {
              version = "6.17.9";
              modDirVersion = version;
              src = pkgs.fetchFromGitHub {
                owner = "srhb";
                repo = "linux";
                rev = "19681df17c38594a564057cd36ed8bb349f12f4e";
                hash = "sha256-JwBYKd7uJcv+wQqqwfeTdhqlkDeoEJgdx154n3zb1Rg=";
              };
            };
            kernelPackages = pkgs.linuxPackagesFor linux;
          in
          kernelPackages.extend (
            self: super: { }
          );

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
