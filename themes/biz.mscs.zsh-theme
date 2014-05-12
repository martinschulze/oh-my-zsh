# Based on gnzh theme

# load some modules
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst

# make some aliases for the colours: (coud use normal escap.seq's too)
for color in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$fg[${(L)color}]%}'
done
eval PR_NO_COLOR="%{$terminfo[sgr0]%}"
eval PR_BOLD="%{$terminfo[bold]%}"

function precmd {

# Check the UID
if [[ $UID -ge 1000 ]]; then # normal user
  eval PR_USER_COLOR='${PR_GREEN}'
  eval PR_USER_OP='${PR_GREEN}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_NO_COLOR➤ $PR_NO_COLOR'
elif [[ $UID -eq 0 ]]; then # root
  eval PR_USER_COLOR='${PR_RED}'
  eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_RED➤ $PR_NO_COLOR'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
  eval PR_HOST_COLOR='${PR_YELLOW}' #SSH
else
  eval PR_HOST_COLOR='${PR_GREEN}' # no SSH
fi

local return_code="%(?..%{$PR_RED%}%? ↵%{$PR_NO_COLOR%})"

local user_host='${PR_USER}${PR_CYAN}@${PR_HOST}'
local current_dir='%{$PR_BOLD$PR_BLACK%}[ %~ ]%{$PR_NO_COLOR%}'

local git_branch='$(git_prompt_info)%{$PR_NO_COLOR%}'

#Change HERE
local time="%D{[ %I:%M:%S ]--}"

#Line Array
local -a infoline

infoline+=( "╭─" )
infoline+=( "${PR_USER_COLOR}%n${PR_CYAN}@${PR_NO_COLOR}" )
infoline+=( "${PR_HOST_COLOR}%M${PR_NO_COLOR}" )
infoline+=( " $(git_prompt_info)%{$PR_NO_COLOR%}%{$PR_BOLD$PR_BLACK%}$(git_prompt_short_sha)$(git_prompt_status)$(git_remote_status)" )
infoline+=( "%{$PR_BOLD$PR_BLACK%}[%{$PR_NO_COLOR%} %D{%H:%M:%S} %{$PR_BOLD$PR_BLACK%}]%{$PR_NO_COLOR%}" )

local i_width
i_width=${(S)infoline//\%\{*\%\}}
i_width=${#${(%)i_width}}

local i_filler
i_filler=$(( $COLUMNS - $i_width ))

local filler
eval filler="%{$PR_BOLD$PR_BLACK%}${(l:${i_filler}::-:)}${PR_NO_COLOR}"

infoline[4]=( "${infoline[4]} ${filler} " )

#PROMPT="${user_host} ${current_dir} ${rvm_ruby} ${git_branch}$PR_PROMPT "
#PROMPT="╭─${user_host} ${git_branch} 
PROMPT="${(j::)infoline}
╰─ ${current_dir} $PR_PROMPT "
RPROMPT="${time}"
RPS1="${return_code}"
}

#ZSH_THEME_GIT_PROMPT_PREFIX="%{$PR_YELLOW%}‹"
#ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$PR_NO_COLOR%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$PR_BOLD$PR_BLACK%} ---[git: "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$PR_BOLD$PR_BLACK%} ]--- "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}" # Ⓓ
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}" # Ⓞ

ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}+" # ⓣ
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[yellow]%}*" # ⓐ ⑃
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%}~"  # ⓜ ⑁
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖" # ⓧ ⑂
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➜" # ⓡ ⑄
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}✂" # ⓤ ⑊
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="behind: "
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="ahead: "
ZSH_THEME_GIT_PROMPT_FILLER=" "
ZSH_THEME_GIT_PROMPT_PRESTATUS="%{$PR_BOLD$PR_BLACK%} [ "
ZSH_THEME_GIT_PROMPT_POSTSTATUS="%{$PR_BOLD$PR_BLACK%} ]"
