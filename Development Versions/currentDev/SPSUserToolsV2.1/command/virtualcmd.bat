echo off
title Command Prompt Batch
ver
echo Freely Distributable. Rights reserved by Jaidon Preston, creator of SPSUserTools. Use CTRL-C to exit, or 'exit'
echo.
:Loop
set /P the="%cd%>"
%the%
echo.
goto loop