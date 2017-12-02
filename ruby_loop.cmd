@echo off

if "%APPVEYOR%"=="True" (
  echo Running in APPVEYOR
  set ruby_pre=C:
  set vers=ruby200 ruby200-x64 ruby21 ruby21-x64 ruby22 ruby22-x64 ruby23 ruby23-x64 ruby24 ruby24-x64 ruby_trunk
) else (
  echo NOT RUNNING IN APPVEYOR
  set base_path=C:/Windows/system32;C:/Windows;C:/Windows/System32/Wbem;C:/Windows/System32/WindowsPowerShell/v1.0;C:/ruby25_64/bin;E:/msys64;C:/Program Files/Microsoft SQL Server/130/Tools/Binn;C:/Program Files/Git/cmd;"C:/Program Files (x86)/GNU/GnuPG/bin"
  set ruby_pre=E:/r_builds_RI2
  set vers=ruby200 ruby200-x64 ruby21 ruby21-x64 ruby22 ruby22-x64 ruby23 ruby23-x64 ruby24 ruby24-x64 ruby_trunk
)
@echo ————————————————————————————————————————————————————————————————— %1
@echo.
@type %1
@echo.

@for %%A in (%vers%) do (
  PATH=%ruby_pre%/%%A/bin;%base_path%
  call ruby %1 %%A
  call git --version
)
@PATH=%base_path%
