#!/bin/bash
cleaners=(
  adobe_reader.cache
  adobe_reader.mru
  adobe_reader.tmp
#  amsn.cache
#  amsn.chat_logs
#  amule.backup
#  amule.known_clients
#  amule.known_files
#  amule.logs
#  amule.temp
#  apt.autoclean
#  apt.autoremove
#  apt.clean
#  apt.package_lists
#  audacious.cache
#  audacious.log
#  audacious.mru
#  bash.history
#  beagle.cache
#  beagle.index
#  beagle.logs
#  brave.cache
#  brave.cookies
#  brave.dom
#  brave.form_history
#  brave.history
#  brave.passwords
#  brave.search_engines
#  brave.session
#  brave.site_preferences
#  brave.sync
  brave.vacuum
  chromium.cache
  chromium.cookies
  chromium.dom
  chromium.form_history
  chromium.history
  chromium.passwords
  chromium.search_engines
  chromium.session
  chromium.site_preferences
  chromium.sync
  chromium.vacuum
#  d4x.history
  deepscan.backup
  deepscan.ds_store
  deepscan.thumbs_db
  deepscan.tmp
  deepscan.vim_swap_root
  deepscan.vim_swap_user
#  discord.cache
#  discord.cookies
#  discord.history
  discord.vacuum
#  dnf.autoremove
#  dnf.clean_all
#  easytag.history
#  easytag.logs
#  elinks.history
#  emesene.cache
#  emesene.logs
#  epiphany.cache
#  epiphany.cookies
#  epiphany.dom
#  epiphany.passwords
#  epiphany.places
#  evolution.cache
#  exaile.cache
#  exaile.downloaded_podcasts
#  exaile.log
#  filezilla.mru
#  firefox.backup
#  firefox.cache
#  firefox.cookies
  firefox.crash_reports
#  firefox.dom
#  firefox.forms
#  firefox.passwords
#  firefox.session_restore
#  firefox.site_preferences
#  firefox.url_history
  firefox.vacuum
#  flash.cache
#  flash.cookies
  gedit.recent_documents
#  gftp.cache
#  gftp.logs
  gimp.tmp
#  gl-117.debug_logs
  gnome.run
  gnome.search_history
  google_chrome.cache
  google_chrome.cookies
  google_chrome.dom
  google_chrome.form_history
  google_chrome.history
  google_chrome.passwords
  google_chrome.search_engines
  google_chrome.session
  google_chrome.site_preferences
  google_chrome.sync
  google_chrome.vacuum
#  google_earth.temporary_files
#  google_toolbar.search_history
#  gpodder.cache
#  gpodder.downloaded_podcasts
#  gpodder.logs
#  gpodder.vacuum
#  gwenview.recent_documents
#  hexchat.logs
#  hippo_opensim_viewer.cache
#  hippo_opensim_viewer.logs
#  java.cache
#  journald.clean
#  kde.cache
#  kde.recent_documents
#  kde.tmp
#  konqueror.cookies
#  konqueror.current_session
#  konqueror.url_history
  libreoffice.history
#  liferea.cache
#  liferea.cookies
#  liferea.vacuum
  links2.history
#  midnightcommander.history
#  miro.cache
#  miro.logs
#  nautilus.history
#  nexuiz.cache
#  octave.history
#  openofficeorg.cache
#  openofficeorg.recent_documents
#  opera.cache
#  opera.cookies
#  opera.dom
#  opera.form_history
#  opera.history
#  opera.passwords
#  opera.session
#  opera.site_preferences
  opera.vacuum
#  palemoon.backup
#  palemoon.cache
#  palemoon.cookies
#  palemoon.crash_reports
#  palemoon.dom
#  palemoon.forms
#  palemoon.passwords
#  palemoon.session_restore
#  palemoon.site_preferences
#  palemoon.url_history
#  palemoon.vacuum
#  pidgin.cache
#  pidgin.logs
#  realplayer.cookies
#  realplayer.history
#  realplayer.logs
#  recoll.index
#  rhythmbox.cache
#  rhythmbox.history
#  screenlets.logs
#  seamonkey.cache
#  seamonkey.chat_logs
#  seamonkey.cookies
#  seamonkey.download_history
#  seamonkey.history
#  secondlife_viewer.Cache
#  secondlife_viewer.Logs
#  skype.chat_logs
#  skype.installers
#  slack.cache
#  slack.cookies
  slack.history
  slack.vacuum
  sqlite3.history
  system.cache
#  system.custom
#  system.desktop_entry
#  system.free_disk_space
#  system.localizations
#  system.memory
  system.recent_documents
  system.rotated_logs
  system.tmp
  system.trash
  thumbnails.cache
#  thunderbird.cache
#  thunderbird.cookies
#  thunderbird.index
#  thunderbird.passwords
#  thunderbird.sessionjson
  thunderbird.vacuum
#  transmission.blocklists
#  transmission.history
#  transmission.torrents
#  tremulous.cache
  vim.history
  vlc.memory_dump
  vlc.mru
#  vuze.backup
#  vuze.cache
#  vuze.logs
#  vuze.stats
#  vuze.temp
#  warzone2100.logs
#  waterfox.backup
#  waterfox.cache
#  waterfox.cookies
#  waterfox.crash_reports
#  waterfox.dom
#  waterfox.forms
#  waterfox.passwords
#  waterfox.session_restore
#  waterfox.site_preferences
#  waterfox.url_history
#  waterfox.vacuum
  wine.tmp
  winetricks.temporary_files
  x11.debug_logs
#  xine.cache
#  yum.clean_all
#  yum.vacuum
#  zoom.cache
#  zoom.logs
#  zoom.recordings
)

while getopts "cp" arg
do
  case $arg in
    p)  bleachbit --preview "${cleaners[@]}";exit $?;;
    c)  bleachbit --clean "${cleaners[@]}";exit $?;;
  esac
done
