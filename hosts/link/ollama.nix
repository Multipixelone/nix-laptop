_: {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    # loadModels = ["deepseek-r1:7b-qwen-distill-q4_K_MA"];
  };
}
