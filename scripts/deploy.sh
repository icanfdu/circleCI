#!/bin/sh

set -e

# 打印当前的工作路径
pwd
# 查看远程仓库的 URL：
remote=$(git config remote.origin.url)
# 打印仓库地址
echo 'remote is: '$remote

# 新建一个发布的目录
mkdir gh-pages-branch
cd gh-pages-branch
# 创建的一个新的仓库
# 设置发布的用户名与邮箱
git config --global user.email "$GH_EMAIL" >/dev/null 2>&1
git config --global user.name "$GH_NAME" >/dev/null 2>&1
git init
# 关联远程仓库，说白了就是 把远程仓库和本地目录关联起来
git remote add --fetch origin "$remote"

echo 'email is: '$GH_EMAIL
echo 'name is: '$GH_NAME
echo 'sitesource is: '$siteSource

# 切换gh-pages分支
if git rev-parse --verify origin/gh-pages >/dev/null 2>&1; then
    git checkout gh-pages
    # 删掉旧的内容，删除本地仓库的所有文件。
    git rm -rf .
else 
    git checkout --orphan gh-pages
fi

# 把构建好的文件目录给拷贝进来
cp -a "../${siteSource}/." .

ls -la

# 把所有的文件添加到git
git add -A
git commit --allow-empty -m "Deploy to GitHub pages [ci skip]"
git push --force --quiet origin gh-pages

# 资源回收，删除临时分支与目录（删除本地 刚刚创建的gh-pages-branch 文件夹， 因为我们已经把dist 文件放到了git的branch：gh-pages上了）
cd ..
rm -rf gh-pages-branch

echo "Finished Deployment!"
