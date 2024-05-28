{...}: {
  theme = {
    wallpaper = let
      url = "https://drive.usercontent.google.com/download?id=1OrRpU17DU78sIh--SNOVI6sl4BxE06Zi";
      sha256 = "14nh77xn8x58693y2na5askm6612xqbll2kr6237y8pjr1jc24xp";
      ext = "png";
    in
      builtins.fetchurl {
        name = "wallpaper-${sha256}.${ext}";
        inherit url sha256;
      };
    side-wallpaper = let
      url = "https://blusky.s3.us-west-2.amazonaws.com/SU_SKY.PNG";
      sha256 = "05jbbil1zk8pj09y52yhmn5b2np2fqnd4jwx49zw1h7pfyr7zsc8";
      ext = "png";
    in
      builtins.fetchurl {
        name = "wallpaper-${sha256}.${ext}";
        inherit url sha256;
      };
  };
}
