# Author  : Bhishan Poudel
# Date    : Mar 18, 2016
# File    : bash profile
# source  : source ~/.bash_profile   # for mac
##==============================================================================
# Important
##==============================================================================
source ~/.git-completion.bash
source ~/.bash_command_timer.sh


##==============================================================================
# Latest added
##==============================================================================
alias jnbpd='jupyter-notebook
~/Dropbox/Learn/Python/znotebooks/pandas_notebook/pandas_eg.ipynb'
alias jnba='jupyter-notebook ~/Temp/mynotebooks/a.ipynb'
alias jl='jupyter lab'
alias ohere='open -a /Applications/Utilities/Terminal.app .'
alias cdkp='clear; cd ~/Google\ Drive/BP_KP; ls'
alias myenv='source activate myenv'
alias vscode='/Applications/Visual\ Studio\ Code.app/Contents/MacOS/Electron'

# For macpro host is Macpro.local use another PS1 given below.
alias sb='source ~/.bash_profile'
#alias rm="echo Use 'del', or the full path i.e. '/bin/rm'"

function eml() { python ~/bin/send_email_mac.py; }
function notify() { bash ~/bin/notify.sh; }
function rmt () { mv  $@ ~/.Trash/; }
function del () { mv  $@ ~/.Trash/; }
function grepb() {
    clear;
    egrep -ni $1 ~/.bash_profile;
    printf "\nNumber of lines: "
    grep -c $@ ~/.bash_profile;
    printf "PWD: $PWD\n";
    }
function grepp() {
    clear;
    egrep -ni $@;
    printf "\nNumber of lines: "
    grep -c $@;
    printf "PWD: $PWD\n";
    }
function obash() {
    open ~/Dropbox/Recent/bash/bash_profile_macpro.sh
    open ~/Dropbox/Recent/bash/bash_profile_pisces.sh
    open ~/Dropbox/Recent/bash/bash_profile_simplici.sh
    }
function qjout() { # quickview jedisim outputs
    echo ""
    echo "Hit spacebar to go to next window"
    echo ""
    for f in $(ls ~/Dropbox/jout/jout*.txt); do qlmanage -p $f; done
    for f in $(ls ~/Dropbox/jout/jout*.txt); do killall qlmanage; done
    }

#
# open the current folder in Finder's tab
# NOTE: cmd ctrl o (default opens selected folder in new tab)
function oft() {

  local folder_name=$1
  if ! [[ -d $1 ]]; then
    # it is a file, get the enclosing folder
    folder_name="$(dirname "$1")"
  fi

  # if no arguments are given, we use the current folder
  # 'pwd -P' will resolve the symbolic link (Finder always resolves the symbolic link)
  oft_absolute_path=$(cd ${folder_name:-.}; pwd -P )

  # execute the applescirpt
  osascript 2>/dev/null <<EOF
    on currentFinderPath()
        tell application "Finder"
            try
                set finder_path to POSIX path of (target of window 1 as alias)
            on error
                set finder_path to ""
            end try
        end tell
    end currentFinderPath

    # Finder returns a path with trailing slash
    # But PWD doesn't have one, so we add one for it
    set new_tab_path to "$oft_absolute_path" & "/"

    tell application "Finder"
        activate

        if not (exists window 1) then
            make new Finder window
        end if

        set finder_path to my currentFinderPath()

        if finder_path = "" then
            # the finder's window doesn't contain any folders
            set target of front window to (new_tab_path as POSIX file)
            return
        end if
    end tell

    if new_tab_path = finder_path then
        # the finder's tab is already there
        return
    end if

    # get the last path component name e.g., /usr/local/ -> local
    # we need it to compare with the name of radio buttons (the name of tabs)
    set ASTID to AppleScript's text item delimiters
    set AppleScript's text item delimiters to {"/"}
    # assume there is a trailing slash at the end of path
    set last_folder_name to text item -2 of new_tab_path
    set AppleScript's text item delimiters to ASTID

    # iterate through all radio buttons to check if the tab has been opened or not
    # if it is not working for the future versions of Finder
    # iteration all UI components by 'entire contents of window 1'
    # see [Finding Control and Menu Items for use in AppleScript User Interface Scripting](http://hints.macworld.com/article.php?story=20111208191312748)
    tell application "System Events"
        tell process "Finder"
            set radio_buttons to radio buttons of window 1
            set button_num to length of radio_buttons
            repeat with i from 1 to button_num
                try
                    set button_i to item i in radio_buttons

                    if not title of button_i = last_folder_name then
                        # the tab name doesn't match
                        # simulated 'continue'
                        error 0
                    end if

                    # click the button will change the Finder's target path
                    click button_i
                    set finder_path to my currentFinderPath()

                    if new_tab_path = finder_path then
                        # the finder's tab is already there
                        return
                    end if
                    # if we switch tab, the buttons will become invalid
                    # so we have to retrieve them again
                    set radio_buttons to radio buttons of window 1
                end try
            end repeat
        end tell
    end tell

    # the folder is not opened yet
    # open a new tab in Finder
    tell application "System Events" to keystroke "t" using command down

    # set the Finder's path
    tell application "Finder"
        set target of front window to (new_tab_path as POSIX file)
    end tell

    return
EOF
  # clear the tempory veriable
  unset oft_absolute_path
}


# usage: msg hello kashi
function msgk() {

  local folder_name=$1
  if ! [[ -d $1 ]]; then
    # it is a file, get the enclosing folder
    folder_name="$(dirname "$1")"
  fi

  # if no arguments are given, we use the current folder
  # 'pwd -P' will resolve the symbolic link (Finder always resolves the symbolic link)
  oft_absolute_path=$(cd ${folder_name:-.}; pwd -P )

  # execute the applescirpt
  osascript 2>/dev/null <<EOF
  tell application "Messages"

      set targetBuddy to "+12343528979"
      set targetService to id of 1st service whose service type = iMessage
        set textMessage to "$@"
        set theBuddy to buddy targetBuddy of service id targetService
        send textMessage to theBuddy
  end tell
EOF

  # clear the tempory veriable
  unset oft_absolute_path
}


# Usage: email the program is finished.
function emailme() {
  # execute the applescirpt
  osascript 2>/dev/null <<EOF
  tell application "Mail"

      set theSubject to "Hello" -- the subject
      set theContent to "$@" -- the content
      set theAddress to "bhishanpdl@gmail.com" -- the receiver
      set msg to make new outgoing message with properties {subject: theSubject, content: theContent, visible:true}

      tell msg to make new to recipient at end of every to recipient with properties {address:theAddress}

      send msg
  end tell
EOF
}

# Usage: email the program is finished.
function emlk() {
  # execute the applescirpt
  osascript 2>/dev/null <<EOF
  tell application "Mail"

      set theSubject to "Hello" -- the subject
      set theContent to "$@" -- the content
      set theAddress to "ks173214@ohio.edu" -- the receiver
      set msg to make new outgoing message with properties {subject: theSubject, content: theContent, visible:true}

      tell msg to make new to recipient at end of every to recipient with properties {address:theAddress}

      send msg
  end tell
EOF
}

##==============================
# Mac
##==============================
alias qlf='qlmanage -p "$1" > /dev/null 2>&1' # Quick Look File


# function notify() {
  # d=$(date +%Y-%m-%d\ %H\:%M)
  # /usr/bin/osascript -e "display notification \"$*\" with title \"Date: $d\" ";}


