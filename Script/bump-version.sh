#!/bin/bash -ex

# verify current branch
BRANCH=$(git symbolic-ref --short HEAD)
if [ "$BRANCH" != "master" ]; then
    echo "Your current branch is [$BRANCH], please change to [master]."
    exit 1
fi

# update .podspec
VERSION=$(cat version.txt)
PODSPEC="SwiftPrettyPrint.podspec"
sed -i "" -E "s/VERSION = \".+\"/VERSION = \"$VERSION\"/" $PODSPEC

# commit
git checkout -b "bump/$VERSION"
git add version.txt
git add SwiftPrettyPrint.podspec
git commit --no-verify -m "bump version $VERSION"

# tag
git tag $VERSION

# push
git push origin HEAD
git push origin $VERSION

# create PR
gh pr create \
    --base master \
    --title "bump: version $VERSION" \
    --body "bump: version $VERSION"
