# Don't ask for confirmations
#assume_yes = true

# Disable specific steps - same options as the command line flag
disable = ["firmware", "pip3"]

# Ignore failures for these steps
#ignore_failures = ["powershell"]

# Run specific steps - same options as the command line flag
#only = ["system", "emacs"]

# Do not ask to retry failed steps (default: false)
#no_retry = true

# Run inside tmux
#run_in_tmux = true

# List of remote machines with Topgrade installed on them
#remote_topgrades = ["toothless", "pi", "parnas"]

# Arguments to pass SSH when upgrading remote systems
#ssh_arguments = "-o ConnectTimeout=2"

# Path to Topgrade executable on remote machines
#remote_topgrade_path = ".cargo/bin/topgrade"

# Arguments to pass tmux when pulling Repositories
#tmux_arguments = "-S /var/tmux.sock"

# Do not set the terminal title
#set_title = false

# Display the time in step titles
# display_time = true

# Cleanup temporary or old files
#cleanup = true

[git]
#max_concurrency = 5
# Additional git repositories to pull
#repos = [
#    "~/src/*/",
#    "~/.config/something"
#]

# Don't pull the predefined git repos
#pull_predefined = false

# Arguments to pass Git when pulling Repositories
#arguments = "--rebase --autostash"

[composer]
#self_update = true

# Commands to run before anything
[pre_commands]
#"Emacs Snapshot" = "rm -rf ~/.emacs.d/elpa.bak && cp -rl ~/.emacs.d/elpa ~/.emacs.d/elpa.bak"

# Custom commands
[commands]
#"Python Environment" = "~/dev/.env/bin/pip install -i https://pypi.python.org/simple -U --upgrade-strategy eager jupyter"
#"sysyadm" = "sudo yadm --yadm-dir /etc/yadm --yadm-data /etc/yadm/data pull"

[brew]
#greedy_cask = true

[linux]
# Arch Package Manager to use. Allowed values: autodetect, trizen, paru, yay, pikaur, pacman.
#arch_package_manager = "pacman"
# Arguments to pass yay (or paru) when updating packages
#yay_arguments = "--nodevel"
#show_arch_news = true
#trizen_arguments = "--devel"
#pikaur_arguments = ""
#enable_tlmgr = true
#emerge_sync_flags = "-q"
#emerge_update_flags = "-uDNa --with-bdeps=y world"
#redhat_distro_sync = false
#rpm_ostree = false

[windows]
# Manually select Windows updates
#accept_all_updates = false
#open_remotes_in_new_terminal = true

# Causes Topgrade to rename itself during the run to allow package managers
# to upgrade it. Use this only if you installed Topgrade by using a package
# manager such as Scoop to Cargo
#self_rename = true

[npm]
# Use sudo if the NPM directory isn't owned by the current user
#use_sudo = true

[firmware]
# Offer to update firmware; if false just check for and display available updates
#upgrade = true

[flatpak]
# Use sudo for updating the system-wide installation
#use_sudo = true
