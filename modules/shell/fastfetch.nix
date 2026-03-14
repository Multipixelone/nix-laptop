{
  flake.modules.homeManager.base = {
    programs.fish.shellAliases = {
      ff = "fastfetch";
    };
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          type = "auto";
          padding = {
            top = 1;
            left = 4;
          };
          width = 10;
        };

        display = {
          separator = " ";
          bar.char = {
            elapsed = "█";
            total = "░";
            width = 20;
          };
        };

        modules = [
          {
            type = "custom";
            format = "⊹₊⋆☁︎⋆⁺₊ finn@infra ⋆ .🌙⊹₊.";
            outputColor = "34";
          }
          "break"

          # ── Hardware ──────────────────────────────────────────
          {
            type = "custom";
            format = "┌──────────────────────Hardware──────────────────────┐";
            outputColor = "yellow";
          }
          {
            type = "host";
            key = " PC";
            keyColor = "red";
          }
          {
            type = "cpu";
            key = "│ ├";
            showPeCoreCount = true;
            keyColor = "red";
          }
          {
            type = "gpu";
            key = "│ ├󰢮";
            keyColor = "red";
          }
          {
            type = "memory";
            key = "│ ├";
            keyColor = "red";
          }
          {
            type = "disk";
            key = "│ └";
            keyColor = "red";
            format = "{1} / {2} - {9}";
            showExternal = true;
            showHidden = true;
            showSubvolumes = true;
            showUnknown = true;
            showReadOnly = true;
            percent = {
              type = 11;
            };
          }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
            outputColor = "yellow";
          }
          "break"

          # ── Software ─────────────────────────────────────────
          {
            type = "custom";
            format = "┌──────────────────────Software──────────────────────┐";
            outputColor = "yellow";
          }
          {
            type = "os";
            key = "󱄅 OS";
            keyColor = "green";
          }
          {
            type = "kernel";
            key = "│ ├ ";
            keyColor = "green";
          }
          {
            type = "packages";
            key = "│ ├ ";
            keyColor = "green";
            format = "{} (nix)";
          }
          {
            type = "terminal";
            key = "│ ├ ";
            keyColor = "green";
          }
          {
            type = "shell";
            key = "└ └ ";
            keyColor = "green";
          }
          "break"
          {
            type = "de";
            key = " DE";
            keyColor = "blue";
          }
          {
            type = "wm";
            key = "│ ├";
            keyColor = "blue";
          }
          {
            type = "wmtheme";
            key = "│ ├󰉼";
            keyColor = "blue";
          }
          {
            type = "font";
            key = "│ ├ ";
            keyColor = "blue";
          }
          {
            type = "cursor";
            key = "│ ├󰆿";
            keyColor = "blue";
          }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
            outputColor = "yellow";
          }
          "break"

          # ── Network ─────────────────────────────────────────
          {
            type = "custom";
            format = "┌──────────────────────Network───────────────────────┐";
            outputColor = "yellow";
          }
          {
            type = "publicip";
            key = "│ ├󰩟 Pub IP";
            keyColor = "blue";
            format = "{1} - {2}";
          }
          {
            type = "localip";
            key = "│ ├󰈀 Loc IP";
            keyColor = "blue";
            format = "{1} - {3}";
            showMac = true;
          }
          # {
          #   type = "dns";
          #   key = "│ ├󰇖 DNS";
          #   keyColor = "blue";
          # }
          {
            type = "wifi";
            key = "│ ├󰖩 Wi-Fi";
            keyColor = "blue";
            format = "{4} - {7} - {13} GHz - {6} - {10}";
          }
          {
            type = "bluetooth";
            key = "│ ├󰂯 BT Dev";
            keyColor = "blue";
            format = "{1} - {4}";
          }
          {
            type = "bluetoothradio";
            key = "│ └󰂱 BT Ver";
            keyColor = "blue";
            format = "{5}";
          }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
            outputColor = "yellow";
          }
          "break"

          # ── Miscellaneous ────────────────────────────────────
          {
            type = "custom";
            format = "┌───────────────────Miscellaneous────────────────────┐";
            outputColor = "yellow";
          }
          {
            type = "uptime";
            key = "  Uptime";
            keyColor = "magenta";
          }
          {
            type = "media";
            key = "  Music";
            keyColor = "magenta";
            format = "{1} - {4}";
          }
          {
            type = "datetime";
            key = "  Date and Time";
            keyColor = "magenta";
            format = "{3}/{11}/{1} - {14}:{18} {22}";
          }
          {
            type = "custom";
            format = "  A star can only truly be seen in the darkness...";
            outputColor = "cyan";
          }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
            outputColor = "yellow";
          }
          "break"

          # ── Weather ─────────────────────────────────────────
          # {
          #   type = "custom";
          #   format = "┌──────────────────────Weather───────────────────────┐";
          #   outputColor = "yellow";
          # }
          # {
          #   type = "weather";
          #   key = "│  Weather";
          #   keyColor = "cyan";
          # }
          # {
          #   type = "custom";
          #   format = "└────────────────────────────────────────────────────┘";
          #   outputColor = "yellow";
          # }
          # "break"

          {
            type = "colors";
            paddingLeft = 20;
            symbol = "circle";
          }
          "break"
        ];
      };
    };
  };
}
