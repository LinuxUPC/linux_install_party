#!/usr/bin/env bash

# ============================================================
# Configuration
# ============================================================

VERBOSITY=1
SKIP_FLASHING=0

# Colors
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    GREY='\033[0;90m'
    RESET='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
    GREY=''
    BOLD=''
    RESET=''
fi

# ============================================================
# Logging
# ============================================================

log() {
    local level="$1"
    shift

    case "$level" in
        # ALWAYS (VERBOSITY=0) -q
        error) 
            echo -e "[${RED}${BOLD}!${RESET}] ${BOLD}ERROR${RESET}: $*" >&2
            ;;

        # Normal mode (VERBOSiTY=1) 
        milestone)
            [[ "$VERBOSITY" -ge 1 ]] && echo -e "[${GREEN}=${RESET}] ${BOLD}$*${RESET}"
            ;;
        success) 
            [[ "$VERBOSITY" -ge 1 ]] && echo -e "[${GREEN}+${RESET}] ${BOLD}Success:${RESET} $*"
            ;;

        # Verbose mode (VERBOSITY=2) -v
        step)
            [[ "$VERBOSITY" -ge 2 ]] && echo -e "[${BOLD}o${RESET}] $*"
            ;;
        completion)
            [[ "$VERBOSITY" -ge 2 ]] && echo -e "[${GREEN}+${RESET}] $*"
            ;;
        warning)
            [[ "$VERBOSITY" -ge 2 ]] && echo -e "[${YELLOW}%${RESET}] Warning: $*"
            ;;

        # Debug mode (VERBOSITY=3) -vv
        debug)
            [[ "$VERBOSITY" -ge 3 ]] && echo -e "[${GREY}#${RESET}] $*"
            ;;
    esac
}

usage() {
    echo -e "${BOLD}Usage:${RESET} $0 [OPTIONS]"
    echo 
    echo -e "${BOLD}Options:${RESET}"
    echo -e "  -i, --iso PATH       Path to the Linux ISO"
    echo -e "  -o, --output DEVICE  Target device (e.g. /dev/sda)"
    echo -e "  -s, --skip           Skip flashing and only verify the USB"
    echo -e "  -v, --verbose        Increase verbosity (can be repeated)"
    echo -e "  -q, --quiet          Suppress non-essential output"
    echo -e "  -h, --help           Show this help message"
}

# ============================================================
# Functions
# ============================================================
cleanup() {
    echo
    echo -e "${YELLOW}Interrupted.${RESET} Stopping...${RESET}"
    exit 200
}

trap cleanup INT TERM

beep() {
    play -q -n synth 0.05 sine 800
}

alert() {
    local command_string="$*"

    "$@"
    local status="$?"

    log debug "Running with alert: $command_string"

    if [ "$status" -eq 0 ]; then
        if [[ "$VERBOSITY" -ge 1 ]]; then
            notify-send "FlashStation: Success" "$command_string"
            beep
        fi
    else
        if [[ "$VERBOSITY" -ge 1 ]]; then
            notify-send "FlashStation: Error $status" "$command_string"
            beep
        fi
    fi

    log debug "Status code: $status"
}

# ============================================================
# Argument parsing
# ============================================================

