curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o git-prompt.sh
cd
ln -s .bash/git-prompt.sh .git-prompt.sh
ln -s .bash/bashrc .bashrc
source ~/.bashrc
