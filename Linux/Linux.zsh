
# TODO(Drew): Do I need that gpg signing stuff?

# We are going to use starship for a prompt since it's fast and powerful
if ! command -v starship &> /dev/null; then
  curl -sS https://starship.rs/install.sh | sh
fi



# Make sublime text the core editor and make a better shortcut
if [[ -x /usr/bin/subl ]]; then
  export EDITOR=(subl -w)
  alias st="subl"
fi




# Quick way to boot into the UEFI
function reboot_uefi() {
  systemctl reboot --firmware-setup
}
