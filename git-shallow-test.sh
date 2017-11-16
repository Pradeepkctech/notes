#!/usr/bin/env bash

# https://github.com/cirosantilli/test-submodule-mod
# https://github.com/cirosantilli/test-submodule-top
# https://github.com/cirosantilli/test-submodule-top-shallow

set -ex

rm -rf *

mkdir mod
cd mod/
git init
touch a
git add a
git commit -m 1
touch b
git add b
git commit -m 2
cd ..

mkdir top
cd top
git init
touch a
git add a
git commit -m 1
touch b
git add b
git commit -m 2
git submodule add ../mod/ mod
git add .gitmodules
git commit -m '.gitmodules'
cd ..

cp -rv top top-shallow
cd top-shallow
printf '\tshallow = true\n' >> .gitmodules
git add .gitmodules
git commit -m 'shallow'
cd ..

mkdir mod-branch
cd mod-branch/
git init
touch a
git add a
git commit -m 1
touch b
git add b
git commit -m 2
git checkout -b mybranch HEAD~
touch c
git add c
git commit -m 3
cd ..

mkdir top-branch
cd top-branch
git init
touch a
git add a
git commit -m 1
touch b
git add b
git commit -m 2
git submodule add -b mybranch ../mod-branch/ mod
git add .gitmodules
git commit -m '.gitmodules'
cd ..

cp -rv top-branch top-branch-shallow
cd top-branch-shallow
printf '\tshallow = true\n' >> .gitmodules
git add .gitmodules
git commit -m 'shallow'
cd ..

git clone --depth 1 --recursive "file://$(pwd)/top" top-clone
git --git-dir top-clone/.git/modules/mod log
# two commits

git clone --depth 1 --recursive "file://$(pwd)/top-shallow" top-shallow-clone
git --git-dir top-shallow-clone/.git/modules/mod log
# one commit

rm -rf top2
git clone --depth 1 --recursive "file://$(pwd)/top-branch" top-branch-clone
git --git-dir top-branch-clone/.git/modules/mod log
# two commits

rm -rf top2
git clone --depth 1 --recursive "file://$(pwd)/top-branch-shallow" top-branch-shallow-clone
git --git-dir top-branch-shallow-clone/.git/modules/mod log
# one commit
