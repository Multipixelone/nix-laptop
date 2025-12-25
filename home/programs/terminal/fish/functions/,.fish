function ,
    if test (count $argv) -lt 1
        echo "Usage: , <name>"
        return
    end
    nix-locate --at-root --whole-name /bin/$argv[1]
end