# scp from cori to current directory.
# Usage: scpn2h  cori.txt  # Note that there is ~/cori.txt in cori machine.
function scpn2h(){
  # Usage: scpn2h cori.txt # There is ~/cori.txt in cori machine.
  # NOTE:  When we ssh to nersc, run the command: mysetup
  arg1="bhishan@cori.nersc.gov:~/$1"
  echo $arg1
  echo "Loggin into remote computer Cori..."
  scp -r  $arg1 .

  echo ""
  echo ""
  echo "Successfully Copied files!"
  echo "You have following contens in PWD: $(pwd)"
  ls
}


# scp from here to nersc
# Usage: scpn mydir mydir
function scph2n(){
  # Usage: scpn mydir mydir
  # NOTE:  When we ssh to nersc, run the command: mysetup
  arg2="bhishan@cori.nersc.gov:~/$2"
  echo $arg1
  echo "Loggin into remote computer Cori..."
  scp -r  $1 $arg2

  echo ""
  echo ""
  echo "Successfully Copied files!"
}


##==============================
# Variables for paths
##==============================
drp=~/Dropbox
dn=~/Downloads
rsh=~/Research
jedi=~/jedisim/jedisim
sim=~/jedisim/jedisim/simdatabase
tips=~/OneDrive/Bhishan/Tips/
mygal=~/Research/galfit_usage
pisces=132.235.24.92
simplici=132.235.24.63
nhome=bhishan@cori.nersc.gov:/global/homes/b/bhishan


##==============================
# Temporary Aliases
##==============================







##==============================================================================
# Diary
##==============================================================================
alias come="echo `date '+%Y-%b-%d:  Entry:  %I:%M:%S %p'` >> ~/Dropbox/Diary/office_log.txt"
alias go="echo `date '+%Y-%b-%d:  Exit :  %I:%M:%S %p'` >> ~/Dropbox/Diary/office_log.txt"



##================================================
# My Website: http://www.phy.ohiou.edu/~poudel/
##================================================
# 2. ssh to helios and mkdir bpweb
# 1. download website from pbPrg and cd to it.
# 3. Then copy all the contents to newly created folder
# 4. inside helios: cd public_html; rm *
# 5. mv bpweb/* public_html/
alias cpweb='scp -r  * poudel@helios.phy.ohiou.edu:~/bpweb/'









##==============================
# Research Aliases
# scp -r myfolder bhishan@cori.nersc.gov:~/
##==============================
alias sshn='ssh -Y bhishan@cori.nersc.gov' # year
alias cori='ssh -Y bhishan@cori.nersc.gov' # year
alias edison='ssh -Y bhishan@edison.nersc.gov' # year
alias sshh='ssh poudel@helios.phy.ohiou.edu'
alias nersc='ssh -Y bhishan@cori.nersc.gov' # year
# hack day dec 2017
alias lsst='source activate lsst&&source eups-setups.sh&&setup lsst_distrib'
alias lsst2='source ~/bin/lsst_dm.sh'
alias opliu='open /Users/poudel/Zotero/storage/I7LTISBZ/liu.pdf'
alias vir='vi run_jedisim.py'






##==============================
# Mac Aliases
##==============================
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias rmds='rm -rf .DS_Store */.DS_Store */*/.DS_Store'

# set screenshot location
defaults write com.apple.screencapture location ~/Dropbox/Screenshots
# killall SystemUIServer





##==============================
# List
##==============================
alias ls='ls -GFS'
alias la='ls -Al'       # show hidden files
alias lsz='ls -lSr'     # sort by size
alias lu='ls -lur'	    # sort by access time
alias lr='ls -lR'       # recursive ls
alias lt='ls -ltr'      # sort by date
alias lm='ls -al |more' # pipe through 'more'
alias ll='ls -la'
alias l.='ls -d -G .*'
alias lshidden='ls -ap | grep -v / | egrep "^\." '




##==============================
# Change Directory
##==============================
alias cdgd='clear; cd ~/Google\ Drive; ls'
alias cdd='clear; cd ~/Dropbox; ls'
alias cdn='clear; cd ~/Downloads; ls'
alias cdk='clear; cd ~/Desktop;'
alias cdr='clear; cd ~/Research; ls'
alias cdg='cd ~/github; ls'
alias cdgit='clear; cd ~/github; ls'
alias cdtmp='clear; cd ~/Temp; ls'
alias cdo='clear; cd ~/OneDrive; ls'
alias cdj='clear; cd ~/Research/a4_jedisim/jedisim; ls'
alias cdscr='cd ~/Dropbox/Screenshots; ls'
alias cdh='cd ~/Dropbox/Help; ls'
alias cdv='cd ~/.vim/; ls'
alias cdpy='clear; cd ~/Dropbox/Learn/Python; ls'

alias .2='cd ../'
alias .3='cd ../../'
alias .4='cd ../../../'
alias .5='cd ../../../../'
alias .6='cd ../../../../../'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'



##==============================
# Copy and Backup
##==============================
alias cp='cp -r'
alias cpb='cp -v ~/.bash_profile ~/Dropbox/Recent/bash/bash_profile_macpro.sh'
alias cpv='cp -v ~/.vimrc ~/Dropbox/Recent/vim/vimrc_macpro.vim'
alias cpconfa='cp -v ~/.Atom/snippets.cson ~/Dropbox/Recent/atom/atom_macpro_snippets.cson; cp -v ~/.Atom/init.coffee  ~/Dropbox/Recent/atom/atom_macpro_init.coffee; cp -v ~/.Atom/keymap.cson  ~/Dropbox/Recent/atom/atom_macpro_keymap.cson; cp -v ~/.Atom/custom_entries.json  ~/Dropbox/Recent/atom/atom_macpro_custom_entries.json;cp -v ~/.Atom/config.cson ~/Dropbox/Recent/atom/atom_macpro_config.cson'
alias cpj='cp -v ~/Research/a4_jedisim/jedisim/jedimaster.py ~/Dropbox/Recent/jedisim/jedimaster_macpro.py'
alias cpjedi='cp -v ~/jedisim/jedisim/jedimaster.py ~/Dropbox/Recent/jedisim/jedimaster_macpro.py'
alias cpr='cp -v ~/Research/a4_jedisim/jedisim/run_jedimaster.py ~/Dropbox/Recent/jedisim/run_jedimaster_macpro.py'
alias cprun='cp -v ~/jedisim/jedisim/run_jedimaster.py ~/Dropbox/Recent/jedisim/run_jedimaster_macpro.py'
alias cppath='echo $PWD | pbcopy '
alias cdpath='cd $(pbpaste)'
alias cpw='echo $PWD | pbcopy'
alias ppw='cd $(pbpaste)'
alias cpsp='clear; cp ~/Applications/custom.css ~/Dropbox/Recent/sphinx/custom_pro.css;
cp ~/Applications/edit_sphinx_conf.py ~/Dropbox/Recent/sphinx/edit_sphinx_conf_pro.py'



