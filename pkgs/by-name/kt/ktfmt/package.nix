{
  lib,
  stdenv,
  fetchurl,
  jre_headless,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "ktfmt";
  version = "0.61";

  src = fetchurl {
    url = "https://github.com/facebook/ktfmt/releases/download/v${version}/ktfmt-${version}-with-dependencies.jar";
    hash = "sha256-sqbvAjUqTEralmEBlgOBKah3183dNP5SkMdkvOmM1fk=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/ktfmt/ktfmt.jar

    makeWrapper ${jre_headless}/bin/java $out/bin/ktfmt \
      --add-flags "-jar $out/share/ktfmt/ktfmt.jar"

    runHook postInstall
  '';

  meta = {
    description = "Program that reformats Kotlin source code to comply with the common community standard for Kotlin code conventions";
    homepage = "https://github.com/facebook/ktfmt";
    license = lib.licenses.asl20;
    mainProgram = "ktfmt";
    maintainers = with lib.maintainers; [ ghostbuster91 ];
    inherit (jre_headless.meta) platforms;
  };
}
