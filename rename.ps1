
$path = "C:\Users\paul.sombekke\Desktop\PowerShell EuroDev\testmap\" 
$files = Get-ChildItem -Path $path -File | % { $_.FullName }
$subfolder = Get-ChildItem -Path $path -Recurse -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName 

foreach ($folder in $subfolder){
     $files = $files += Get-ChildItem -Path $folder.FullName -File | % { $_.FullName }
}


foreach ($f in $files){
     #Write-Host $f

     if ($f -match "\€"){
      Write-Host "found symbol", $f
      $setnewname = Split-Path $f -leaf
      $setnewname = $setnewname -replace "€"

      Rename-Item -Path $f -NewName  $setnewname
         }

}




