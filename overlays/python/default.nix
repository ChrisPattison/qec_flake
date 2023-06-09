(final: prev:
let
  pythonPackageOverlay = self: super: {
    pymatching = self.callPackage ./pymatching { };
    rustworkx = self.callPackage ./rustworkx { };
    ldpc = self.callPackage ./ldpc { };
    stim = self.callPackage ./stim { };
    galois = self.callPackage ./galois { };
  };
in
{
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [ pythonPackageOverlay ];
})

