{
  outputs = _: {
    nixosModules.isp4 =
      { pkgs, lib, ... }:
      {
        boot.kernelPackages =
          let
            linux = pkgs.buildLinux rec {
              version = "6.18.3";
              modDirVersion = version;
              src = pkgs.fetchFromGitHub {
                owner = "srhb";
                repo = "linux";
                rev = "ef0493b6a080b30e82daa468e569f79ab37443b2";
                hash = "sha256-h1VYUMkINfLSNn9xPBeNuXj26FcevAhq1EmGvQ2vWhI=";
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
