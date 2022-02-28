cd $(cat ~/.location) && sk --ansi -i -c 'grep -rI --color=always --line-number "{}" .' | python -c 'import sys; print(sys.stdin.readline().split(":")[0])' | xargs vim
