{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "development-setup";
  src = ./src;
  buildInputs = [ pkgs.networkmanager ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      sed \
        -e "s#OUT#$out#" \
	-e "s#OPENSSH#${pkgs.openssh}/bin#" \
	-e "s#GIT#${pkgs.git}/bin#" \
	-e "s#GNUPG#${pkgs.gnupg}/bin#" \
	-e "w$out/bin/development-setup" \
	development-setup.sh &&
      chmod 0555 $out/bin/development-setup &&
      sed \
        -e "s#OUT#$out#" \
	-e "s#OPENSSH#${pkgs.openssh}/bin#" \
	-e "s#GIT#${pkgs.git}/bin#" \
	-e "s#GNUPG#${pkgs.gnupg}/bin#" \
	-e "w$out/bin/pre-push" \
	pre-push.sh &&
      chmod 0555 $out/bin/pre-push &&
      sed \
        -e "s#OUT#$out#" \
	-e "s#OPENSSH#${pkgs.openssh}/bin#" \
	-e "s#GIT#${pkgs.git}/bin#" \
	-e "s#GNUPG#${pkgs.gnupg}/bin#" \
	-e "w$out/bin/post-commit" \
	post-commit.sh &&
      chmod 0555 $out/bin/post-commit &&
      true
  '';
}