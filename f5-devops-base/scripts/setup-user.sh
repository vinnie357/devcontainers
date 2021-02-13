#!/bin/bash

USERNAME=${1:-codespace}
SECURE_PATH_BASE=${2:-$PATH}

echo "Defaults secure_path=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin:${SECURE_PATH_BASE}\"" >> /etc/sudoers.d/securepath

# Install and setup fish
apt update && export DEBIAN_FRONTEND=noninteractive && apt -y install --no-install-recommends -yq fish
FISH_PROMPT="function fish_prompt\n    set_color green\n    echo -n (whoami)\n    set_color normal\n    echo -n \":\"\n    set_color blue\n    echo -n (pwd)\n    set_color normal\n    echo -n \"> \"\nend\n"
printf "$FISH_PROMPT" >> /etc/fish/conf.d/fish_prompt.fish
printf "if type code-insiders > /dev/null 2>&1 and ! type code > /dev/null 2>&1\n  alias code=code-insiders\nend" >> /etc/fish/conf.d/code_alias.fish

# Add user to a Docker group
sudo -u ${USERNAME} mkdir /home/${USERNAME}/.vsonline
groupadd -g 800 docker
usermod -a -G docker ${USERNAME}

# Set VS Code as user's git edtior
tee /tmp/scripts/git-ed.sh > /dev/null << EOF
#!/usr/bin/env bash
if [[ \$(which code-insiders) && ! \$(which code) ]]; then
  GIT_ED="code-insiders"
else
  GIT_ED="code"
fi
\$GIT_ED --wait \$@
EOF

sudo -u ${USERNAME} mkdir -p /home/${USERNAME}/.local/bin
install -o ${USERNAME} -g ${USERNAME} -m 755 /tmp/scripts/git-ed.sh /home/${USERNAME}/.local/bin/git-ed.sh
sudo -u ${USERNAME} git config --global core.editor "/home/${USERNAME}/.local/bin/git-ed.sh"
rm -f /tmp/scripts/git-ed.sh

# Add one time notice
tee -a /etc/bash.bashrc /etc/zsh/zshrc << EOF
/usr/local/share/docker-init.sh
if [ -t 1 ] && [ ! -f \$HOME/.config/vscode-dev-containers/first-run-notice ]; then
  echo -e "Welcome to f5-devops container using ubuntu 20.04, based on GitHub Codespaces"
  mkdir -p \$HOME/.config/vscode-dev-containers
  touch \$HOME/.config/vscode-dev-containers/first-run-notice
fi
EOF
