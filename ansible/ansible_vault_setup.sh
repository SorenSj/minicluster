#!/bin/bash
# https://ansible-navigator.readthedocs.io/en/latest/faq/#how-can-i-use-a-vault-password-with-ansible-navigator

if [[ $EUID -eq 0 ]]; then
    VPF_PATH="/root/.vault_password"
else
    VPF_PATH="$HOME/.vault_password"
fi

if [[ "$1" == "--remove-password" ]]; then
    echo "Removing .vault_password file..."
    rm -f "$VPF_PATH"
    echo "Removing symbolic links to the .vault_password file..."
    find . -type l -name '.vault_password' -exec rm {} +
    if [[ -z ${ANSIBLE_VAULT_PASSWORD_FILE+x} ]]; then
        echo "The ANSIBLE_VAULT_PASSWORD_FILE environment variable is not set. Skipping variable removal."
    else
        echo "Removing ANSIBLE_VAULT_PASSWORD_FILE environment variable..."
        unset ANSIBLE_VAULT_PASSWORD_FILE
        sed -i '/ANSIBLE_VAULT_PASSWORD_FILE/d' ~/.bashrc
    fi
    echo "Done. Please source your 'source ~/.bashrc' file to remove the ANSIBLE_VAULT_PASSWORD_FILE environment variable."
    exit 0
fi

if [[ ! -f "$VPF_PATH" ]]; then
    read -s -p "Enter the password: " password
    echo
    echo "Creating .vault_password file..."
    echo "${password}" > "$VPF_PATH"
    chmod 600 "$VPF_PATH"
    echo "Linking the password file to the current working directory..."
    ln -sf "$VPF_PATH" .
    echo "Setting the ANSIBLE_VAULT_PASSWORD_FILE environment variable..."
    echo "export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password" >> ~/.bashrc
    echo "Done. Please source your 'source ~/.bashrc' file to load the ANSIBLE_VAULT_PASSWORD_FILE environment variable."
    echo "Done."
    exit 0
fi 

if [[ -f "$VPF_PATH" ]]; then
    echo "The .vault_password file already exists. Skipping password setup."
    if [[ -z ${ANSIBLE_VAULT_PASSWORD_FILE+x} ]]; then
        echo "The ANSIBLE_VAULT_PASSWORD_FILE environment variable is not set. Please source your 'source ~/.bashrc' file to load the variable."
    else
        echo "The ANSIBLE_VAULT_PASSWORD_FILE environment variable is already set. Skipping variable setup."
    fi
    if [[ ! -L ".vault_password" ]]; then
        echo "Linking the password file to the current directory..."
        ln "$VPF_PATH" .
    fi
    exit 0
fi

if [[ -f ".vault_password" ]]; then
    echo "The .vault_password file already exists in the current directory. Linking to the password file in the home directory..."
    ln "$VPF_PATH" .vault_password
    echo "Setting the ANSIBLE_VAULT_PASSWORD_FILE environment variable..."
    echo "export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password" >> ~/.bashrc
    echo "Done. Please source your 'source ~/.bashrc' file to load the ANSIBLE_VAULT_PASSWORD_FILE environment variable."
    echo "Done."
fi



