workflow StartStopVMs
{
    Param 
    (    
        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
        [String] $resourceGroupName, 

        [Parameter(Mandatory=$false)][ValidateSet("Start","Stop")] 
        [String] $Action 
    ) 
     
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
    
    $AzureVMs = Get-AzureRmVM -ResourceGroupName $resourceGroupName
 
    #foreach($AzureVM in $AzureVMs) 
    #{ 
        #if(!(Get-AzureRmVM | ? {$_.Name -eq $AzureVM})) 
        #{ 
         #   throw " AzureVM : [$AzureVM] - Does not exist! - Check your inputs " 
        #} 
    #} 
 
    if($Action -eq "Stop") 
    { 
        Write-Output "Stopping VMs"; 
        foreach -parallel ($AzureVM in $AzureVMs) 
        { 
            Stop-AzureRmVm -Name $AzureVM.Name -ResourceGroupName $AzureVM.ResourceGroupName -Force;
        } 
    } 
    else 
    { 
        Write-Output "Starting VMs"; 
        foreach -parallel ($AzureVM in $AzureVMs) 
        { 
            Start-AzureRmVM  -Name $AzureVM.Name -ResourceGroupName $AzureVM.ResourceGroupName       
        } 
    } 
}