{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  # wrap secret into gh cli
  gh-wrapped = pkgs.writeShellScriptBin "gh" ''
    export GITHUB_TOKEN=$(cat ${config.age.secrets."gh".path})
    ${lib.getExe pkgs.gh} "$@"
  '';
  # wrap secret into tgpt
  tgpt-wrapped = pkgs.writeShellScriptBin "tgpt" ''
    export AI_PROVIDER="openai"
    export OPENAI_MODEL="gpt-4o-mini" # use 4o-mini TODO: use bash variable expansion to set this value if unset.
    export OPENAI_API_KEY=$(cat ${config.age.secrets."openai".path})
    ${lib.getExe pkgs.tgpt} "$@"
  '';
  # wrap secret into todoist
  todoist-wrapped = pkgs.writeShellScriptBin "td" ''
    export TODOIST_TOKEN=$(cat ${config.age.secrets."todoist".path})
    ${lib.getExe pkgs.todoist} "$@"
  '';
  # wrap client id and secret into gcalcli
  gcalcli-wrapped = pkgs.writeShellScriptBin "gcalcli" ''
    ${lib.getExe pkgs.gcalcli} \
    --client-id=$(cat ${config.age.secrets."gcalclient".path}) \
    --client-secret=$(cat ${config.age.secrets."gcalsecret".path}) \
    "$@"
  '';
in
{
  age = {
    secrets = {
      "gh" = {
        file = "${inputs.secrets}/github/ghcli.age";
      };
      "openai" = {
        file = "${inputs.secrets}/openai.age";
      };
      "todoist" = {
        file = "${inputs.secrets}/todoist.age";
      };
      "gcalclient" = {
        file = "${inputs.secrets}/gcal/client.age";
      };
      "gcalsecret" = {
        file = "${inputs.secrets}/gcal/secret.age";
      };
    };
  };
  home.packages = [
    tgpt-wrapped
    todoist-wrapped
    gcalcli-wrapped
  ];
  programs.gh.package = gh-wrapped;
}
