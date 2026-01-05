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
      };
  };
}
