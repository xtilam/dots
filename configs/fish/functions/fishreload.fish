function fishreload
    clear
    echo "Close fish [pid:$fish_pid]! Reloading..."
    exec fish 
end
