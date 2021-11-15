# Chemin vers le partage qui contient l'exécutable
$SharedFolder = " "

# Chemin vers le dossier temporaire local sur le poste
$LocalFolder = "C:\TEMP"

# Nom de l'exécutable
$ExeName = "ccsetup586.exe"
$Software = "ccleaner"
# Argument(s) à associer à l'exécutable
$ExeArgument = "/S"

# Le logiciel est-il déjà installé
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $Software }) -ne $null

if($installed)
{
   Write-Output "logiciel déjà installé"
   exit 
}

else{
   # Si le chemin réseau vers l'exécutable est valide, on continue
   if(Test-Path "$SharedFolder\$ExeName"){

     # Créer le dossier temporaire en local et copier l'exécutable sur le poste
     New-Item -ItemType Directory -Path "$LocalFolder" -ErrorAction SilentlyContinue
     Copy-Item "$SharedFolder\$ExeName" "$LocalFolder" -Force

     # Si l'on trouve bien l'exécutable en local, on lance l'installation
     if(Test-Path "$LocalFolder\$ExeName"){
        Start-Process -Wait -FilePath "$LocalFolder\$ExeName" -ArgumentList "$ExeArgument"
     }

     # Supprime l'exécutable
     Remove-Item "$LocalFolder\$ExeName"

   }
   else{
         Write-Warning "L'executable ($ExeName) est introuvable sur le partage !"
       }
}