parse_args() {
    local parsed

    parsed=$(getopt \
        --options "i:o:svqh" \
        --longoptions "iso:,output:,skip,verbose,quiet,help" \
        --name "$0" \
        -- "$@"
    )

    if [[ $? -ne 0 ]]; then
        echo -e "${RED}ERROR:${RESET} Failed to parse command-line arguments."
        echo
        usage
        exit 1
    fi

    eval set -- "$parsed"

    while true; do
        case "$1" in
            -i|--iso)
                ISO="$2"
                shift 2
                ;;

            -o|--output)
                OF="$2"
                shift 2
                ;;

            -s|--skip)
                SKIP_FLASHING=1
                shift
                ;;

            -v|--verbose)
                ((VERBOSITY++))
                shift
                ;;

            -q|--quiet)
                QUIET=1
                shift
                ;;

            -h|--help)
                usage
                exit 0
                ;;

            --)
                shift
                break
                ;;

            *)
                echo -e "${RED}ERROR:${RESET} Unexpected argument: $1"
                exit 1
                ;;
        esac
    done

    # Reject positional arguments.
    if [[ $# -gt 0 ]]; then
        echo -e "${RED}ERROR:${RESET} Unexpected argument: $1"
        echo
        usage
        exit 1
    fi
}

parse_args "$@"

if [[ "$QUIET" -eq 1 ]];then
    VERBOSITY=0
fi

if [[ -z "${ISO:-}" ]]; then
    log error "No ISO was specified"
    usage
    exit 2

fi

if [[ -z "${OF:-}" ]]; then
    log error "No Device was specified"
    usage
    exit 3
fi



# ============================================================
# Dependencies
# ============================================================

DEPENDENCIES=(
    play
    notify-send
    lsblk
    stat
    sudo
    dd
    cmp
    blockdev
)

log step "Checking dependencies..."

for cmd in "${DEPENDENCIES[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
        log error "Required dependency '$cmd' is not installed."
        exit 4
    fi

    log debug "$cmd"
done

log completion "All dependencies are installed."

# ============================================================
# Sudo
# ============================================================

log step "Checking sudo access..."

if ! sudo -v; then
    log error "sudo authentication failed."
    exit 5
fi

log completion "Sudo access confirmed."


# ============================================================
# Validation
# ============================================================

if [[ ! -f "$ISO" ]]; then
    log error "ISO does not exist: $ISO"
    exit 6
fi

log completion "ISO exists: $ISO"

if [[ ! -b "$OF" ]]; then
    log error "$OF is not a block device"
    exit 7
fi

log completion "Target device exists: $OF"

# ============================================================
# Device information
# ============================================================

if [[ "$VERBOSITY" -ge 1 ]]; then
    verbose=""
    case "$VERBOSITY" in
        0) verbose="Quiet" ;;
        1) verbose="Normal" ;;
        2) verbose="Verbose" ;;
        *) verbose="Debug" ;;
    esac
    log milestone "Target Device:"
    lsblk -o NAME,SIZE,MODEL,TRAN,MOUNTPOINTS "$OF"
    echo
    log milestone "Summary:"
    echo -e "  ${BOLD}ISO:${RESET}                  $ISO"
    echo -e "  ${BOLD}Device:${RESET}               $OF"
    echo -e "  ${BOLD}Skipping flashing:${RESET}    $([[ "$SKIP_FLASHING" -eq 1 ]] && echo "Yes" || echo "No")"
    echo -e "  ${BOLD}Verbosity:${RESET}            $verbose ($VERBOSITY)"
    echo
    read -n 1 -s -r -p "$(echo -e "${YELLOW}Press any key to continue...${RESET}")"
    echo
fi

# ============================================================
# Capacity check
# ============================================================

ISO_SIZE=$(stat -c%s "$ISO")
DEVICE_SIZE=$(sudo blockdev --getsize64 "$OF")

log debug "ISO size:    $ISO_SIZE bytes"
log debug "Device size: $DEVICE_SIZE bytes"

if [[ "$ISO_SIZE" -gt "$DEVICE_SIZE" ]]; then
    log error "ISO is larger than the target device"
    exit 8
fi

log completion "ISO fits on target device"

# ============================================================
# Flash
# ============================================================

if [[ "$SKIP_FLASHING" -eq 0 ]]; then
    log milestone "Flashing '$OF' with '$(basename "$ISO")'"
    log warning "Do not remove device now"
    
    case "$VERBOSITY" in
        0) DD_STATUS="none" ;;
        1) DD_STATUS="noxfer" ;;
        *) DD_STATUS="progress" ;;
    esac

    log debug "DD_STATUS=$DD_STATUS"
    if alert sudo dd \
        if="$ISO" \
        of="$OF" \
        bs=4M \
        status="$DD_STATUS" \
        conv=fsync
    then
        log success "${BOLD}Flashing completed successfully.${RESET}"
    else
        log error "Flashing failed."
        exit 9
    fi

    sudo sync
else
    log milestone "Skipping flashing."
fi

# ============================================================
# Verification
# ============================================================

log milestone "${CYAN}${BOLD}Verifying integrity...${RESET}"
log warning "Removing device might lead to incorrect output"

if alert sudo cmp -n "$ISO_SIZE" "$ISO" "$OF"; then
    log success "USB has the correct bits!"
else
    log error "THERE IS AN ERROR WITH THIS USB"
    exit 10
fi

log milestone "${BOLD}DONE!${RESET} You may now remove your USB"
