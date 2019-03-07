#Import the required DLL
Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll'
Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll'
#OR
Add-Type -Path 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll'



function login {
$adminUPN="admin@eurodev.onmicrosoft.com"
$orgName="EuroDev"
$userCredential = Get-Credential -UserName $adminUPN -Message "Type the password."
Connect-SPOService -Url https://$orgName-admin.sharepoint.com -Credential $userCredential
}


function getsiteinfo {
param(
    [Parameter(Mandatory)]
    [String]$siteUrl
)
Connect-SPOService ("{0}-admin.sharepoint.com" -f ($siteUrl.Substring(0, $siteUrl.IndexOf(".sharepoint.com")))) -Credential (Get-Credential)
Get-SPOSite $siteUrl | select *
Read-Host -Prompt "Press Enter to exit"
}


function getallsites {
    param(
        [Parameter(Mandatory)]
        [String]$tenant
    )
    Connect-SPOService ("https://{0}-admin.sharepoint.com" -f $tenant) -Credential (Get-Credential)
    Get-SPOSite -Limit All | select Template -unique | out-host
    $siteType = Read-Host "Optional template to filter by (or just hit Enter to get all sites)"
    $sites = Get-SPOSite -Limit All
    if ($siteType -ne "")
        {
            $sites = $sites | where { $_.Template -eq $siteType }
        }
    $sites | select Url, Template | Sort-Object Template, Url
    Read-Host -Prompt "Press Enter to exit"
}

 

Function Delete-SPOList
{
    param(
       # [Parameter(Mandatory)]
       # [String]$SiteURL,
        
       # [Parameter(Mandatory)]
       # [String]$ListName
    )
    
	Try {
    #Site URL
    #$SiteURL = 'https://eurodev.sharepoint.com/sites/ICT'
    $SiteURL = Read-Host 'Enter SiteURL'

    #Admin User Principal Name
    #$admin = 'admin@eurodev.onmicrosoft.com'
    $admin = Read-Host 'Enter User (full email)' 

    #Get Password as secure String
    $password = Read-Host 'Enter Password' -AsSecureString
  
        #Get Credentials to connect
        $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($admin, $password)
   
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Credentials

        

      Function runConnectDelete {
        Do {
            $inputFound = $true
            $ListName = Read-Host "Please enter list name or keep empty when done !!important Relations list as last!!"
    
            If ( $ListName -eq "" ) {
            $inputFound = $false    
             }
            Else {            
                $List=$Ctx.Web.Lists.GetByTitle($ListName)
                $List = $Ctx.Web.Lists.GetByTitle($ListName)
                $Fields = $List.Fields
                $Ctx.Load($List)
                $Ctx.Load($Fields)
                $Ctx.ExecuteQuery()

                $Field = $Fields | where{$_.Title -eq "RID"}
                if($Field){                                       
                    
                    $Column = $List.Fields.GetByTitle("RID")
                    $Column.DeleteObject()
                    $Ctx.ExecuteQuery()
               }
                #Delete the List - Send to Recycle bin
                $List.Recycle() | Out-Null 
                $Ctx.ExecuteQuery() 
                Write-host -f Green "List Deleted Successfully!"
            }


        }
       While ($inputFound -eq $true)
       }

       runConnectDelete
        
        
    }     Catch {
        write-host -f Red "Error deleting list!" $_.Exception.Message 
        runConnectDelete
        }

}


#selection funtion to run here - just uncomment and press play

#getsiteinfo
#getallsites # use template GROUP#0 
#login
Delete-SPOList