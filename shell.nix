{ pkgs ? import <nixpkgs> {} }:

let
    ansibleCollectionPath = pkgs.callPackage ./ansible-collections.nix {} pkgs.ansible {
        "containers-podman" = {
            version = "1.9.3";
            sha256 = "sha256:1vjsm7696fp9av7708h05zjjdil7gwcqiv6mrz7vzmnnwdnqshp7";
        };
    };
in
# we make an fhs to make easier portable playbook execution, which assumes #!/bin/sh for script commands
(pkgs.buildFHSUserEnv {
  name = "ansiblenv";
  targetPkgs = pkgs: with pkgs; [
      zsh
      (python39.withPackages (p: with p; [ pexpect ansible jmespath ]))
  ];
  runScript = ''
    ${pkgs.zsh}/bin/zsh
  '';
  profile = ''
    export ANSIBLE_COLLECTIONS_PATHS="${ansibleCollectionPath}"
    export SSH_AUTH_SOCK=/run/user/$UID/keyring/ssh
    export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
    export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
  '';
}).env