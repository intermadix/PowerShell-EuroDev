
param(
[string] $CTName = "CTAR",
[string] $SiteURL = "https://< Jump ;tenant url>.sharepoint.com/sites/Docs/HR",
[string] $DocLibName = "Documents",
[string] $User = "amjad@<tenant url>.onmicrosoft.com",
[string] $Folder = "D:\FilesToUpload"
)
  
#Add references to SharePoint client assemblies and authenticate to Office 365 site - required for CSOM
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
$Password = Read-Host -Prompt "Please enter your password" -AsSecureString
  
#Param Messages
Write-Host "Document Library :" $DocLibName
Write-Host "Destination Site URL :" $SiteURL
  
#Bind to site collection
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User,$Password)
$Context.Credentials = $Creds
  
Write-Host "Credentials verified successfully!!"
  
Write-Host "In Progress.."
  
#Retrieve list
$List = $Context.Web.Lists.GetByTitle($DocLibName)
$Context.Load($List)
$Context.ExecuteQuery()
  
Write-Host "Document Library found"
  
#Upload file
  
Foreach ($File in (dir $Folder -File))
{
$FileStream = New-Object IO.FileStream($File.FullName,[System.IO.FileMode]::Open)
$FileCreationInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation
$FileCreationInfo.Overwrite = $true
$FileCreationInfo.ContentStream = $FileStream
$FileCreationInfo.URL = $File
  
$Upload = $List.RootFolder.Files.Add($FileCreationInfo)
Write-Host "In Progress."
  
$Context.Load($Upload)
$Context.Load($List.ContentTypes)
$Context.ExecuteQuery()
  
$item = $Upload.ListItemAllFields
Write-Host "File name "$File" have been uploaded successfully!!"
$item["Title"] = $File.BaseName
  
$newCTID="0?;
foreach($ct in $List.ContentTypes)
{
if($ct.Name.ToUpper() -eq $CTName.ToUpper())
{
write-host $ct.Name -Foregroundcolor Green
write-host $ct.ID -Foregroundcolor Red
$newCTID = $ct.ID
}
}
  
#Association of content type with uploading item
Write-Host "CT ID: " $newCTID -Foregroundcolor Yellow
$item["ContentTypeId"] =$newCTID
  
$item.Update()
$Context.ExecuteQuery()
  
Write-Host "Item is inserted to destination list successfully!!"
}
  
Write-Host "Completed uploading"e)