final: prev:
let
  # fetch qdistrnd sources
  qdistrnd = prev.fetchFromGitHub {
    owner = "QEC-pages";
    repo = "QDistRnd";
    rev = "refs/tags/v0.8.5";
    hash = "sha256-kZOBfabdDodvuP0xp2NBzr+MT2UcEMh2Cy7/LC/wNXM=";
  };

  # Swiped from GAP package source
  requiredPackages = [
    "gapdoc" "primgrp" "smallgrp" "transgrp"
  ];
  autoloadedPackages = [
    "atlasrep" "autpgrp" "alnuth" "crisp" "ctbllib" "factint" "fga"
    "irredsol" "laguna" "polenta" "polycyclic" "resclasses" "sophus"
    "tomlib" "autodoc" "io" "radiroot" "utils"    
  ];
  packagesToKeep = requiredPackages ++ autoloadedPackages ++ ["qdistrnd" "guava"];
  # Generate bash script that removes all packages from the `pkg` subdirectory
  # that are not on the whitelist. The whitelist consists of strings expected by
  # `find`'s `-name`.
  removeNonWhitelistedPkgs = whitelist: ''
    find pkg -type d -maxdepth 1 -mindepth 1 \
  '' + (prev.lib.concatStringsSep "\n" (map (str: "-not -name '${str}' \\") whitelist)) + ''
    -exec echo "Removing package {}" \; \
    -exec rm -r '{}' \;
  '';
in
{
  gap = prev.gap.overrideAttrs (old: {
    packageSet = "full";
    sourceRoot = "gap-${old.version}";
    # Add qdistrnd to derivation sources
    srcs = [old.src qdistrnd];
    # Add qdistrnd to the pkgs dir
    preConfigure = ''
      cp -r ../source pkg/qdistrnd
      chmod -R 0755 pkg/qdistrnd
    '' +
    (removeNonWhitelistedPkgs packagesToKeep) +
    ''
      patchShebangs .
    '';
  });
}
  
