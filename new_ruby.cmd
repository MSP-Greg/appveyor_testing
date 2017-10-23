@echo off

set RI2_BASE=https://github.com/oneclick/rubyinstaller2/releases/download/

set RUBY_VERS=%RUBY_VERS_BASE%-%RBIT%

appveyor DownloadFile %RI2_BASE%%RI2_VERS%/%RUBY_VERS%.7z     -FileName C:/%RUBY_VERS%.7z
appveyor DownloadFile %RI2_BASE%%RI2_VERS%/%RUBY_VERS%.7z.asc -FileName C:/%RUBY_VERS%.7z.asc

"C:\Program Files\Git\usr\bin\gpg.exe" --verify C:/%RUBY_VERS%.7z.asc

7z x C:/%RUBY_VERS%.7z -oC:/

PATH=C:\%RUBY_VERS%\bin;%BASE_PATH%

rem ------------------------------------------- Delete html documentation files
echo Deleting documentation files
del /f /s /q C:\%RUBY_VERS%\share\doc > nul

rem ------------------------------------------- Updating RubyGems
echo Updating RubyGems
call gem install rubygems-update --env-shebang --silent -N
call update_rubygems > nul
call gem uninstall rubygems-update --quiet --silent
echo Adding Bundler
call gem install bundler --env-shebang --silent -N
rem ruby -Eutf-8:utf-8 bin_file_fix.rb
ruby bin_file_fix.rb

rem ------------------------------------------- Swap current install to old, replace with new
pushd \
ren C:\%RDIR%      %RDIR%_old
ren C:\%RUBY_VERS% %RDIR%
echo Deleting old Ruby files
del /f /s /q C:\%RDIR%_old > nul

rem ------------------------------------------- Delete downloads
echo Removing downloads
del /q C:\%RUBY_VERS%.7z
del /q C:\%RUBY_VERS%.7z.asc

rem ------------------------------------------- Set path, check install
popd
PATH=C:\%RDIR%\bin;%BASE_PATH%
rem ------------------------------------------- Check CLI files, remove ruby from path
PATH=%RUBY_OTHER%;%BASE_PATH%
echo.
call C:\%RDIR%\bin\gem env
echo.
call C:\%RDIR%\bin\bundle version
call C:\%RDIR%\bin\rake -V
PATH=C:\%RDIR%\bin;%BASE_PATH%
ruby appveyor_info.rb
echo.
echo.
