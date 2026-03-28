# function input_devices
#     set -l is_enabled $argv[1]
#     echo "Setting input devices to: $is_enabled"
#     hyprctl keyword "device[at-translated-set-2-keyboard]:enabled" $is_enabled
#     hyprctl keyword "device[syna7db5:01-06cb:cd41-touchpad]:enabled" $is_enabled
# end

function input_devices
    set -l is_enabled $argv[1]
    # Niri doesn't use 'true/false' for enabling/disabling in the same way.
    # We use 'niri msg action' to interact with the compositor.
    
    echo "Setting input devices to: $is_enabled"

    # For Niri, you usually toggle specific flags or use a specialized tool 
    # since niri msg doesn't have a direct "device-enabled" toggle for specific IDs yet.
    # A common workaround is toggling the 'events' of the device:
    
    if test "$is_enabled" = "false"
        niri msg action disable-touchpad # If you have a bind for this
        # Or more accurately, use the following for specific devices:
        niri msg action set-device-disabled "at-translated-set-2-keyboard" true
        niri msg action set-device-disabled "syna7db5:01-06cb:cd41-touchpad" true
    else
        niri msg action set-device-disabled "at-translated-set-2-keyboard" false
        niri msg action set-device-disabled "syna7db5:01-06cb:cd41-touchpad" false
    end
end
