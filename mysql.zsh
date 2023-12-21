#!/usr/bin/env zsh

set -e -o verbose

# repo

pushd `dirname $0`

# git update-index --assume-unchanged mysql/.mysql/workbench/connections.xml
# git update-index --assume-unchanged mysql/.mysql/workbench/wb_options.xml
# git update-index --assume-unchanged mysql/.mysql/workbench/wb_state.xml

git update-index --assume-unchanged dbeaver/DBeaverData/workspace6/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.editors.prefs
git update-index --assume-unchanged dbeaver/DBeaverData/workspace6/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.workbench.prefs
git update-index --assume-unchanged dbeaver/DBeaverData/workspace6/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.jkiss.dbeaver.core.prefs
git update-index --assume-unchanged dbeaver/DBeaverData/workspace6/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.jkiss.dbeaver.ui.app.standalone.prefs
git update-index --assume-unchanged dbeaver/DBeaverData/workspace6/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.jkiss.dbeaver.ui.statistics.prefs
git update-index --assume-unchanged dbeaver/DBeaverData/workspace6/.metadata/.plugins/org.jkiss.dbeaver.ui/dialog_settings.xml
git update-index --assume-unchanged dbeaver/DBeaverData/workspace6/General/.dbeaver/data-sources.json

popd

# links

# stow --dir=`dirname $0` --target=$HOME --stow \
#   mysql

stow --dir=`dirname $0` --target=$XDG_DATA_HOME --stow \
  dbeaver

