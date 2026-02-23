{
  perSystem =
    { inputs', ... }:
    {
      treefmt.programs = {
        nixf-diagnose = {
          enable = true;
          ignore = [
            "sema-unused-def-lambda-noarg-formal"
            "sema-unused-def-lambda-witharg-arg"
            "sema-unused-def-lambda-witharg-formal"
          ];
        };

        statix = {
          enable = true;
          package = inputs'.statix.packages.default;
        };
      };
    };
}
