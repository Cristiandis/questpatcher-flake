{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  libX11,
  libGL,
  fontconfig,
  gtk3,
  glib,
  icu,
  bash,
  android-tools,
  makeWrapper,
}:

buildDotnetModule rec {
  pname = "questpatcher";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "Lauriethefish";
    repo = "QuestPatcher";
    rev = "2.10.0";
    hash = "sha256-ed/4AH+kNmDbDd5zzaNA6tIwHdliv/isJaNGwuOsMsk=";
  };

  projectFile = "QuestPatcher/QuestPatcher.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

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

  executables = [ "QuestPatcher" ];

  meta = with lib; {
    description = "Generic il2cpp modding tool for Oculus Quest (1/2/3) apps";
    homepage = "https://github.com/Lauriethefish/QuestPatcher";
    license = licenses.zlib;
    platforms = [ "x86_64-linux" ];
    mainProgram = "QuestPatcher";
  };
}
