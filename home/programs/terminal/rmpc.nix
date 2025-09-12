{
  lib,
  pkgs,
  config,
  ...
}: let
  # NOTE probably not using this, but i'm leaving it here for posterity cause I'm gonna forget how to wrap a shell script in the future LMAO
  # kunst = pkgs.stdenv.mkDerivation rec {
  #   name = "kunst";
  #   nativeBuildInputs = [pkgs.makeWrapper];
  #   buildInputs = with pkgs; [
  #     bash
  #     ffmpeg-headless
  #     imagemagick
  #     jq
  #     mpc
  #     mpd
  #     nsxiv
  #   ];
  #   src = pkgs.fetchFromGitHub {
  #     owner = "sdushantha";
  #     repo = "kunst";
  #     rev = "5149471925b6f2239b2fa5873370e297fc6b0bea";
  #     hash = "sha256-vSAp1T1Q28sPCE2BffCxBCZwyZG2VYeoC7XjZPCX2yM=";
  #   };
  #   installPhase = ''
  #     install -Dm755 ${src}/kunst $out/bin/kunst
  #     wrapProgram $out/bin/kunst --prefix PATH : '${lib.makeBinPath buildInputs}'
  #   '';
  # };
  song-change = pkgs.writeShellApplication {
    name = "song-change";
    runtimeInputs = with pkgs; [
      ffmpeg-headless
      imagemagick
      libnotify
      mpc-cli
      playerctl
      procps
    ];
    text = ''
      COVER=/tmp/waybar-mediaplayer-art.jpg
      MUSIC_DIR=${config.home.sessionVariables.MUSIC_DIR}
      ffmpeg -i "$MUSIC_DIR/$(mpc current -f %file%)" "$COVER" -y &> /dev/null
      STATUS=$?

      # Check if the file has a embbeded album art
      if [ "$STATUS" -eq 0 ];then
          true
      else
          DIR="$MUSIC_DIR$(dirname "$(mpc current -f %file%)")"

          for CANDIDATE in "$DIR/cover."{png,jpg,webp}; do
              if [ -f "$CANDIDATE" ]; then
                  convert "$CANDIDATE" $COVER &> /dev/null
              fi
          done
      fi

      notify-send -r 27072 "$(mpc --format '%title% \n%artist% - %album%' current)" -i /tmp/waybar-mediaplayer-art.jpg

      # update waybar
      pkill -RTMIN+5 waybar || true
      # update hyprlock
      pkill -USR2 hyprlock || true
    '';
  };
in {
  programs.rmpc.enable = true;
  home.packages = [song-change];
  xdg.configFile."rmpc/config.ron".text = ''
    #![enable(implicit_some)]
    #![enable(unwrap_newtypes)]
    #![enable(unwrap_variant_newtypes)]
    (
        address: "127.0.0.1:6600",
        password: None,
        theme: None,
        cache_dir: None,
        on_song_change: ["${lib.getExe song-change}"],
        volume_step: 5,
        max_fps: 30,
        scrolloff: 0,
        wrap_navigation: false,
        enable_mouse: true,
        status_update_interval_ms: 1000,
        select_current_song_on_change: false,
        album_art: (
            method: Auto,
            max_size_px: (width: 1200, height: 1200),
            disabled_protocols: ["http://", "https://"],
            vertical_align: Center,
            horizontal_align: Center,
        ),
        keybinds: (
            global: {
                ":":       CommandMode,
                ",":       VolumeDown,
                "s":       Stop,
                ".":       VolumeUp,
                "<Tab>":   NextTab,
                "<S-Tab>": PreviousTab,
                "1":       SwitchToTab("Queue"),
                "2":       SwitchToTab("Directories"),
                "3":       SwitchToTab("Artists"),
                "4":       SwitchToTab("Album Artists"),
                "5":       SwitchToTab("Albums"),
                "6":       SwitchToTab("Playlists"),
                "7":       SwitchToTab("Search"),
                "q":       Quit,
                ">":       NextTrack,
                "p":       TogglePause,
                "<":       PreviousTrack,
                "f":       SeekForward,
                "z":       ToggleRepeat,
                "x":       ToggleRandom,
                "c":       ToggleConsume,
                "v":       ToggleSingle,
                "b":       SeekBack,
                "~":       ShowHelp,
                "I":       ShowCurrentSongInfo,
                "O":       ShowOutputs,
                "P":       ShowDecoders,
            },
            navigation: {
                "k":         Up,
                "j":         Down,
                "h":         Left,
                "l":         Right,
                "<Up>":      Up,
                "<Down>":    Down,
                "<Left>":    Left,
                "<Right>":   Right,
                "<C-k>":     PaneUp,
                "<C-j>":     PaneDown,
                "<C-h>":     PaneLeft,
                "<C-l>":     PaneRight,
                "<C-u>":     UpHalf,
                "N":         PreviousResult,
                "a":         Add,
                "A":         AddAll,
                "r":         Rename,
                "n":         NextResult,
                "g":         Top,
                "<Space>":   Select,
                "<C-Space>": InvertSelection,
                "G":         Bottom,
                "<CR>":      Confirm,
                "i":         FocusInput,
                "J":         MoveDown,
                "<C-d>":     DownHalf,
                "/":         EnterSearch,
                "<C-c>":     Close,
                "<Esc>":     Close,
                "K":         MoveUp,
                "D":         Delete,
            },
            queue: {
                "D":       DeleteAll,
                "<CR>":    Play,
                "<C-s>":   Save,
                "a":       AddToPlaylist,
                "d":       Delete,
                "i":       ShowInfo,
                "C":       JumpToCurrent,
            },
        ),
        search: (
            case_sensitive: false,
            mode: Contains,
            tags: [
                (value: "any",         label: "Any Tag"),
                (value: "artist",      label: "Artist"),
                (value: "album",       label: "Album"),
                (value: "albumartist", label: "Album Artist"),
                (value: "title",       label: "Title"),
                (value: "filename",    label: "Filename"),
                (value: "genre",       label: "Genre"),
            ],
        ),
        artists: (
            album_display_mode: SplitByDate,
            album_sort_by: Date,
        ),
        tabs: [
            (
                name: "Queue",
                pane: Split(
                    direction: Horizontal,
                    panes: [(size: "40%", pane: Pane(AlbumArt)), (size: "60%", pane: Pane(Queue))],
                ),
            ),
            (
                name: "Directories",
                pane: Pane(Directories),
            ),
            (
                name: "Artists",
                pane: Pane(Artists),
            ),
            (
                name: "Album Artists",
                pane: Pane(AlbumArtists),
            ),
            (
                name: "Albums",
                pane: Pane(Albums),
            ),
            (
                name: "Playlists",
                pane: Pane(Playlists),
            ),
            (
                name: "Search",
                pane: Pane(Search),
            ),
        ],
    )
  '';
}
