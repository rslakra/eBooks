# GitHub

---



## Folder Structure Conventions

---

```
/
├── Git-Cheatsheet.pdf
├── README.md
└── /
```


## Git

---

The ```git config``` command in Git is a utility used to set and query configuration variables that control various aspects of Git's behavior and appearance. These configuration variables are stored in plain text files at different levels of scope:

- System-wide:

Stored in ```/etc/gitconfig```, affecting all users and repositories on the system. Requires administrative privileges to modify.


- Global (per-user):
Stored in ```~/.gitconfig``` (or ```$HOME/.gitconfig```), affecting all repositories for a specific user.

- Local (per-repository):
Stored in ```.git/config``` within a specific repository, affecting only that repository. This overrides global and system settings.

- Worktree (per-worktree):
Stored in ```.git/config.worktree``` within a specific worktree, affecting only that worktree. This overrides local settings.


### Common uses of ```git config``` include:

#### Setting user information.

```shell
git config --global user.name "Rohtash Lakra"
git config --global user.email "rslakra@users.noreply.github.com"
```

These settings are crucial as every Git commit records this information as the author. Configuring the default text editor.
```shell
git config --global core.editor "vim"
```

- Setting up aliases for frequently used Git commands:
```shell
git config --global alias.co checkout
git config --global alias.st status
```

#### To view configuration settings:

- List all settings
```shell
git config --list
```

- List settings at a specific level.
```shell
git config --list --system
git config --list --global
git config --list --local
```

- Retrieve a specific setting's value.
```shell
git config user.name
```

### SSH keys

- Configure config file

```shell
cat ~/.ssh/config
```

```text
# ~/.ssh/config
#Host github.com
#  AddKeysToAgent yes
#  UseKeychain yes
#  IdentityFile ~/.ssh/id_ed25519

Host work.github.com
      HostName github.com
      User rlakra-work
      IdentityFile ~/.ssh/id_ed25519

Host rslakra.github.com
      HostName github.com
      User rslakra
      IdentityFile ~/.ssh/id_ed25519_rslakra
```

- Add SSH Keys Script

```shell
#!/bin/bash
#~/addSSHKeys
#Rohtash Lakra
echo
USER_NAME="${1}"
if [ "${USER_NAME}" == "rslakra" ]; then
  ssh-add ~/.ssh/id_ed25519_rslakra
elif [ "${USER_NAME}" == "work" ]; then
  ssh-add ~/.ssh/id_ed25519
else
  ssh-add ~/.ssh/id_rsa
fi

echo
```

- Checkout Repository

>- Clone using the web URL.
```shell
git clone https://<host-prefix>.github.com/<username>/<repository>.git

i.e.

git clone https://rslakra.github.com/rslakra/eBooks.git
git clone https://work.github.com/rslakra/eBooks.git
```

>- Clone using a password-protected SSH key.
```shell
git clone git@<host-prefix>.github.com:<username>/<repository>.git

i.e.

git clone git@rslakra.github.com:rslakra/eBooks.git
git clone git@work.github.com:rlakra-work/Scripts.git
```

>- Clone using official CLI.
```shell
gh repo clone rslakra/eBooks
```




# Reference

---

- [Git config](https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-config)
- [Git config](https://git-scm.com/docs/git-config)
- [Git Config](https://www.educative.io/courses/learn-git/git-config?utm_campaign=Pmax_feb25&utm_source=google&utm_medium=ppc&utm_content=&utm_term=&eid=5082902844932096&utm_term=&utm_campaign=%5BMar+25%5D+Pmax.+-+Coding+Interview+Prep&utm_source=adwords&utm_medium=ppc&hsa_acc=5451446008&hsa_cam=22344713166&hsa_grp=&hsa_ad=&hsa_src=x&hsa_tgt=&hsa_kw=&hsa_mt=&hsa_net=adwords&hsa_ver=3&gad_source=1&gad_campaignid=22354833079&gbraid=0AAAAADfWLuTN0uX2MU_NJ0LJBYJK0XIks&gclid=Cj0KCQjw5c_FBhDJARIsAIcmHK9jSyCGp0JAIIJYVi9UsAjW-LUlPFG8x_1oHnLRoREawnUbOzJusuQaAjBXEALw_wcB)
- [Managing multiple accounts](https://docs.github.com/en/account-and-profile/how-tos/setting-up-and-managing-your-personal-account-on-github/managing-your-personal-account/managing-multiple-accounts)
- [Connecting to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [Troubleshooting SSH](https://docs.github.com/en/authentication/troubleshooting-ssh)




# Author

---

- [Rohtash Lakra](https://github.com/rslakra)
