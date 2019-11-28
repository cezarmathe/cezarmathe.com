#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Clone the build repository
git clone "https://cezarmathe:${GITHUB_TOKEN}@github.com/cezarmathe/cezarmathe.github.io.git" public 1> /dev/null 2>&1

# Build the website
hugo -t hello-friend-ng || exit 1

# Cd into the build folder
cd public || exit 1

# Submit all changes
git add -A

# Commit changes
commit_message="Rebuilding site: $(date -u +"%Y-%m-%dT%H:%M:%SZ")\n"
if [ $# -eq 1 ]; then
    commit_message="$1"
fi
git commit -a -m "${commit_message}"

# Push the new changes to the build repository
git push origin master

# Come back to the project root
cd ..

# Remove the build folder(and repository)
rm -rf public
