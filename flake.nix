{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    lnbits.url = "github:matthewcroughan/lnbits-legend/matthewcroughan/nixify"; # https://github.com/lnbits/lnbits-legend/pull/721
  };

  outputs = { self, nixpkgs, lnbits, ... }@inputs: {
    nixosConfigurations = {
      pi = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "aarch64-linux";
        modules = [
          lnbits.nixosModules.default
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./configuration.nix
        ];
      };
    };
    images = {
      pi = self.nixosConfigurations.pi.config.system.build.sdImage;
    };
  };
}

