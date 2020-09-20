#!/bin/zsh

local PROJ_PATH=$(pwd)
local CONFIG_DIR="${HOME}/.config"
local UNAME=$(uname -s)

# NOTE(Drew): The method of copying these automatically would be esoteric
# Something like **/*.zsh(D), so it's done manually for clarity.
ln -sf "${PROJ_PATH}/Shared/zshrc.zsh" "${HOME}/.zshrc"
ln -sf "${PROJ_PATH}/Shared/aliases.zsh" "${HOME}/.aliases.zsh"
ln -sf "${PROJ_PATH}/${UNAME}/${UNAME}.zsh" "${HOME}/.${UNAME}.zsh"

if [[ -f /proc/version && "$(</proc/version)" == *microsoft* ]]; then
  ln -s "${PROJ_PATH}/Windows/WSL.zsh" "${HOME}/.WSL.zsh"
fi

ln -sf "${PROJ_PATH}/Shared/vimrc" "${HOME}/.vimrc"

mkdir -p "${CONFIG_DIR}"
ln -sf "${PROJ_PATH}/Shared/starship.toml" "${CONFIG_DIR}"




local ALLOWED_DESKTOPS=(
  "pop:GNOME"
)

if [[ ${UNAME} == "Linux" && "${ALLOWED_DESKTOPS[*]}" =~ "${XDG_CURRENT_DESKTOP}" ]]; then
  local AUTOSTART_DIR="${CONFIG_DIR}/autostart"

  ln -sf "${PROJ_PATH}/Linux/DesktopStartup/SynologyDrive.desktop" "${AUTOSTART_DIR}/"

  sudo ln -sf "${PROJ_PATH}/Linux/DesktopStartup/lightspeed-wakeup.sh" "/usr/bin/lightspeed-wakeup"
  sudo ln -sf "${PROJ_PATH}/Linux/DesktopStartup/lightspeed-wakeup.service" "/etc/systemd/system/"
  sudo systemctl enable lightspeed-wakeup
fi




echo "Linked configuration files."
