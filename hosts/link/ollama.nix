_: {
  services.ollama = {
    enable = false;
    acceleration = "rocm";
    loadModels = [
      "deepseek-r1:7b-qwen-distill-q4_K_MA"
      # "llama2-uncensored"
    ];
  };
}
