function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
function makezip() { zip -r "${1%%/}.zip" "$1" ; }
function setgovernor() {
  [ -z "$1" ] && return 1
  [ "$1" != "conservative" ] && [ "$1" != "performance" ] && return 1
  echo "$1" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
}
function url_encode() {
  python3 -c "import urllib.parse; print(urllib.parse.quote(input()))" <<< "$1"
}
function myhome_submodules_update() {
  local _list=$( grep "path" "$HOME/.gitmodules" | cut -d"=" -f2 | tr -d ' ' )
  while IFS= read -r _path; do
    git --git-dir="${HOME}/${_path}/.git" pull origin master;
  done <<< "$_list"
  git --git-dir="$HOME/.myhome/" --work-tree="$HOME" add $( tr '\n' ' ' <<< "$_list" )
  git --git-dir="$HOME/.myhome/" --work-tree="$HOME" commit -m "Updated submod"
  git --git-dir="$HOME/.myhome/" --work-tree="$HOME" push origin master
}
