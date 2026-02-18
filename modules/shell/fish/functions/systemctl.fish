function systemctl --wraps="systemctl"
    if contains -- --user $argv
        command systemctl $argv
    else
        sudo systemctl $argv
    end
end
