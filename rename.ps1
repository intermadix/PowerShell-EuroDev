
$path = "C:\Users\admin.ps\Desktop\Microloon2018\" 
$files = @()
$files += Get-ChildItem -Path $path -File | % { $_.FullName }
$subfolder = Get-ChildItem -Path $path -Recurse -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName 

$Regex = "[^\p{L}\p{Nd}/.-_]"
$replaceTable = @{"�"="ss";"�"="a";"�"="a";"�"="a";"�"="a";"�"="a";"�"="a";"�"="ae";"�"="c";"�"="e";"�"="e";"�"="e";"�"="e";"�"="i";"�"="i";"�"="i";"�"="i";"�"="d";"�"="n";"�"="o";"�"="o";"�"="o";"�"="o";"�"="o";"�"="o";"�"="u";"�"="u";"�"="u";"�"="u";"�"="y";"�"="p";"�"="y"}

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

