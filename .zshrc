# 交互式切换本地分支
git-sw() {
  local branch
  # 生成分支列表并附加备注
  branch=$(git branch --format="%(refname:short)" | \
    while read -r b; do
      # 从备注文件中获取当前分支的备注
      remark=$(jq -r ".[\"$b\"] // \"无备注\"" ~/.git-branch-notes 2>/dev/null)
      echo -e "$b\t$remark"  # 使用制表符分隔分支名和备注
    done | \
    fzf \
      --height 40% \
      --reverse \
      --header "选择分支 (名称 | 备注)" \
      --delimiter=$'\t' \
      --with-nth=1,2 | \
    awk '{print $1}'  # 提取选中的分支名
  )

  # 切换分支
  if [[ -n "$branch" ]]; then
    git switch "$branch"
  fi
}

# git 分支显示备注
alias gitb='git branch --format="%(refname:short)" | while read b; do echo "$b: $(git-brm show $b)"; done'
