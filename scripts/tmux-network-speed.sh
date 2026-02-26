#!/bin/bash

# Default interval in seconds
INTERVAL=${1:-3}

# Detect operating system
OS="$(uname -s)"

# Get default network interface
get_interface() {
    case $OS in
        "Darwin") # macOS
            INTERFACE=$(netstat -rn | grep default | head -n1 | awk '{print $NF}')
            # Fallback to en0 if not found
            if [ -z "$INTERFACE" ]; then
                INTERFACE="en0"
            fi
            ;;
        "Linux")
            # Try using ip command
            if command -v ip >/dev/null 2>&1; then
                INTERFACE=$(ip route | grep default | cut -d' ' -f5)
            else
                # Fallback to common interfaces
                for iface in eth0 wlan0 ens33 enp0s3; do
                    if [ -e "/sys/class/net/$iface" ]; then
                        INTERFACE=$iface
                        break
                    fi
                done
            fi
            ;;
    esac

    if [ -z "$INTERFACE" ]; then
        echo "No interface"
        exit 1
    fi

    echo $INTERFACE
}

# Get interface traffic bytes
get_bytes() {
    INTERFACE=$1
    case $OS in
        "Darwin")
            netstat -I $INTERFACE -b | tail -n1 | awk '{print $7" "$10}'
            ;;
        "Linux")
            rx=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
            tx=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
            echo "$rx $tx"
            ;;
    esac
}

# Format speed for display
format_speed() {
    local bytes=$1
    if [ $bytes -gt 1048576 ]; then
        echo "$(echo "scale=1; $bytes/1048576" | bc)MB/s"
    elif [ $bytes -gt 1024 ]; then
        echo "$(echo "scale=1; $bytes/1024" | bc)KB/s"
    else
        echo "${bytes}B/s"
    fi
}

# Main logic
main() {
    INTERFACE=$(get_interface)

    # First read
    read R1 T1 <<< $(get_bytes $INTERFACE)
    sleep $INTERVAL
    # Second read
    read R2 T2 <<< $(get_bytes $INTERFACE)

    # Calculate speed
    RBPS=$(( $R2 - $R1 ))
    TBPS=$(( $T2 - $T1 ))

    # Ensure non-negative values
    [ $RBPS -lt 0 ] && RBPS=0
    [ $TBPS -lt 0 ] && TBPS=0

    # Format output
    RX=$(format_speed $RBPS)
    TX=$(format_speed $TBPS)

    echo "↓$RX ↑$TX"
}

main
