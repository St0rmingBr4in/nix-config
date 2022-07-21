```
$ NIXOS_SYSTEM_CONFIG_NAME=new-system
```

Follow https://nixos.org/manual/nixos/stable/index.html#sec-installation until 2.3.4

run :
```
$ sudo nixos-generate-config --root /mnt --show-hardware-config >> ${NIXOS_SYSTEM_CONFIG_NAME}-hardware-configuration.nix
```

Add the generated hardware config to a file in this repo and import it in the new nixosSystem config

```
diff --git a/flake.nix b/flake.nix
index 9e3a3a7..97572a3 100644
--- a/flake.nix
+++ b/flake.nix
@@ -14,10 +14,23 @@
   
   outputs = { self, nixpkgs, homeManager, nixosHardware }: {
     nixosConfigurations = {
+      new-system = nixpkgs.lib.nixosSystem {
+        system = "x86_64-linux";
+        modules = [
+          ./config.nix
+          ./new-system-hardware-configuration.nix
+          homeManager.nixosModules.home-manager {
+            home-manager.useGlobalPkgs = true;
+            home-manager.useUserPackages = true;
+            home-manager.users.st0rmingbr4in = import ./home.nix;
+          }
+        ];
+      };
       nixos-test = nixpkgs.lib.nixosSystem {
         system = "x86_64-linux";
         modules = [
           ./config.nix
           homeManager.nixosModules.home-manager {
             home-manager.useGlobalPkgs = true;
             home-manager.useUserPackages = true;

```

Commit and push

```
sudo nixos-install --flake "github:St0rmingBr4in/nix-config/master#${NIXOS_SYSTEM_CONFIG_NAME}" --no-write-lock-file
```
