{
  flutter,
  fetchFromGitHub,
}: let
  pubspecLock = ./pubspec.lock.json;
in
  flutter.buildFlutterApplication rec {
    pname = "BlueBubbles";
    version = "1.13.2";

    src = fetchFromGitHub {
      owner = "BlueBubblesApp";
      repo = "bluebubbles-app";
      rev = "refs/tags/v${version}";
      sha256 = "sha256-eF1xzZTmLxgN/qKxAFtMy0Lsl7WrZzBxgHSIjfy1pJk=";
    };
    inherit pubspecLock;
  }
