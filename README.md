# Bootstrap
```bash
git clone --bare https://github.com/johannfr/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
```
# Get other dependencies

## Powerlevel10k for zsh
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
```

## Poetry completions (after installing poetry)
```bash
mkdir $ZSH/plugins/poetry
poetry completions zsh > $ZSH/plugins/poetry/_poetry
```

## Clang completer for YouCompleteMe
```bash
cd ~/.vim/pack/jof/start/YouCompleteMe
python3 install.py --clang-completer --clangd-completer
```

## Helptags for fugitive
```bash
cd ~/.vim/pack/jof/start
vim -u NONE -c "helptags fugitive/docs" -c q
```
