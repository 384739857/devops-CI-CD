#!/bin/bash

set -e
# git log | grep "^Author: " | awk '{print $2}'
# git log | grep "^Author: " | awk '{print $2}' | sort | uniq
# { printf "added lines: %s, removed lines: %s, total lines: %s, total of intersections lines: %s\n", add, subs, total, loc }' -; done
usernamelist="admin zhangsan lisi wangwu"

contributors=$(git log --since=2021-01-01 --until=2022-01-11 | grep "^Author: " | awk '{print $2}' | sort | uniq)

for username in $usernamelist
do
  # 贡献者们
  for committer in $contributors
  do
    # 是否存在贡献者列表
    if [ $username == $committer ]; then
      ADD=$(git log --author=$username --since=2021-01-01 --until=2022-01-11 --format='%aN' | sort -u | while read name; do echo -en ""; git log --author="$username" --pretty=tformat: --numstat | grep "\(.html\|.js\|.ts\|.vue\|.tsx\|.jsx\|.css\|.scss\|.postcss\|Dockerfile\|.md\|.json\|.yml\|.gitignore\|.png\|.jpg\|.png\|.svg\|.ico\)$"  | awk '{ add += $1; subs += $2; } END { printf "%s", add}' -; done) || 0

      REMOVED=$(git log --author=$username --since=2021-01-01 --until=2022-01-11 --format='%aN' | sort -u | while read name; do echo -en ""; git log --author="$username"  --pretty=tformat: --numstat | grep "\(.html\|.js\|.ts\|.vue\|.tsx\|.jsx\|.css\|.scss\|.postcss\|Dockerfile\|.md\|.json\|.yml\|.gitignore\|.png\|.jpg\|.png\|.svg\|.ico\)$"  | awk '{ add += $1; subs += $2; } END { printf "%s", subs}' -; done) || 0

      # TOTAL=$(($ADD+$REMOVED))
      # RELATIVE_TOTAL=$(($ADD-$REMOVED))
      # echo "ADD=$ADD"
      # echo "REMOVED=$REMOVED"
      # echo "TOTAL=$TOTAL"
      # echo "RELATIVE_TOTAL=$RELATIVE_TOTAL"
      echo "$username的统计行数: $ADD $REMOVED $(($ADD+$REMOVED)) $(($ADD-$REMOVED))"
    fi
  done
done
