# This file is normally read by interactive shells only.
# Here is the place to define your aliases, functions and
# other interactive features like your prompt.

# Execution sequence of files:
# /etc/profile
# ~/.bash_profile
# ~/.bashrc
# ~/.bash_login
# ~/.profile
# ~/.bash_logout

# Pseudocode explaining execution order:

# execute /etc/profile
# IF ~/.bash_profile exists THEN
#     execute ~/.bash_profile
# ELSE
#     IF ~/.bash_login exist THEN
#         execute ~/.bash_login
#     ELSE
#         IF ~/.profile exist THEN
#             execute ~/.profile
#         END IF
#     END IF
# END IF

# On logout:

# IF ~/.bash_logout exists THEN
#     execute ~/.bash_logout
# END IF

# While launching a non-login interactive shell, following is the sequence of execution:

# IF ~/.bashrc exists THEN
#     execute ~/.bashrc
# END IF

USERNAME=$(whoami)
UIOBRUKER="torjuskd"

# Bare utfør hvis logget på UiO-bruker
if [ $(whoami) = "torjuskd" ]; then
    #Last global bashrc-fil hvis logget på uio
    source /local/lib/setupfiles/bashrc

    #Noen linjer for å linke opp pakker/filer
    export PATH=~larstvei/local/bin/:$PATH
    export PKG_CONFIG_PATH=/uio/hume/student-u81/larstvei/local/lib/pkgconfig
    export LD_LIBRARY_PATH=/uio/hume/student-u81/larstvei/local/lib

    #Noen uio-aliaser
    alias emacsnewest='/snacks/bin/emacs-newest'
    alias emacslatest='emacsnewest'
    alias emacs-newest='emacsnewest'
    alias emacs-latest='emacsnewest'
    alias notepad='/snacks/bin/notepad'
    alias ordbanken='/snacks/bin/ordbanken'
    alias uke='/snacks/bin/uke'
    alias wine='/snacks/bin/wine'
    alias user='/snacks/bin/user'
    alias dropbox='/snacks/bin/dropbox'
    alias ncal='/snacks/bin/ncal'
fi

# Her kan du definere egne alias'er og sette bash-spesifikke variable.

#fin kommando for ssh + laste in bashrc-fil :)
alias sshuio='ssh -YC torjuskd@login.ifi.uio.no; source ~/.bashrc'
alias sshuiobruker='ssh -YC '$UIOBRUKER'@login.ifi.uio.no; source ~/.bashrc'
alias age='~torgeiou/age fs'
alias sql='psql -h dbpg-ifi-kurs -U torjuskd'
alias filmsql='psql -h dbpg-ifi-kurs -U torjuskd -d fdb'
alias la='ls -la'
alias ll='ls -l'
alias ls='ls --color=auto'
#Vise bare skjulte filer
alias l.='ls -d .* --color=auto'
## get rid of command not found ##
alias cd..='cd ..'
alias cd.='cd .'
alias setbackground='fbsetbg -a'
## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
#Start calculator with math-support
alias bc='bc -l'
#Generate sha1 digest
alias sha1='openssl sha1'
#Lag overmapper om nødvendig (med -verbose)
alias mkdirparent='mkdir -pv'
#Gjør mount printe i leselig format
alias mount='mount |column -t'
# handy short cuts #
alias h='history'
alias j='jobs -l'
alias firefoxy='firefox &'
alias emax='emacs &'
alias allesklar='clear'
alias klar='clear'
alias cler='clear'
alias clar='clear'

#logout command
alias logout_attempt='dbus-send --session --type=method_call --print-reply --dest=org.gnome.SessionManager /org/gnome/SessionManager org.gnome.SessionManager.Logout uint32:1'

# Disk usage
alias df='df -H'
alias du='du -ch'

#logg ut
alias gtfo='gnome-session-save --logout'

#Reload bash
alias reloadbash='source ~/.bashrc'

#Vi commands
#alias vi=vim
alias svi='sudo vi'
alias vis='vim "+set si"'
alias edit='vim'

#Mulige ping modifikasjoner
# Stop after sending count ECHO_REQUEST packets #
#alias ping='ping -c 5'
# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'

#Use netstat command to quickly list all TCP/UDP port on the server
alias ports='netstat -tulanp'

## CURL commands
# get web server headers #
alias header='curl -I'
# find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'


##Safety nets
# do not delete / or prompt if deleting more than 3 files at a time #
alias rm='rm -I --preserve-root'
# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'


## play video files in a current directory ##
# playavi or vlc
alias playavi='mplayer *.avi'
alias vlc='vlc *.avi'
# play all music files from the current directory #
alias playwave='for i in *.wav; do mplayer "$i"; done'
alias playogg='for i in *.ogg; do mplayer "$i"; done'
alias playmp3='for i in *.mp3; do mplayer "$i"; done'
# play files from nas devices #
alias nplaywave='for i in /nas/multimedia/wave/*.wav; do mplayer "$i"; done'
alias nplayogg='for i in /nas/multimedia/ogg/*.ogg; do mplayer "$i"; done'
alias nplaymp3='for i in /nas/multimedia/mp3/*.mp3; do mplayer "$i"; done'
# shuffle mp3/ogg etc by default #
alias music='mplayer --shuffle *'

##Finne hardware info
## pass options to free ##
alias meminfo='free -m -l -t'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

## Get server cpu info ##
alias cpuinfo='lscpu'

## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##

## get GPU ram on desktop / laptop##
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

## this one saved by butt so many times ##
# Resume getting a partially downloaded file
alias wget='wget -c'

## Wake on Lan - replace mac with your actual server mac address
#alias wakeupnas01='/usr/bin/wakeonlan 00:11:32:11:15:FC'

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Search for a package (ubuntu)
alias searchfor='apt-cache search' #(followed by package name)

#Kompilering av latex 'on the fly'
alias latexcomp='latexmk -pdf -pvc --view=none' #+ filename

#Har hatt litt varierende resultater med disse to linjene:
#burde funket? men funker kanskje ikke alltid? Sikkert gammelt.
setxkbmap -option "ctrl:nocaps"
#Vi prøver følgende for å remappe caps til ctrl - funker som en drøm! bra for emacs.
setxkbmap -option "caps:ctrl_modifier"

#SCP - funker ikke helt, bør skrives om en vakker dag.
alias downloadscp='scp torjuskd@login.ifi.uio.no:' #(fulgt av remote/host/file local/folder) (eg: ~/.emacs ~/.emacs)
