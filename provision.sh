#!/usr/bin/env bash

composer install
npm -s install
bower install
gulp build


lando drush --yes sql-drop -y
lando drush --yes sql-sync @lando.staging @lando.dev
lando drush --yes rsync @lando.staging:%files @lando.dev:%files

