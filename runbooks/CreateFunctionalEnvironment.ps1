workflow CreateFunctionalEnvironment
{
    [OutputType([string])]

    param (
        [parameter(Mandatory=$false)]  
        [String] $location,  
        [parameter(Mandatory=$false)]  
        [String] $resourceGroupName
    )

    Write-Output "Starting ..."

    $connectionName = "AzureRunAsConnection"
    try
    {
        # Get the connection "AzureRunAsConnection "
        $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

        "Logging in to Azure..."
        Add-AzureRmAccount `
            -ServicePrincipal `
            -TenantId $servicePrincipalConnection.TenantId `
            -ApplicationId $servicePrincipalConnection.ApplicationId `
            -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
    }
    catch {
        if (!$servicePrincipalConnection)
        {
            $ErrorMessage = "Connection $connectionName not found."
            throw $ErrorMessage
        } else{
            Write-Error -Message $_.Exception
            throw $_.Exception
        }
    }

    Write-Output "Created Connection"

    #Create resource Group    
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

    Write-Output "Created Resource Group" $resourceGroupName

    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri "https://raw.githubusercontent.com/manojsingh/azureautomation/master/azuredeploy.json" -TemplateParameterUri "https://raw.githubusercontent.com/manojsingh/azureautomation/master/azuredeploy.parameters.load.json"

    Write-Output "Created Deployment"
}