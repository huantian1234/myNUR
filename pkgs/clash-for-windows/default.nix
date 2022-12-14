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
  pango,
  makeDesktopItem,
  imagemagick
}:
let
  clash-for-windows-icon = {
    pname = "clash-for-windows-icon";
    version = "0";
    src = fetchurl {
    url = "https://docs.cfw.lbyczf.com/favicon.ico";
      sha256 = "sha256-4uLJzumIqF6T1yvrdKciqrSNYpJ1+6ecmonRzOsopP0=";
    };
  };
  desktopItem = makeDesktopItem {
    name = "clash-for-windows";
    desktopName = "Clash for Windows";
    comment = "A Windows/macOS/Linux GUI based on Clash and Electron";
    icon = "clash-for-windows";
    exec = "cfw";
    categories = [ "Network" ];
  };
  icon = "${clash-for-windows-icon.src}[4]";
in
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
      
      mkdir -p "$out/share/applications"
      install "${desktopItem}/share/applications/"* "$out/share/applications/"
      icon_dir="$out/share/icons/hicolor"
      for s in 16 24 32 48 64 128 256; do
        size="''${s}x''${s}"
        echo "create icon \"$size\""
        mkdir -p "$icon_dir/$size/apps"
        ${imagemagick}/bin/convert -resize "$size" "${icon}" "$icon_dir/$size/apps/clash-for-windows.png"
      done
    '';
    meta = with lib; {
      homepage = https://github.com/Fndroid/clash_for_windows_pkg;
      description = "A Windows/macOS/Linux GUI based on Clash and Electron";
      #license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  }
