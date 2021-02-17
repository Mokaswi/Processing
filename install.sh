# homebrew
if !(type "brew" > /dev/null 2>&1); then
    echo "install HomeBrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null ; brew install caskroom/cask/brew-cask 2> /dev/null

else
    echo "Homebrew is already installed"
fi

if !(type "processing-java" > /dev/null 2>&1); then
    brew tap caskroom/cask
    brew install brew-cask
    echo "installing Processing via Homebrew..."
    brew cask install -v processing

    echo "Open Processing and install processing-java (from menu bar > Tools > install processing-java)"
    echo "input path to Processing.app: "
    read pjpath
    echo "adding path"
    sudo ln -s ${pjpath}/processing-java /usr/local/bin/
else
    pjpath=$(which processing-java)
    echo "processing-java is already installed : ${pjpath}"
fi

echo "add path to vscode setting (tasks.json)"
sed -i -e "s|\"command\":.*|\"command\": \"${pjpath}\",|g" .vscode/tasks.json