##==============================
## Websites
##==============================
alias bpgit="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://github.com/bhishanpdl'"
alias wkt="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://wakatime.com/dashboard'"
alias ben="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://www.benty-fields.com/'"
alias ovr="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://www.overleaf.com/users/sign_in'"
alias catmail="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://cas.sso.ohio.edu/login?service=https%3A%2F%2Fshibboleth.ohio.edu%2Fsimplesaml%2Fmodule.php%2Fcas%2Flinkback.php%3FstateID%3D_a4f2da3fa9aa43d28eb551bb1ed504bc71aa5d1c9d%253Ahttps%253A%252F%252Fshibboleth.ohio.edu%252Fsimplesaml%252Fsaml2%252Fidp%252FSSOService.php%253Fspentityid%253Dhttp%25253A%25252F%25252Fsts.ohio.edu%25252Fadfs%25252Fservices%25252Ftrust%2526cookieTime%253D1520297466%2526RelayState%253D14baf998-54ef-4534-bc2e-f2d480419539'"
alias gio="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://github.com/bhishanpdl/bhishanpdl.github.io'"
alias mygit="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://github.com/bhishanpdl'"
alias jokes="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://xkcd.com/'"
alias mylatex="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://tohtml.com/TeX/'"
alias library="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://alice.library.ohiou.edu/patroninfo~S7/1493840/items'"
alias mactips="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://github.com/bhishanpdl/MacTips'"
alias nersc="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://my.nersc.gov/'"
alias ocr="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://www.onlineocr.net/'"
alias oucu="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://www.oucu.org/home/home'"
alias benty="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://www.benty-fields.com/'"
alias papers="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://www.benty-fields.com/'"
alias prg="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://bpprg.github.io/'"
alias regex="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'http://regviz.org/'"
alias regex="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'http://regviz.org/'"
alias slac="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://confluence.slac.stanford.edu/login.action?os_destination=%2Fpages%2Fviewpage.action%3FpageId%3D220431140%26src%3Dmail%26src.mail.timestamp%3D1500058440042%26src.mail.notification%3Dcom.atlassian.confluence.plugins.confluence-content-notifications-plugin%253Apage-edited-notification%26src.mail.recipient%3D06cf45475ab5ed20015b2032e7d2003c%26src.mail.action%3Dview&permissionViolation=true'"
alias stack="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://stackoverflow.com/users/5200329/bhishan-poudel?tab=questions'"
alias student="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://cas.sso.ohio.edu/login?service=https%3A%2F%2Fsis.ohio.edu%2Fpsp%2Fcsprd%2FEMPLOYEE%2FHRMS%2Fc%2FSA_LEARNER_SERVICES.SSS_STUDENT_CENTER.GBL'"
alias waka="open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome 'https://wakatime.com/login'"
ggl(){
    search=""
    echo "Googling: $@"
    for term in $@; do
        search="$search%20$term"
    done
    open -a open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome  "http://www.google.com/search?q=$search"
}
yt(){
    search=""
    echo "Googling: $@"
    for term in $@; do
        search="$search%20$term"
    done
    open -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome  "http://www.youtube.com/search?q=$search"
}


##==============================
## Open Programs
##==============================
alias openb='echo "Please use opb command instead of openb."'
alias oepn='open'
alias opena='open ~/Temp/a.py'
alias opb='open ~/.bash_profile'
alias openb='open ~/.bash_profile'
alias openenv='open ~/.vimrc'
alias openball='open ~/.bash_profile; open ~/Dropbox/Recent/bash/bash_profile*'
alias catv='pygmentize -f terminal256 -O  style=trac -g ~/.vimrc'
alias vib='vim ~/.bash_profile'
# alias catb='pygmentize ~/.bash_profile'
alias catb='pygmentize -g -O style=trac,linenos=1 ~/.bash_profile'
# alias opencron='open ~/bin/mycrontab.sh'
alias openb2='open ~/Dropbox/Recent/bashrc_mac.txt; open ~/Dropbox/Recent/bashrc_linux.txt &'
alias openmd='open ~/Temp/a.md'
alias opentxt='open ~/Temp/a.txt'
alias openpy='open ~/Temp/a.py'
alias openc='open ~/Temp/a.c'
alias opend='open ../docs/build/html/index.html'
alias openjs='open /Users/poudel/anaconda/share/jupyter/nbextensions/snippets/snippets.json'
alias .='open .'
alias via='vi a.py'
alias vib='vi ~/.bash_profile'
alias vic='vi c.py'




##==============================
# ssh
##==============================
function sshp(){
echo "_______ _________ _______  _______  _______  _______ "
echo "(  ____ )\__   __/(  ____ \(  ____ \(  ____ \(  ____ \\"
echo "| (    )|   ) (   | (    \/| (    \/| (    \/| (    \/"
echo "| (____)|   | |   | (_____ | |      | (__    | (_____ "
echo "|  _____)   | |   (_____  )| |      |  __)   (_____  )"
echo "| (         | |         ) || |      | (            ) |"
echo "| )      ___) (___/\____) || (____/\| (____/\/\____) |"
echo "|/       \_______/\_______)(_______/(_______/\_______)"
ssh poudel@pisces.phy.ohiou.edu
}

function sshs {
cat <<EOF
    _______.  __   __    __ . .___ .    __       __       __   __
   /       | |  | |   \/   | |   _  \  |  |     |  |  /      ||  |
  |   (----| |  | |  \  /  | |  |_)  | |  |     |  | |  ,----'|  |
   \   \     |  | |  |\/|  | |   ___/  |  |     |  | |  |     |  |
.----)   |   |  | |  |  |  | |  |      |   ----.|  | |   ----.|  |
|_______/    |__| |__|  |__| | _|      |_______||__|  \______||__|
EOF
ssh poudel@simplici.phy.ohiou.edu
}

