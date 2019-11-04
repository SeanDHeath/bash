curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.bash/git-prompt.sh
rm ~/.git-prompt.sh
rm ~/.bashrc
ln -s ~/.bash/git-prompt.sh ~/.git-prompt.sh
ln -s ~/.bash/bashrc ~/.bashrc
source ~/.bashrc
