#!/bin/bash

VERSION=$(cat version.txt)
PODSPEC="SwiftPrettyPrint.podspec"

sed -i "" -E "s/VERSION = \".+\"/VERSION = \"$VERSION\"/" $PODSPEC

# commit
git checkout -b "bump/$VERSION"
git add version.txt
git add SwiftPrettyPrint.podspec
git commit -m "bump version $VERSION"

# push
git push origin HEAD

# create PR
gh pr create \
    --base master \
    --title "bump: version $VERSION" \
    --body "bump: version $VERSION"

