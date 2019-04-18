
$path = "C:\Users\admin.ps\Desktop\Microloon2018\" 
$files = @()
$files += Get-ChildItem -Path $path -File | % { $_.FullName }
$subfolder = Get-ChildItem -Path $path -Recurse -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName 

$Regex = "[^\p{L}\p{Nd}/.-_]"
$replaceTable = @{"ß"="ss";"à"="a";"á"="a";"â"="a";"ã"="a";"ä"="a";"å"="a";"æ"="ae";"ç"="c";"è"="e";"é"="e";"ê"="e";"ë"="e";"ì"="i";"í"="i";"î"="i";"ï"="i";"ð"="d";"ñ"="n";"ò"="o";"ó"="o";"ô"="o";"õ"="o";"ö"="o";"ø"="o";"ù"="u";"ú"="u";"û"="u";"ü"="u";"ý"="y";"þ"="p";"ÿ"="y"}

foreach ($folder in $subfolder){
     $files = $files += Get-ChildItem -Path $folder.FullName -File | % { $_.FullName }
}


foreach ($f in $files){
      
      $setname = Split-Path $f -leaf #get filename
      $setnewname = $setname -replace $Regex #check for regexpressions
          
        foreach($key in $replaceTable.Keys){
             $setnewname = $setnewname -Replace($key,$replaceTable.$key) #replace 
        }

        If($setname -ne $setnewname){
        Write-Host "found symbol", $f
        Rename-Item -Path $f -NewName  $setnewname
        }


}

