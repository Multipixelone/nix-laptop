function dev --wraps='nix develop'
    set nix (type -P nix)
    $nix develop --command fish
end
