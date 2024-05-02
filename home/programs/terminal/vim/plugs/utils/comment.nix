{
  plugins.comment = {
    enable = true;
  };
  plugins.todo-comments = {
    enable = true;
    signs = true;
    signPriority = 8;

    keywords = {
      FIX = {
        icon = " ";
        color = "error";
        alt = ["FIXME" "BUG" "FIXIT" "ISSUE"];
        signs = false;
      };
      TODO = {
        icon = " ";
        color = "info";
      };
      HACK = {
        icon = " ";
        color = "warning";
      };
      WARN = {
        icon = " ";
        color = "warning";
        alt = ["WARNING" "XXX"];
      };
      PERF = {
        icon = " ";
        alt = ["OPTIM" "PERFORMANCE" "OPTIMIZE"];
      };
      NOTE = {
        icon = " ";
        color = "hint";
        alt = ["INFO"];
      };
      TEST = {
        icon = "⏲ ";
        color = "test";
        alt = ["TESTING" "PASSED" "FAILED"];
      };
    };

    guiStyle = {
      fg = "NONE";
      bg = "BOLD";
    };

    mergeKeywords = true;

    highlight = {
      multiline = true;
      multilinePattern = "^.";
      multilineContext = 10;
      before = "";
      keyword = "wide";
      after = "fg";
      pattern = ''.*<(KEYWORDS)\s*:'';
      commentsOnly = true;
      maxLineLen = 400;
      exclude = [];
    };

    colors = {
      error = ["DiagnosticError" "ErrorMsg" "#DC2626"];
      warning = ["DiagnosticWarn" "WarningMsg" "#FBBF24"];
      info = ["DiagnosticInfo" "#2563EB"];
      hint = ["DiagnosticHint" "#10B981"];
      default = ["Identifier" "#7C3AED"];
      test = ["Identifier" "#FF00FF"];
    };

    search = {
      command = "rg";
      args = [
        "--color=never"
        "--no-heading"
        "--with-filename"
        "--line-number"
        "--column"
      ];
      pattern = ''\b(KEYWORDS):'';
    };
  };
}
