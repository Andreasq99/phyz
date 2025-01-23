cd C:\Users\Andreas\GitHub\Phyz\Build
powershell -command "Compress-Archive -Path '.\BuildStaging\*' -DestinationPath '.\Phyz.zip'"
cmd /c "ren Phyz.zip Phyz.love"
del "./Phyz.zip"
copy /b "C:\Program Files\LOVE\love.exe"+".\Phyz.love" "..\bin\Phyz.exe"
del "./Phyz.love"