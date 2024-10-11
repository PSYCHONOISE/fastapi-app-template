#!/bin/bash

# https://www.shellcheck.net/
# https://itisgood.ru/2024/03/13/chto-takoe-ifs-v-skriptakh-na-bash/

GIT_USER_NAME="PSYCHONOISE"
GIT_USER_EMAIL="id206641178@gmail.com"
GIT_REPOSITORY="fastapi-app-template"

git config --global user.name $GIT_USER_NAME
git config --global user.email $GIT_USER_EMAIL

OUTPUT=$(ssh -T git@github.com) # Проверка соединения с GitHub по SSH
echo $OUTPUT
if echo "$OUTPUT" | grep -q "successfully authenticated"; then # Если SSH подключение успешно, то устанавливаем SSH ссылку, иначе переключаемся на HTTPS.
  echo "SSH authentication successful. Setting remote URL to SSH."
  git remote set-url origin "git@github.com:$GIT_USER_NAME/$GIT_REPOSITORY.git"
else
  echo "SSH authentication failed. Setting remote URL to HTTPS."
  git remote set-url origin "https://github.com/$GIT_USER_NAME/$GIT_REPOSITORY.git"
fi

set -e

IFS='.' read -r -a array <<< "$(cat version)"

if git diff-index --quiet HEAD --; then
  echo "There are NO changes to the working directory."
  VERSION="${array[0]}.${array[1]}.${array[2]}"
  echo "Current version $VERSION. Remains unchanged."
  # exit 0
  if [ -n "$(git log origin/$(git branch --show-current)..HEAD)" ]; then
    echo "There are unsent commits."
    git status
  else
    echo "There are NO uncommitted commits."
    git status
    exit 0
  fi
else
  echo "There are changes in the working directory."
  VERSION="${array[0]}.${array[1]}.$((array[2] + 1))"
  echo "The current version has been changed to $VERSION."
  # exit 0
  echo $VERSION > ./version
  git add .
  git status
  git commit -m "${VERSION}"
fi

git branch -M main
git push -u origin main
