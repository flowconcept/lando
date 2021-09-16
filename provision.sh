#!/usr/bin/env bash

PS3='Welches Tool verwendest Du: '
tools=("Lando" "DDev")

select tool in "${tools[@]}"
do
  case $tool in
      "Lando")
          USED_TOOL=lando
          break;
          ;;
      "DDev")
          USED_TOOL=ddev
          break;
          ;;
    esac
done


PS3='Von welchem System sollen die Daten geholt werden: '
options=("Staging (nur Datenabgleich)" "Staging (komplett)" "Produktion (nur Datenabgleich)" "Produktion (komplett)" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Staging (nur Datenabgleich)")
            INSTALL=0
            TYPE=staging
            break            
            ;;
        "Staging (komplett)")
            INSTALL=1
            TYPE=staging
            break            
            ;;
        "Produktion (nur Datenabgleich)")
            INSTALL=0
            TYPE=prod
            break            
            ;;
        "Produktion (komplett)")
            INSTALL=1
            TYPE=prod
            break            
            ;;
        "Quit")
            QUIT=1;
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


if [ "$QUIT" = 1 ]; then
  exit
fi;

if [ "$INSTALL" = 1 ]; then
  composer install
  npm -s install
  bower install
  gulp build
fi

$USED_TOOL drush --yes sql-drop -y
$USED_TOOL drush --yes sql-sync @lando.$TYPE @self
$USED_TOOL drush --yes rsync @lando.$TYPE:%files @self:%files

