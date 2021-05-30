# tested so far with:
# - no revision specified and remote has a HEAD which is used
# - revision specified and remote has a HEAD
# - revision specified and remote without HEAD
source $stdenv/setup

header "exporting $url (rev $rev) into $out"

# Hack to use my mirror
HOME=$(mktemp -d)
git config --global url."/mnt/cache/mirror/".insteadOf "https://android.googlesource.com/"
git config --global url."/mnt/cache/lineageos/LineageOS/".insteadOf "https://github.com/LineageOS/"
git config --global url."/mnt/cache/muppets/TheMuppets/".insteadOf "https://github.com/TheMuppets/"

$SHELL $fetcher --builder --url "$url" --out "$out" --rev "$rev" \
  ${leaveDotGit:+--leave-dotGit} \
  ${deepClone:+--deepClone} \
  ${fetchSubmodules:+--fetch-submodules} \
  ${branchName:+--branch-name "$branchName"}

runHook postFetch
stopNest
