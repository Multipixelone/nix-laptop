{
  configurations.nixos.link.module =
    { pkgs, ... }:
    {
      services.ollama = {
        enable = false;
        package = pkgs.ollama-rocm;
        loadModels = [
          "deepseek-r1:7b-qwen-distill-q4_K_MA"
          # "llama2-uncensored"
        ];
      };
    };
}
