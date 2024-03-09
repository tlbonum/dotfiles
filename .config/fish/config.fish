set fish_greeting

set -U fish_escape_delay_ms 10
set -g EDITOR /opt/homebrew/bin/nvim
set -g fish_key_bindings fish_vi_key_bindings
# set -gx JAVA_HOME /var/lib/snapd/snap/android-studio/78/android-studio/jre
set -gx ANDROID_HOME /home/thomas/Android/Sdk
set -gx DEFAULT_REGION eu-central-1
set -gx NODE_OPTIONS --max_old_space_size=16384
set -gx FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT 1
set -gx APOLLO_ELV2_LICENSE accept

set fish_user_paths $PATH ~/.local/bin
set fish_user_paths $PATH /usr/local/bin
set fish_user_paths $PATH /opt/homebrew/bin
set fish_user_paths $PATH /usr/local/share/dotnet
set fish_user_paths $PATH ~/Android/Sdk/emulator
set fish_user_paths $PATH ~/Android/Sdk/tools
set fish_user_paths $PATH ~/Android/Sdk/tools/bin
set fish_user_paths $PATH ~/Android/Sdk/platform-tools
set fish_user_paths $PATH ~/.yarn/bin
set fish_user_paths $PATH ~/.cargo/bin
set fish_user_paths $PATH ~/bin
set fish_user_paths $PATH ~/.netlify/helper/bin
set fish_user_paths $PATH ~/.rover/bin
set fish_user_paths $PATH ~/go/bin
set fish_user_paths $PATH ~/.zig
set fish_user_paths $PATH /Applications/WezTerm.app/Contents/MacOS
# set fish_user_paths $PATH ~/.jenv/bin

set -gx PATH '/Users/thomas/.pyenv/shims' $PATH
set -gx PYENV_SHELL fish
set -g VIRTUALFISH_HOME ~/srcs

eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

source '/opt/homebrew/Cellar/pyenv/2.3.36/completions/pyenv.fish'
command pyenv rehash 2>/dev/null
function pyenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    source (pyenv "sh-$command" $argv|psub)
  case '*'
    command pyenv "$command" $argv
  end
end

# status --is-interactive; and pyenv virtualenv-init - | source
# status --is-interactive; and source (jenv init -|psub)

zoxide init fish | source
# oh-my-posh init fish | source

function starship_transient_prompt_func
  starship module character
end

# function starship_transient_rprompt_func
#   starship module time
# end

starship init fish | source
enable_transience

direnv hook fish | source
source_env ~/.env

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/thomas/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/home/thomas/Downloads/google-cloud-sdk/path.fish.inc'; end

