#!/usr/bin/env bash
# Link these dotfiles into $HOME. Anything already there is moved to
# ~/.dotfiles-backup-<date>/ first, so nothing is lost.
#   ./install.sh             symlink every file under home/
#   ./install.sh --copy      copy instead of symlinking
#   ./install.sh --dry-run   only show what would change
# System files (etc/) are not touched; see the README.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mode=link dry=0
for a in "$@"; do
    case $a in
        --copy) mode=copy ;;
        --dry-run) dry=1 ;;
        -h|--help) sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "unknown option: $a" >&2; exit 1 ;;
    esac
done
backup="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
changed=0

while IFS= read -r -d '' f; do
    rel=${f#"$HERE/home/"}
    dst="$HOME/$rel"
    [[ -L $dst && $(readlink "$dst") == "$f" ]] && continue      # already linked
    changed=$((changed + 1))
    if (( dry )); then
        [[ -e $dst || -L $dst ]] && echo "replace  ~/$rel" || echo "add      ~/$rel"
        continue
    fi
    mkdir -p "$(dirname "$dst")"
    if [[ -e $dst || -L $dst ]]; then
        mkdir -p "$backup/$(dirname "$rel")"
        mv "$dst" "$backup/$rel"
    fi
    if [[ $mode == link ]]; then ln -s "$f" "$dst"; else cp -a "$f" "$dst"; fi
done < <(find "$HERE/home" -type f -print0 | sort -z)

(( dry )) && { echo "$changed file(s) would change"; exit 0; }
echo "$changed file(s) ${mode}ed"
[[ -d $backup ]] && echo "previous versions: $backup"

# Wallpaper: ~/.config/hypr/wallpaper is a symlink that Super + Ctrl + W re-points.
walls="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")/Wallpapers"
if [[ ! -e $HOME/.config/hypr/wallpaper ]]; then
    first=$(find "$walls" -maxdepth 2 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) 2>/dev/null | sort | head -1)
    if [[ -n $first ]]; then
        ln -s "$first" "$HOME/.config/hypr/wallpaper" && echo "wallpaper: $first"
    else
        echo "no wallpaper yet: put images in $walls, then press Super + Ctrl + W"
    fi
fi

systemctl --user daemon-reload 2>/dev/null || true
cat <<'EOF'

Next:
  • packages:        yay -S --needed $(grep -v '^#' packages.txt | cut -d' ' -f1)
  • login shell:     chsh -s /usr/bin/zsh      (tty1 login then starts Hyprland)
  • auto time zone:  see README → "Automatic time zone"
  • AirPods:         https://github.com/B-Divyesh/airpods-macfeel
EOF
