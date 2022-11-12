{ stdenv,
  autoPatchelfHook,
  gtk3,
  nss,
  lib,
  fetchurl,
  libdrm,
  xorg,
  mesa,
  alsa-lib,
  libappindicator,
  udev,
  at-spi2-atk,
  pango
}:
  stdenv.mkDerivation rec{
    pname = "clash-for-windows";
    version = "0.20.7";
    src = fetchurl {
      url = "https://ghproxy.com/https://github.com/Fndroid/clash_for_windows_pkg/releases/download/${version}/Clash.for.Windows-${version}-x64-linux.tar.gz";
      sha256 = "sha256-Cf1+b5qtMSnYbdvpC5/A4P0SA9eYAq2gipyv58Wvozo=";
    };
    nativeBuildInputs = [
      autoPatchelfHook
    ];
    buildInputs = [
      gtk3
      nss
      libdrm
      mesa
      alsa-lib
      pango
      at-spi2-atk
    ] ++ (with xorg;[
        libXext
        libXcomposite
        libXrandr
        libxshmfence
        libXdamage
      ]
    );
    runtimeDependencies = [
      libappindicator
      udev
    ]; 
    installPhase = ''
      mkdir -p "$out/opt"
      cp -r . "$out/opt/clash-for-windows"
      mkdir -p "$out/bin"
      ln -s "$out/opt/clash-for-windows/cfw" "$out/bin/cfw"
    '';
    meta = with lib; {
      homepage = https://github.com/Fndroid/clash_for_windows_pkg;
      description = "A Windows/macOS/Linux GUI based on Clash and Electron";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  }
