#!/usr/bin/env bash

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Not a git repository"
  echo "Press any key to close."
  read -r -n 1 -s
  exit 1
fi

pr_file=$(mktemp)
trap 'rm -f "$pr_file"' EXIT

if command -v gh >/dev/null 2>&1; then
  gh pr list --state all --limit 500 \
    --json number,headRefName,state,isDraft \
    --jq '.[] | [.headRefName, .number, .state, .isDraft] | @tsv' \
    >"$pr_file" 2>/dev/null
fi

remotes=$(git remote | tr '\n' ' ')

selection=$(
  git branch -a --format='%(refname:short)' | grep -v '/HEAD$' |
    awk -v prfile="$pr_file" -v remotes="$remotes" -v maxwidth=50 '
      BEGIN {
        FS = "\t"
        while ((getline line < prfile) > 0) {
          split(line, f, "\t")
          head = f[1]
          if (!(head in num) || (f[3] == "OPEN" && status[head] != "open" && status[head] != "draft")) {
            num[head] = f[2]
            if (f[3] == "OPEN") status[head] = (f[4] == "true") ? "draft" : "open"
            else status[head] = tolower(f[3])
          }
        }
        n = split(remotes, r, " ")
        for (i = 1; i <= n; i++) remote[r[i]] = 1
      }
      {
        branch = $0
        key = branch
        if (!(key in num)) {
          slash = index(branch, "/")
          if (slash > 0 && (substr(branch, 1, slash - 1) in remote)) {
            key = substr(branch, slash + 1)
          }
        }
        if (key in num) label = "#" num[key] " (" status[key] ")"
        else label = ""
        branches[NR] = branch
        labels[NR] = label
        if (length(branch) > width) width = length(branch)
      }
      END {
        if (width > maxwidth) width = maxwidth
        for (i = 1; i <= NR; i++) printf "%-*s  %s\n", width, branches[i], labels[i]
      }
    ' |
    fzf |
    awk '{print $1}'
)
[ -z "$selection" ] && exit 0

workmux add "$selection" || {
  echo
  echo "workmux add failed. Press any key to close."
  read -r -n 1 -s
}
