{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  fetchurl,
  libX11,
  libGL,
  fontconfig,
  gtk3,
  glib,
  icu,
  bash,
  android-tools,
  makeWrapper,
  python3,
}:

buildDotnetModule rec {
  pname = "questpatcher";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "Lauriethefish";
    repo = "QuestPatcher";
    rev = version;
    hash = "sha256-ed/4AH+kNmDbDd5zzaNA6tIwHdliv/isJaNGwuOsMsk=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/Lauriethefish/QuestPatcher/${version}/QuestPatcher/Assets/questpatcher-logo.ico";
    hash = "sha256-koOqmch4dmWZ4Uh21P3eZQQRE7onYjXngFBHQPnECQ8=";
  };

  projectFile = "QuestPatcher/QuestPatcher.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  nativeBuildInputs = [
    makeWrapper
    (python3.withPackages (ps: [ ps.pillow ]))
  ];

  runtimeDeps = [
    libX11
    libGL
    fontconfig
    gtk3
    glib
    icu
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        bash
        android-tools
      ]
    }"
  ];

  postInstall = ''
    python3 -c "
    from PIL import Image
    img = Image.open('${icon}')
    img.save('questpatcher.png', format='PNG', sizes=[(256,256)])
    "
    install -Dm644 questpatcher.png $out/share/icons/hicolor/256x256/apps/questpatcher.png
    mkdir -p $out/share/applications
    cat > $out/share/applications/questpatcher.desktop <<EOF
    [Desktop Entry]
    Name=QuestPatcher
    Comment=Generic il2cpp modding tool for Oculus Quest apps
    Exec=QuestPatcher
    Icon=questpatcher
    Type=Application
    Categories=Utility;
    EOF
  '';

  executables = [ "QuestPatcher" ];

  meta = with lib; {
    description = "Generic il2cpp modding tool for Oculus Quest (1/2/3) apps";
    homepage = "https://github.com/Lauriethefish/QuestPatcher";
    license = licenses.zlib;
    platforms = [ "x86_64-linux" ];
    mainProgram = "QuestPatcher";
  };
}
