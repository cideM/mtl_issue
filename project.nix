{ mkDerivation, base, lib, mtl, safe-exceptions }:
mkDerivation {
  pname = "haskell-starter";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base mtl safe-exceptions ];
  license = "unknown";
  mainProgram = "haskell-starter";
}
