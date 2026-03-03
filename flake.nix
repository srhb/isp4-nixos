{
  outputs = _: {
    nixosModules.isp4 =
      { pkgs, lib, ... }:
      {
        boot.kernelPackages =
          let
            linux = pkgs.buildLinux rec {
              version = "6.18.6";
              modDirVersion = version;
              src = pkgs.fetchFromGitHub {
                owner = "srhb";
                repo = "linux";
                rev = "3be91244852a6ed74b5c1363098fdd5084290cc4";
                hash = "sha256-+gTM7j64JQig6ScEa4u6hghdvz9dxXLNOeSTX0OxqV0=";
              };
            };
            kernelPackages = pkgs.linuxPackagesFor linux;
          in
          kernelPackages.extend (
            self: super: { }
          );
      };
  };
}
