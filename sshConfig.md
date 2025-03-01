# How to handle 2 git accounts on one machine

```bash

# Company account
Host github.com
  User git
  Hostname github.com
  IdentityFile ~/.ssh/owgtm # email address for owgtm

# Personal account
Host github.com-byverdu
  User git
  Hostname github.com
  IdentityFile ~/.ssh/byverdu # email address for byverdu
```

When interacting with GitHub for the company account use the urls for cloning and pushing as you would normally do.

For the personal account a few steps are required:

```bash
# cloning a repository

# as specified in the ssh config file the url for the personal account is github.com-byverdu
git clone git@github.com-byverdu:byverdu/repoName.git

cd repoName

# configure git to use the personal account
git config user.email "byverdu@gmail.com"
git config user.name "Albert Vallverdu"

# creating a repository

mkdir newProject

cd newProject

git init

# configure git to use the personal account
git config user.email "byverdu@gmail.com"
git config user.name "Albert Vallverdu"

git remote add origin git@github.com-byverdu:byverdu/newProject.git # "-byverdu:" is used so we can have 2 git accounts in the same computer

git push -u origin main
```
