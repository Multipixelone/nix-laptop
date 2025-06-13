function agenix
    pushd $NH_FLAKE
    command agenix --identity $HOME/.ssh/agenix $argv
    popd
end
