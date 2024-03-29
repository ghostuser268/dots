# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[[ -f ~/scripts/colorSchemeAliens.sh ]] && ~/scripts/colorSchemeAliens.sh

#Source
[[ -f ~/.alias ]] && source ~/.alias || echo "Error sourcing alias file."
source /usr/share/git/git-prompt.sh


#============================================
#		Env Variables
#============================================
export SUCKLESS="$HOME/suckless"
export POLYBAR="$HOME/confs/polybar"
#Colors
export LESS='-R --use-color -Dd+r$Du+b'
export PASSWORD_STORE_CLIP_TIME=240
export EDITOR=/usr/local/bin/nvim
export FZF_DEFAULT_OPTS="
--exact
--border sharp 
--margin=1 
--height=25 
--color='16,fg:1,preview-fg:4,border:1'
--preview '([[ -f {} ]] && (cat -n {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .password-store  --exclude .git --exclude .gitignore'

#============================================
#		Paths
#============================================
PATH=$PATH:${HOME}/.config/coc/extensions/coc-clangd-data/install/*/clangd*
PATH=$PATH:${HOME}/.cargo/bin
PATH="${PATH}:${HOME}/.local/bin/"
PATH=$PATH:/usr/local/go/bin
PATH="$PATH:${HOME}/go/bin"

#Fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

bind -x '"\C-t":`__fzf_cd__`'

#============================================
#		TTY
#============================================
if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P0353535
  \e]P1744b40
  \e]P26d6137
  \e]P3765636
  \e]P461564b
  \e]P56b4a49
  \e]P6435861
  \e]P7b3b3b3
  \e]P85f5f5f
  \e]P9785850
  \e]PA6f6749
  \e]PB776049
  \e]PC696057
  \e]PD6f5a59
  \e]PE525f66
  \e]PFcdcdcd
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

name(){
	#c1=124
	#c2=160

	c1=1
	c2=9
	count=0
	for i in $( whoami | sed -e 's/\(.\)/\1\n/g' );do
		count=$((count+1))
		noColor="\e[0m"
		if [[ $(expr $count % 2) == 0 ]];then
			c1=$((c1+1))
			color="\[\033[01;38;5;${c1}m\]"
			echo -n "$color$i$noColor" 
		elif [[ $(expr $count % 2) != 0 ]];then 
			c2=$((c2+1))
			color="\[\033[01;38;5;${c2}m\]"
			echo -n "$color$i$noColor" 
		fi
	done
}

nameFinal="\[\033[01;38;5;9m(`name`\[\033[01;38;5;9m)"
directory="(\w)"
git="\[\e[31m\]\`parse_git_branch\`\[\e[m\]"
prompt="\[\033[01;38;5;8m\]>\[\033[01;38;5;9m\]>\[\033[01;38;5;10m\]> \[\033[01;38;5;15m\]"
PS1="$nameFinal $directory$git\n $prompt"