function sshn {
cat <<EOF
_
(_)
___ ___  _ __ _
/ __/ _ \| '__| |
| (_| (_) | |  | |
\___\___/|_|  |_|
EOF
ssh -Y bhishan@cori.nersc.gov
}





##==============================
# rsync
##==============================
alias rsync='rsync -azvu --progress '
alias rsync2='rsync -azvu --progress '


##==============================
# Python
##==============================
function py() {
    clear
    clear
    python $*
    /bin/rm -rf *.pyc
    /bin/rm -rf __pycache__
    /bin/rm -rf */__pycache__
    /bin/rm -rf */*.pyc
    }




##==============================
# Programs Short Names
##==============================
alias jnb='jupyter-notebook'
alias pya='clear; python3 a.py'
alias pyb='clear; python3 b.py'
alias pyo='clear; /usr/bin/python'
alias py2='clear; /Users/poudel/miniconda2/bin/python2.7'
alias py3='clear; /Users/poudel/miniconda3/bin/python3.6'
alias gf='clear; gfortran'
alias xg='xgterm &'
alias xgterm='xgterm &'
alias bc='bc -l'
alias pyg='pygmentize'
##==============================






##==============================================================================
# DMstack
##==============================================================================
# copy: read_src_fits.py yaml_create.py clusters_hdf5_simtxt.py
alias cpdm='clear; cp -v ~/Softwares/DMstack/*py . && ls'
alias sbdm='source ~/Softwares/DMstack/aa_dmstack_aliases.sh'
alias lsst='source activate lsst && source eups-setups.sh && setup lsst_distrib'
alias obs='cd ~/Softwares/obs_file && setup -k -r . && scons && cd -'

# cd example;  rm -rf input output && mkdir input output

alias map='mkdir -p input && echo "lsst.obs.file.FileMapper" > input/_mapper' # creates mapper


# ingest wcs_star_lsst_000.fits
function ingest () {
    # input: registry.sqlite3 and raw/trial00.fits
    ingestImages.py input/ $1 --mode link
}

alias crccd='echo "config.charImage.repair.cosmicray.nCrPixelMax=1000000" > processCcdConfig.py && ls'


# prccd wcs_star_lsst_000.fits
function prccd() {
	processCcd.py input/ --id filename=$1 --config isr.noise=5 --configfile processCcdConfig.py --clobber-config --output output
}


alias src='python read_src_fits.py && head src_fits.csv'
########## mass estimation from Clusters module ##########
alias yml='python yaml_create.py'
alias h5='python clusters_hdf5_simtxt.py'
alias zphot='clusters_zphot.py sim.yaml sim.hdf5' # Add zphot_ref  to sim.hdf5
alias mass='clusters_mass.py sim.yaml sim.hdf5'



##==============================
# Personnal Aliases
##==============================
alias sb='source ~/.bash_profile'
alias mkdir='mkdir -p'
alias rmr='/bin/rm -rv'
alias h='history'
alias j='jobs -l'
alias which='type -all'
alias path='echo -e ${PATH//:/\\n}'
alias print='/usr/bin/lp -o nobanner -d $LPDEST'   # Assumes LPDEST is defined
alias pjet='enscript -h -G -fCourier9 -d $LPDEST'  # Pretty-print using enscript
alias background='xv -root -quit -max -rmode 5'    # Put a picture in bkg
alias diary='open ~/Dropbox/Research_Diary/diary_2017.txt'
alias diary1='open ~/Dropbox/Research_Diary/diary_2016.txt'
alias path='echo -e ${PATH//:/\\n}'  # echo $(PATH) with new lines
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias vi='/opt/local/bin/vim'
alias lprc='vim -me -c ":syntax on" -c ":hardcopy" -c ":q"'
alias c='clear'
alias cls='clear; ls -GFS'
alias rmt='rmtrash' # NEVER alias rm to rmtrash, it will bite someday!
# pygmentize colors for cat
# Ref: https://github.com/nex3/pygments/tree/master/pygments/styles
# Good styles: trac,emacs, murphy(but it is bold)
#   trac is bluish and hard to read for json files.
#   for json good = emacs (trac is bluish and ugly)
alias pcat="pygmentize -f terminal256 -O style=trac -g" # native bad4 makefile, autumn red glaring for bash
alias cat="pygmentize -g -f terminal256 -O style=trac" # native bad4 makefile, autumn red glaring for bash
alias catj="pygmentize -g -f terminal256 -O style=emacs" # native bad4 makefile, autumn red glaring for bash
alias ncat="pygmentize -g -O style=trac,linenos=1"






##==============================
# wget   r = recursive l1=level-1 nd=no-directories-all-in-one
##==============================
# example: wpdf http://ciml.info
# -c resumes downloads from previous time.
alias wget='wget -c '
alias wpdf='wget -r l1 -nd -nc -A.pdf '





#=====================================
# vim
#====================================
alias viv='vim ~/.vimrc'







##==============================
# pdf manipulation
# pdfjoin a.pdf b.pdf     gives merged.pdf
# pdfjoin in1.pdf in2.pdf; mv merged.pdf output.pdf
# gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=merged.pdf
# gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged.pdf
##==============================
alias combine_pdf='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=merged.pdf'
alias pdfjoin='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=merged.pdf'







##==============================
# additional paths for MAC
##==============================
export PATH=$PATH:/Library/Frameworks/Python.framework/Versions/3.5/bin
export PATH=$PATH:/Users/poudel/Applications/Atom.app/Contents/Resources/app/apm/bin
export PATH=$PATH:/opt/local/bin
export PATH=$PATH:~/imcat/bin/OSX
export PATH=$PATH:~/imcat/bin/scripts
export PATH=$PATH:~/phosim
export PATH=$PATH:~/Applications
export PATH=$PATH:/Applications/SAOImage\ DS9.app/Contents/MacOS/
export PATH=$PATH:~/bin/

# added after conda sklearn error Nov 19, 2017
export PATH=$PATH:/Users/poudel/anaconda/lib/python3.6/site-packages/scipy/sparse/linalg/isolve/

# added for phosim-4.0
export PATH=$PATH:/Users/poudel/phosim-4.0/


##==============================
# Additional programs installed in MAC
##==============================
alias firefox="/Applications/Firefox.app/Contents/MacOS/firefox"
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias safari="/Applications/Safari.app/Contents/MacOS/Safari"
alias ds9='/Applications/SAOImage\ DS9.app/Contents/MacOS/ds9'
alias ds9m='ds9 -multiframe'









##==============================
# Path and Library for pcre (required for swig )
# swig is needed for C/C++ to python,java etc conversion
##==============================
LD_LIBRARY_PATH=/usr/local/lib:/usr/lib
export LD_LIBRARY_PATH







##==============================
# Sphinx documentation
##==============================
#
# Let source code = code/hello.py
#
# spq
# edit docs/source/conf.py file (uncomment imports, add path sys.path.append('../code'),
#                               (add napoleon, theme classic)
#
# cd docs; make html; cd -   # docs/build has now html and doctrees
# sphinx-apidoc -o docs/source code/ # Create automatic rst files
#
# (delete index.rst and rename module.rst to index.rst, edit if necessary.)
# /bin/rm docs/source/index.rst; mv docs/source/module.rst docs/source/index.rst
#
# cd docs; sphinx-build -b html source build/html; cd -
# open docs/build/html/index.html
#
# If you change anything, e.g. conf.py, files.rst, build again   spb
alias sprm='/bin/rm -rf  docs/build docs/html docs/Makefile docs/rst docs/source docs/pdf'
alias spo='open docs/html/index.html'

# command: spq
# outputs: docs
#
# docs has three things: Makefile source build
# build is empty
# source has _static _templates and conf.py, index.rst
function spq () { sphinx-quickstart -q -p "Bhishan's" -a "Bhishan Poudel" -v 1 -r 1 \
     --ext-autodoc --ext-doctest --ext-viewcode --ext-imgmath \
     --no-batchfile --sep docs;}




# Documentation using sphinx
# sp1 code/         (NOTE: keep last /)
# sp1 code/scipy/   (NOTE: keep last /)
function sp1 () {

    #1. Quickstart
    # Outputs: docs
    # docs has three things: Makefile source build
    # build is empty
    # source has _static _templates and conf.py, index.rst
    #
    # NOTE: --ext-napoleon gives error, but runs fine if added in conf.py
    sphinx-quickstart -q -p "Bhishan's" -a "Bhishan Poudel" -v 1 -r 1 \
     --ext-autodoc --ext-doctest --ext-viewcode --ext-imgmath \
     --no-batchfile --sep docs

    #2. Copy edit_conf file
    cp ~/Applications/edit_sphinx_conf.py edit_sphinx_conf.py

    #3. Edit conf.py file.
    # This will do following:
    # Copy edit_sphinx_conf.py at pwd where there are code and docs directories.
    # It will edit docs/source/conf.py
    #
    # Uncomment 3 lines of import modules
    # Add the source folder. e.g.  sys.path.append('../code')
    #
    # html_theme = 'classic'  # it was alabaster
    python3 edit_sphinx_conf.py; /bin/rm -rf edit_sphinx_conf.py

    #4. Create html folder (also creates doctrees).
    cd docs; make html; cd -

    #5. Copy custom.css file to rst/_static
    # cp ~/Applications/custom.css docs/source/_static/


    #6. Auto create rst files.
    # sphinx-apidoc -o docs/source src/
    sphinx-apidoc -o docs/source "${1%?}"

    #7. Remove the string 'module' from all rst files
    for f in docs/source/*.rst; do sed -ie '1s/module//' $f; done
    for f in docs/source/*.rste; do bin/rm $f; done


    #8. Delete source/index.rst and rename module to index
    # cat !$
    mv docs/source/modules.rst docs/source/index.rst

    #9. Add path to conf.py
    # path.append is relative to Makefile not conf.py
    # vi docs/source/conf.py  then, sys.path.append('../src/')
    awk -v n=23 -v s="sys.path.append('../${1%?}')" 'NR == n {print s} {print}' \
    docs/source/conf.py > docs/source/conf_new.py;
    rm docs/source/conf.py; mv docs/source/conf_new.py docs/source/conf.py

    #10 b. Add napoleon extension to conf.py (it did not worked adding above)
    # 'sphinx.ext.napoleon',
    # cd docs; make clean; make html; open build/html/index.html
    awk -v n=38 -v s="    'sphinx.ext.napoleon'," 'NR == n {print s} {print}' \
    docs/source/conf.py > docs/source/conf_new.py;
    bin/rm docs/source/conf.py; mv docs/source/conf_new.py docs/source/conf.py

    #11. Add Table of Contents to index.rst
    awk -v n=1 -v s=".. contents:: Table of Contents\n   :depth: 3\n\n" \
                    'NR == n {print s} {print}' \
                  docs/source/index.rst > docs/source/tmp; mv docs/source/tmp docs/source/index.rst

    #12. Add Sidebar to index.rst
    # Sidebar does not look very good, always follow standards.
    # awk -v n=1 -v s=".. sidebar:: ${1%?}\n\n   :Author: Bhishan Poudel\n   :Date: |today|\n   :Update: |today|\n\n" \
    #                 'NR == n {print s} {print}' \
    #               docs/source/index.rst > docs/source/tmp; mv docs/source/tmp docs/source/index.rst


    #13. Get index.html (pdf is very very bad.)
    cd docs; sphinx-build -b html source build/html; cd -


    #14. Delete pycache
    /bin/rm -rf "${1%?}"/__pycache__

    #15. Open html
    open docs/build/html/index.html
    }

# exactly same thing except open
# spml will use this.
# sp0/
function sp0 () {

    #1. Quickstart
    # Outputs: docs
    # docs has three things: Makefile source build
    # NOTE: --ext-napoleon gives error, but runs fine if added in conf.py
    sphinx-quickstart -q -p "Bhishan's" -a "Bhishan Poudel" -v 1 -r 1 \
     --ext-autodoc --ext-doctest --ext-viewcode --ext-imgmath \
     --no-batchfile --sep docs

    #2. Copy edit_conf file
    cp ~/Applications/edit_sphinx_conf.py edit_sphinx_conf.py

    #3. Edit conf.py file.
    python3 edit_sphinx_conf.py; /bin/rm -rf edit_sphinx_conf.py

    #4. Create html folder (also creates doctrees).
    cd docs; make html; cd -

    #5. Copy custom.css file to rst/_static
    cp ~/Applications/custom.css docs/source/_static/


    #6. Auto create rst files.
    # sphinx-apidoc -o docs/source src/
    sphinx-apidoc -o docs/source "${1%?}"

    #7. Remove the string 'module' from all rst files
    for f in docs/source/*.rst; do sed -ie '1s/module//' $f; done
    for f in docs/source/*.rste; do /bin/rm $f; done


    #8. Delete source/index.rst and rename module to index
    # cat !$
    mv docs/source/modules.rst docs/source/index.rst

    #9. Add path to conf.py
    # path.append is relative to Makefile not conf.py
    # vi docs/source/conf.py  then, sys.path.append('../src/')
    awk -v n=23 -v s="sys.path.append('../${1%?}')" 'NR == n {print s} {print}' \
    docs/source/conf.py > docs/source/conf_new.py;
    /bin/rm docs/source/conf.py; mv docs/source/conf_new.py docs/source/conf.py

    #10 b. Add napoleon extension to conf.py (it did not worked adding above)
    # 'sphinx.ext.napoleon',
    # cd docs; make clean; make html; open build/html/index.html
    awk -v n=38 -v s="    'sphinx.ext.napoleon'," 'NR == n {print s} {print}' \
    docs/source/conf.py > docs/source/conf_new.py;
    /bin/rm docs/source/conf.py; mv docs/source/conf_new.py docs/source/conf.py

    #11. Add Table of Contents to index.rst
    awk -v n=1 -v s=".. contents:: Table of Contents\n   :depth: 3\n\n" \
                    'NR == n {print s} {print}' \
                  docs/source/index.rst > docs/source/tmp; mv docs/source/tmp docs/source/index.rst

    #12. Add Sidebar to index.rst
    awk -v n=1 -v s=".. sidebar:: ${1%?}\n\n   :Author: Bhishan Poudel\n   :Date: date\n   :Update: |today|\n\n" \
                    'NR == n {print s} {print}' \
                  docs/source/index.rst > docs/source/tmp; mv docs/source/tmp docs/source/index.rst


    #13. Get index.html (pdf is very very bad.)
    cd docs; sphinx-build -b html source build/html; cd -


    #14. Delete pycache
    /bin/rm -rf "${1%?}"/__pycache__

    #15. Open html
    # open docs/build/html/index.html
    }





# Add another folder to previous scripts.
# Usage: spallf2 code/scikit/
function sp2 () {

    # create modules.rst and source_code.rst
    sphinx-apidoc -o docs/source "${1%?}"

    # add contents of modules to index and delete module
    echo "" >> docs/source/index.rst
    echo "" >> docs/source/index.rst
    cat docs/source/modules.rst >> docs/source/index.rst
    /bin/rm -rf docs/source/modules.rst

    # Remove the string 'module' from all rst files
    for f in docs/source/*.rst; do sed -ie '1s/module//' $f; done
    for f in docs/source/*.rste; do rm $f; done

    # add path to conf.py
    awk -v n=25 -v s="sys.path.append('../${1%?}')" 'NR == n {print s} {print}' docs/source/conf.py > docs/source/conf_new.py
    cp docs/source/conf_new.py docs/source/tmp.py
    /bin/rm -rf docs/source/conf.py; mv docs/source/conf_new.py docs/source/conf.py

    # build again
    cd docs; make clean; cd -
    cd docs; sphinx-build -b html source build/html; cd -

    # remove temp folder
    /bin/rm -rf "${1%?}"/__pycache__

    # open html
    # open docs/build/html/index.html
     }

## Build from REPO
function spb(){
    cd docs; make clean; cd -
    cd docs; sphinx-build -b html source build/html; cd -
    open docs/build/html/index.html
}


## run spallf without opening final index.html
function spml(){
  /bin/rm -rf docs
  spallf_no_open code/;
  cp rst/*.rst docs/source/
  spb
}

## sphinx for machine learning with extra folder
function spmle(){
  /bin/rm -rf docs
  spallf_no_open code/;
  cp rst/*.rst docs/source/
  spallf2 ExtraWork/
}

# special case to add scipy folder
function sp5(){
  /bin/rm -r docs
  spallf_no_open code/scipy/
  folder2=$1
  mkdir docs/source/$folder2
  sphinx-apidoc -o docs/source/$folder2 code/$folder2

  awk -v n=25 -v s="sys.path.append('../code/$folder2')" 'NR == n {print s} {print}' docs/source/conf.py > docs/source/conf_new.py
  /bin/rm -rf docs/source/conf.py; mv docs/source/conf_new.py docs/source/conf.py

  # Remove the string 'module' from all rst files
  for f in docs/source/$folder2/*.rst; do sed -ie '1s/module//' $f; done
  for f in docs/source/$folder2/*.rste; do rm $f; done

  echo "" >> docs/source/index.rst
  echo "" >> docs/source/index.rst
  cat docs/source/$folder2/modules.rst >> docs/source/index.rst
  /bin/rm docs/source/$folder2/modules.rst
  /bin/rm -rf "$1"/__pycache__
  open docs/source/scikit/softmaxExercise.rst


  # open docs/build/html/index.html
}

## sprstq  copies updated rst files and builds again
function sp4(){
    # copy rst files  (not index.rest file)
    cp rst/*.rst docs/source
    cd docs; make clean; cd -
    cd docs; sphinx-build -b html source build/html; cd -
    open docs/build/html/index.html
}


# sp_dir2 code/pytorch/
function sp3(){
  /bin/rm -rf docs
  spallf_no_open code/numpy/
  folder2=$(basename $1)  # basename of full path without /.
  mkdir docs/source/$folder2
  sphinx-apidoc -o docs/source/$folder2 code/$folder2

  awk -v n=24 -v s="sys.path.append('../code')" 'NR == n {print s} {print}' docs/source/conf.py > docs/source/conf_new.py
  awk -v n=25 -v s="sys.path.append('../code/$folder2')" 'NR == n {print s} {print}' docs/source/conf_new.py > docs/source/conf_new2.py
  /bin/rm -rf docs/source/conf.py docs/source/conf_new.py; mv docs/source/conf_new2.py docs/source/conf.py

  # Remove the string 'module' from all rst files
  for f in docs/source/$folder2/*.rst; do sed -ie '1s/module//' $f; done
  for f in docs/source/$folder2/*.rste; do rm $f; done

  echo "" >> docs/source/index.rst
  echo "" >> docs/source/index.rst
  cat docs/source/$folder2/modules.rst >> docs/source/index.rst
  /bin/rm docs/source/$folder2/modules.rst

  /bin/rm -rf "$folder2"/__pycache__

  cp rst/*.rst docs/source    # copy rst files except index.rest
  cp rst/*.rest docs/source   # copy index.rest

  mv docs/source/index.rst docs/source/index2.rst
  mv docs/source/index.rest docs/source/index.rst
  cat docs/source/index2.rst >> docs/source/index.rst
  /bin/rm docs/source/index2.rst


  open docs/source/index.rst  # add $folder2/  prefix to added folder

  open docs/source/$folder2/*.rst # .. automodule:: scikit.softmaxExercise
  echo ""
  echo ""
  echo "NOTE: Edit all rst files inside added directory docs/source/$folder2"
  echo "Example of edit."
  echo "pytorch.softmaxExercise"
  echo "=========================="
  echo ".. automodule:: pytorch.softmaxExercise"


  # Then build again:  spb_rstq

}




##==============================
## Aliases for git
# Ref: http://gitimmersion.com/lab_11.html
##==============================
# git add
alias gad='git add '
alias gau='git add --update'

# git branch
alias gbr='git branch'
alias gbra='git branch -a'

# git clone and commit
alias gcl='git clone'
# alias gcm='git commit -m '               # gc is ghostscript command
alias gcmm='git commit -m "updated"'     # gc is ghostscript command
alias gcmva='git commit -v -a'

# git checkout
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcot='git checkout -t'
alias gcotb='git checkout --track -b'
alias gco='git checkout '

# git diff
alias gdf='git diff'
alias gdm='git diff | /Applications/Geany.app/Contents/MacOS/geany'

#gitk
alias gtk='gitk --all&'

# git log
alias glog='git log --oneline --decorate'
alias glogp='git log --pretty=format:"%h %s" --graph'

# git pull
alias gpl='git pull'

# git push
alias gps='git push origin master'

# git status
#alias gs='git status '  # gs is ghostscript command
alias gst='git status'

# gitx
alias gx='gitx --all'


# git merge
alias gmg="git merge"

# comment
function gcm() {
  git commit -m '"$@"'
}

# github multiple accounts
function gitpdl() {
  ssh-add ~/.ssh/id_rsa
  git config --global user.user bhishanpdl
  git config --global user.email bhishantryphysics@gmail.com
}
function gitjedi() {
  ssh-add ~/.ssh/id_rsa_bpJedisim
  git config --global user.user bpJedisim
  git config --global user.email bhishanpdl3@gmail.com
}

# github add,commit,push fuction (type without quotes)
# Usage: gallf Changed the file Readme.
function gall () {
    echo "Example: gall uploaded galfit files oct26-2017."
    git add --all
    git commit -m "$*"
    git push origin master
}

# Usage gall1 hello.py changed number of galaxies.
function gall1 () {
    echo "Example: gall1 edited hello.py oct26-2017"
    git add $1
    git commit -m "$*"
    git push origin master
}

# Usage: git2 bpPrg practice
function git2 () {
    echo "Example: git2 bpPrg practice"
    echo "After this git add --all"
    echo "git push"
    echo "password for this account"
    git remote set-url origin https://$1@github.com/$1/$2.git
}

# Upload all the files to github
function upall () {
    cp *.txt /Users/poudel/github/Everything/
    cp *.py /Users/poudel/github/Everything/
    cp *.sh /Users/poudel/github/Everything/
    cp *.c /Users/poudel/github/Everything/
    cd /Users/poudel/github/Everything/
    git add --all
    git commit -m "`date +%Y-%b-%d`"
    git push origin master
    cd -
}

# Upload a given file to github
# Usage: upl hello.py
function upl () {
    cp $1 /Users/poudel/github/Everything/
    cd /Users/poudel/github/Everything/
    git add $1
    git commit -m "`date +%Y-%b-%d`"
    git push origin master
    cd -
}


# Git clone for bhishanpdl
# Usage: gclp git@github.com:bhishanpdl/practice.git
function gclp() {
  # Configure github
  ssh-add ~/.ssh/id_rsa
  git config --global user.user bhishanpdl
  git config --global user.email bhishantryphysics@gmail.com

  # Clone the repo and cd to it
  git clone $1
  link=git@github.com:bhishanpdl/$1.git
  base=$(echo $link| cut -d'/' -f 2) # part after /
  repo=${base%????} # remove last 4 letters (.git)
  cd $repo
  pwd
  ls
}
# Git clone for bhishanpdl
# Usage: gclp practice
# Note: practice is the name of repo in that account
function gclp() {
  # Configure github
  ssh-add ~/.ssh/id_rsa
  git config --global user.user bhishanpdl
  git config --global user.email bhishantryphysics@gmail.com

  # Clone the repo and cd to it
  git clone git@github.com:bhishanpdl/$1.git
  link=git@github.com:bhishanpdl/$1.git
  base=$(echo $link| cut -d'/' -f 2) # part after /
  repo=${base%????} # remove last 4 letters (.git)
  cd $repo
  pwd
  ls
}

# Git clone for bpJedisim
# Usage: gclj jedi_practice
function gclj() {
  # Configure github
  ssh-add ~/.ssh/id_rsa_bpJedisim
  git config --global user.user bpJedisim
  git config --global user.email bhishanpdl3@gmail.com

  # Clone the repo and cd to it
  git clone $1
  link=$1
  base=$(echo $link| cut -d'/' -f 2) # part after /
  repo=${base%????} # remvove last 4 letters (.git)
  cd $repo
  pwd
  ls
}
# Run fortran files with Accelerate compiler
# Example: gff hello.f90
#
function gff () {
    clear
    gfortran -Wall  $1 -L/System/Library/Frameworks/vecLib.framework  -framework Accelerate
    ./a.out
    /bin/rm -rf a.out
}


# Determine size of a file or total size of a directory
function fs() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh;
  else
    local arg=-sh;
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@";
  else
    du $arg .[^.]* ./*;
  fi;
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
  cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
function json() {
  if [ -t 0 ]; then # argument
    python -mjson.tool <<< "$*" | pygmentize -l javascript;
  else # pipe
    python -mjson.tool | pygmentize -l javascript;
  fi;
}

# UTF-8-encode a string of Unicode symbols
function escape() {
  printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
  # print a newline unless we’re piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

# `a` with no arguments opens the current directory in Atom Editor, otherwise
# opens the given location
function a() {
  if [ $# -eq 0 ]; then
    atom .;
  else
    atom "$@";
  fi;
}

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
function v() {
  if [ $# -eq 0 ]; then
    vim .;
  else
    vim "$@";
  fi;
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
  if [ $# -eq 0 ]; then
    open .;
  else
    open "$@";
  fi;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
  tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}


function mybash() {
  echo "cut -d ',' -f 2-3,5 employees.txt | column -s\",\" -t"
}


##==============================
## Always run these commands at startup
##==============================
crontab ~/mac_crontab/mycrontab.sh  # to check crontab -l
printf '\033c'
unset MAILCHECK


##==============================
# mac special
# mac finder is not working good
##==============================
alias kf='killall Finder'




##******************************************************************************
##******************************************************************************
##==============================
# Terminal Prompt color
##==============================
# attributes: 00=none, 01=bold, 04=underscore, 05=blink, 07=reverse, 08=concealed.
# foreground: 30=black, 31=red, 32=green, 33=yellow, 34=blue, 35=magenta, 36=cyan, 37=white.
# background: 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan

# foreground colors: 30-37 or 90-97 or  38;5;0 to 38;5;255
# background colors: 49=default, 40-47 or 100-107 or 48;5;0 to 48;5;255

# Color	Foreground	Background
# Black	    30	               40
# Red	    31	               41
# Green	    32	               42
# Yellow	33	               43
# Blue	    34	               44
# Magenta	35	               45
# Cyan	    36	               46
# White	    37	               47

#\d – Current date
#\t – Current time
#\h – Host name
#\# – Command number
#\u – User name
#\W – Current working directory (i.e: Desktop/)
#\w – Current working directory, full path (i.e: /Users/Admin/Desktop)
# \e[m  - reset colors

# yellow  blue
#PS1='\[\e[0;33m\]\u@\[\e[0;34m\]\W\[\e[0m\]\$ '
# poudel@two_component_fit$
#PS1='\[\e[0;34m\]\W\[\e[0m\]\$ '
#two_component_fit$
# PS1='\[\e[0;34m\]${HOSTNAME%%.*}:'
# BP: (in blue colors)
# In macpro hostname is BpMacpro.local
# To remvove .* we do %%.*


#PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '
#export PS1="\[\033[01;33m\][$USER@$HOSTNAME]\[\033[0;00m\] \[\033[01;32m\]\w\\$\[\033[0;00m\] "
#PS1='\n\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;34m\]\w\[\e[0m\]\$ '
#PS1='\n\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;34m\]\w\[\e[0m\]\$ '
#PS1='\n\[\e[0;35m\]\t::\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;34m\]\w\[\e[0m\]\$ '
#11:28:55::poudel@~/Research/galfit_usage/two_component_fit$

# BpMacpro.local@LastFolder    black and blue, and reset colors
# export PS1='\[\e[1;30m\]$(hostname)@\[\e[0;34m\]${PWD/*\//}:\e[0m'
# export PS1='\[\e[1;30m\]MacPro@\[\e[0;34m\]${PWD/*\//}:\e[0m'

# export ='\[\e[1;30m\]MacPro@\[\e[0;34m\]${PWD/*\//}:\e[0m'
# export PS1='\u@\[\e[0;34m\]\h:\[\e[0;31m\]\w\e[0m\n$ '
# export PS1='\u@\h:\w\$ '  # no colors

# added Apr 28, 2018
## Terminal Prompt Settings
orange=$(tput setaf 166);
yellow=$(tput setaf 228);
green=$(tput setaf 71);
white=$(tput setaf 15);
bold=$(tput bold);
reset=$(tput sgr0);



PS1="\[${bold}\]\n";
PS1+="[\@]\[${orange}\]  \u"; # username
PS1+="\[${white}\] at ";
PS1+="\[${yellow}\]\h"; # host
PS1+="\[${white}\] in ";
PS1+="\[${green}\]\w"; # Working directory
PS1+="\n";
PS1+="\[${white}\]\$ \[${reset}\]";
export PS1;


##==============================
## Files and directories colors
##==============================


## colored terminal example 2
#export CLICOLOR=1
#export LSCOLORS=GxFxCxDxBxegedabagaced  # best
#export LSCOLORS=ExFxBxDxCxegedabagacad


#The default is “exfxcxdxbxegedabagacad”, i.e. blue fore-
#ground and default background for regular directories,
#black foreground and red background for setuid executa-
#bles, etc.


## Aug 10, 2016
## For terminal colors
## Ref: http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
# default colors:
# 0  ex  : directory  dx=yellow cx = green
# 1  fx  # symbolic link
# 2  cx  # socket
# 3  dx  # pipe
# 4  bx  # executables  # bx = brown
# 5  eg  # block special
# 6  ed  # character special
# 7  ab  # executable with setuid bit set
# 8  ag  # executable with setgid bit set
# 9  ac  # directory writable to others, with sticky bit
# 10 ad  # directory writable to others, without sticky bit
#

# a black  ax = black or brown
# b red
# c green
# d brown  dx = yellow
# e blue
# f magenta
# g cyan
# h light grey
# A bold black, usually shows up as dark grey
# B bold red
# C bold green
# D bold brown, usually shows up as yellow
# E bold blue
# F bold magenta
# G bold cyan
# H bold light grey; looks like bright white
# x default foreground or background
# dx = yellow cx = green ex = black
# Bold and highlighted directories
export CLICOLOR=1
export LSCOLORS=dxcxexdxcxegedabagacad
#               0 1 2 3 4 5 6 7 8 9 10


##==============================
## grep colors
## example: echo hello there | blue_grep ll | yellow_grep ere
## example: echo hello there | mgrep ll | cgrep ere
##==============================
alias grep='grep --color=always'
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;35'
# grep --color "[[:digit:]]"
alias grepn='grep --color "[[:digit:]]"'


##==============================
## for python module tables needed by another module pyne (need to install hdf5)
##==============================
export HDF5_DIR=/usr/bin/hdf5



##==============================
##==============================
##==============================
## Custom functions
##==============================
function pyc() { python -c """from math import *; print($*)"""  ;} # pyc "sqrt(4) + 2**3"
function bcl() { bc -l <<< "$*"  ;} #  bcl "sqrt(4) + 2^3"
function cds () { cd *$1*; ls; }
function mkcd () { mkdir -p $1; cd $1; }
function topen () { touch "$1" && open "$1"; }
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
function makezip() { zip -r "${1%%/}.zip" "$1" ; }



##======================================
## Syntax Highlight using pygments python module and terminal command
##======================================
# from pygments.styles import get_all_styles
# styles = list(get_all_styles())
# print(styles)
#
# ['default',      'emacs',    'friendly', 'colorful', 'autumn', 'murphy',
#  'manni',        'monokai',  'perldoc',  'pastie',   'borland',  'trac',
#  'native',       'fruity',   'bw',       'vim',      'vs',       'tango',
#  'rrt',          'xcode',    'igor',     'paraiso-light',    'paraiso-dark',
#  'lovelace',     'algol',    'algol_nu', 'arduino',   'rainbow_dash', 'abap']
# autumn is best. colorful makes some words yellow bold and unreadable.
# example bp all, bp all matlab, bp all tex,
# languges are c, fortran, matlab, python, bash, r, julia, perl, awk etc.
function bp () { clear; bpp "$1" | pygmentize -l "${2:-python}" -f terminal256 -O style=autumn -g ;}



function define() { open dict://"$@";}



# extract files
function extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}




# Convert all ptyhon scripts from py2 to py3
# Usage: my2to3 hello.py
function my2to3() { for f in *.py; do 2to3 -w $f && rm -rf $f.bak ; done;}


# Print docstrig of a python script
# Usage: pyd hello.py
function pyd() {
    python -c """import ${1%%.*};print(${1%%.*}.__doc__)""" ;
    }


function bk () {
    for file in "$@"; do
        local new=${file%%.*}_$(date '+%Y%m%d').${file#*.}
        while [[ -f $new ]]; do
            new+="~";
        done;
        printf "copying '%s' to '%s'\n" "$file" "$new";
        \cp -ip "$file" "$new";
    done
}

function bkp () {
    for file in "$@"; do
        local new=~/OneDrive/Bhishan/Backup/${file%%.*}_$(date '+%Y%m%d').${file#*.}
        while [[ -f $new ]]; do
            new+="~";
        done;
        printf "copying '%s' to '%s'\n" "$file" "$new";
        \cp -ip "$file" "$new";
    done
}




# uptime
function myuptime () {
  uptime | awk '{ print "Uptime:", $3, $4, $5 }' | sed 's/,//g'
  return;
}


##==============================
## For pdf
##==============================

# extract pdf pages
# usage: pdfextr input.pdf input_pages_2_4 2 4  # creates input_pages_2_4.pdf
#                $1        $2              $3 $4
function pdfextr() {
  echo "Chapter $2"
  pdftk A=$1 cat A$3-$4 output $2.pdf
  echo "Splitting pdf file $1 from page $3 to page $4 to create $2.pdf"
}

##==============================
## For Music
##==============================

# download best video quality using /opt/local/bin/youtube-dl
# usage: myvid https://youtu.be/450p7goxZqg?t=4
function myvid() {
  /opt/local/bin/youtube-dl -f bestvideo+bestaudio "$1"
  /bin/rm -r youtube_video_time.txt
}

# usage: mymp3 youtube_video_url
# cwix = --continue --no-overwrites --ignore-errors --extract-audio
# https://askubuntu.com/questions/673442/downloading-youtube-playlist-with-/opt/local/bin/youtube-dl-skipping-existing-files/709258
mymp3() {
    /opt/local/bin/youtube-dl --download-archive downloaded.txt --no-post-overwrites -ciwx --audio-format mp3 -o "%(title)s.%(ext)s" $1
}

# usage: mysongs youtube_video_url
mysongs() {
    /opt/local/bin/youtube-dl -ciwx --audio-format mp3  $1
}

# usage: songs_file songs.txt
songs_file() {
    /opt/local/bin/youtube-dl -ciwx --audio-format mp3  --batch-file $1
}

# initial x seconds trimmed mp3 song
# mytrim 36 https://youtu.be/f1qz8vn3XbY?list=RDYuXLN23ZGQo&t=219
mytrim() {
    local downloaded_file
    /opt/local/bin/youtube-dl --extract-audio --embed-thumbnail --audio-format mp3 -o "%(title)s.%(ext)s" $2
    downloaded_file="$(/opt/local/bin/youtube-dl --get-filename --extract-audio --embed-thumbnail --audio-format mp3 -o "%(title)s.%(ext)s" $2)"
    /opt/local/bin/ffmpeg -ss $1 -i "${downloaded_file}" -acodec copy -y trimmed.mp3
    mv trimmed.mp3 "${downloaded_file}"
    clear
    echo "${downloaded_file}"
    # Now replace whitespace by underscore
    find . -type f -name "* *.mp3" -exec bash -c 'mv "$0" "${0// /_}"' {} \;
    # Lowercase the file name
    for i in $(find . -name '*[A-Z]*.mp3' -type f); do mv "$i" "$(echo $i|tr A-Z a-z)"; done
}

##======================================
## Adding paths The last line is taken as default e.g. python --version
# Phosim needs python --version 2.7.5
# Sphinx needs python --version 3.6
# Module gzip needs pyton3.6 from standard python3
##======================================
# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
# alias py3='/Library/Frameworks/Python.framework/Versions/3.6/bin/python'
# export PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
# export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"

function setpy2(){
    clear;
    echo 'export PATH="/Users/poudel/miniconda2/bin:${PATH}"' >> ~/.bash_profile;
    source ~/.bash_profile
    echo "Setting PATH to python2.7"
    python --version
}

function setpy3(){
    echo 'export PATH="/Users/poudel/miniconda3/bin:$PATH"' >> ~/.bash_profile;
    source ~/.bash_profile;
    echo "Setting PATH to python3.6 from Miniconda"
    python --version
}

function bashtips {
cat <<EOF
DIRECTORIES
-----------
~-      Previous working directory
pushd tmp   Push tmp && cd tmp
popd        Pop && cd

GLOBBING AND OUTPUT SUBSTITUTION
--------------------------------
ls a[b-dx]e Globs abe, ace, ade, axe
ls a{c,bl}e Globs ace, able
\$(ls)      \`ls\` (but nestable!)

HISTORY MANIPULATION
--------------------
!!      Last command
!?foo       Last command containing \`foo'
^foo^bar^   Last command containing \`foo', but substitute \`bar'
!!:0        Last command word
!!:^        Last command's first argument
!\$     Last command's last argument
!!:*        Last command's arguments
!!:x-y      Arguments x to y of last command
C-s     search forwards in history
C-r     search backwards in history

LINE EDITING
------------
M-d     kill to end of word
C-w     kill to beginning of word
C-k     kill to end of line
C-u     kill to beginning of line
M-r     revert all modifications to current line
C-]     search forwards in line
M-C-]       search backwards in line
C-t     transpose characters
M-t     transpose words
M-u     uppercase word
M-l     lowercase word
M-c     capitalize word

COMPLETION
----------
M-/     complete filename
M-~     complete user name
M-@     complete host name
M-\$        complete variable name
M-!     complete command name
M-^     complete history
EOF
}


##======================================
## Bash Examples
##=====================================
function abc {
pygmentize <<EOF
#example of if else in bash:
#===========================
function abc() { if [ $1 = "code" ];
  then echo $1;
else
  echo "You did not type code.";
  echo "Please try again.";
fi
}
EOF
}



##======================================
## paths for python package adstex (Yao)
##======================================
export ADS_API_TOKEN="uAHAmzoNmrszZZErcyxdFap1bzMx12KY7fJhcHQK"





##======================================
## paths for texlive
##======================================
######### Path to update tlmgr for texlive
# kpsewhich --var-value=SELFAUTOPARENT
PATH="/opt/local/libexec:${PATH}"
export PATH
PATH="/usr/local/texlive/2017/bin/x86_64-darwin/tlmgr:${PATH}"
export PATH

# path for pylinf for conda3
PATH="/Users/poudel/.local/bin:${PATH}"
export PATH



##======================================
## Put settings in the end
##======================================
# added by Miniconda2 installer
export PATH="/Users/poudel/miniconda2/bin:$PATH"

# added by Miniconda2 installer
export PATH="/Users/poudel/miniconda2/bin:$PATH"

# added by Miniconda3 installer
export PATH="/Users/poudel/miniconda3/bin:$PATH"

# The lines below this are added by function setpy2 and setpy3
export PATH="/Users/poudel/miniconda3/bin:$PATH"
export PATH="/Users/poudel/miniconda2/bin:${PATH}"
export PATH="/usr/local/sbin:$PATH"
export PATH="/Users/poudel/miniconda2/bin:${PATH}"
export PATH="/Users/poudel/miniconda3/bin:$PATH"
export PATH="/Users/poudel/miniconda2/bin:${PATH}"
export PATH="/Users/poudel/miniconda3/bin:$PATH"
export PATH="/Users/poudel/miniconda2/bin:${PATH}"
export PATH="/Users/poudel/miniconda2/bin:${PATH}"
alias qjp="kill $(pgrep jupyter)"
export PATH="/Users/poudel/miniconda3/bin:$PATH"

export PATH="/Users/poudel/miniconda2/bin:${PATH}"

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH
export PATH="/Users/poudel/miniconda3/bin:$PATH"
export PATH="/Users/poudel/miniconda2/bin:${PATH}"
export PATH="/Users/poudel/miniconda3/bin:$PATH"
