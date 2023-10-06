# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
#[[ -f ~/scripts/colorSchemeAliens.sh ]] && ~/scripts/colorSchemeAliens.sh
#Source
[[ -f ~/.alias ]] && source ~/.alias || echo "Error sourcing alias file."
source /usr/share/git/git-prompt.sh
#============================================
#		Env Variables
#============================================

export APPS_JSON='[
  {
    "url": "https://github.com/frappe/erpnext",
    "branch": "version-14"
  },
  {
    "url": "https://github.com/frappe/waba_integration",
    "branch": "main"
  }
]'
export APPS_JSON_BASE64=$(echo ${APPS_JSON} | base64 -w 0)

export _JAVA_AWT_WM_NONREPARENTING=1
export SUCKLESS="$HOME/suckless"
export POLYBAR="$HOME/personal/confs/polybar"
export TERMINAL="/usr/local/bin/st"
export TESSDATA_PREFIX="/usr/share/tessdata/"
#Colors
export LESS='-R --use-color -Dd+r$Du+b'
export PASSWORD_STORE_CLIP_TIME=240
export EDITOR=/usr/bin/nvim
export FZF_DEFAULT_OPTS="
--exact
--border sharp
--margin=1
--height=25
--color='16,fg:1,preview-fg:4,border:1'
--preview '([[ -f {} ]] && (cat -n {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
"


export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .password-store  --exclude .git --exclude .gitignore --exclude node_modules --exclude .npm'

#============================================
#		Paths
#============================================
PATH=$PATH:${HOME}/.config/coc/extensions/coc-clangd-data/install/*/clangd*
PATH=$PATH:${HOME}/.cargo/bin
PATH="${PATH}:${HOME}/.local/bin/"
PATH=$PATH:/usr/local/go/bin
PATH="$PATH:${HOME}/go/bin"

PATH="$PATH:${HOME}/personal/programs/flutter/bin"

PATH="$PATH:/home/ghostuser/Android/Sdk/tools/bin"


PATH="$PATH:${HOME}/.local/share/nvim/mason/bin"

if [ -f /bin/nnn ];then
 export NNN_PLUG='v:imgview;p:preview-tui'
 export NNN_FCOLORS="0404040000000600010F0F02"
 export NNN_FIFO=/tmp/nnn.fifo
else 
   echo "missing package=nnn"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

bind -x '"\C-t":`__fzf_cd__`'

#============================================
#		TTY
#============================================
#!/bin/sh
if [ "$TERM" = "linux" ]; then
/bin/echo -e "
\e]P0101010
  \e]P17c7c7c
  \e]P28e8e8e
  \e]P3a0a0a0
  \e]P4686868
  \e]P5747474
  \e]P6868686
  \e]P7b9b9b9
  \e]P8525252
  \e]P97c7c7c
  \e]PA8e8e8e
  \e]PBa0a0a0
  \e]PC686868
  \e]PD747474
  \e]PE868686
  \e]PFf7f7f7
  "
  # get rid of artifacts
  clear
fi




#============================================
#		PS1
#============================================
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d ' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		color=1
		NC="\[\e[m\]]"
		echo -n " "
		for i in $(echo $BRANCH | sed -e 's/\(.\)/\1\n/g'); do
			color=$((color-1))
			branch="\033[01;38;5;${color}m${i}"
			echo -en "${branch}"
		done
		STAT=`parse_git_dirty`
		echo -n "${STAT}"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

directory="\w"
git="\[\e[31m\]\`parse_git_branch\`\[\e[m\]"
prompt="\[\033[01;38;5;8m\]>\[\033[01;38;5;9m\]>\[\033[01;38;5;10m\]> \[\033[01;38;5;15m\]"

PS1="\n\[[\033[01;38;5;014m\]󰘧\e[0m] $directory$git\n$prompt"


