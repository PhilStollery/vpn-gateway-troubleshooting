resource=`az group list --query '[0].name' --output tsv`
az vmss create --name myScaleSet --image UbuntuLTS --upgrade-policy-mode automatic --admin-username azureuser --generate-ssh-keys --resource-group $resource
az vmss extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --vmss-name myScaleSet --settings '{"fileUris":["https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate_nginx.sh"],"commandToExecute":"./automate_nginx.sh"}' --resource-group $resource
az network lb rule create --name myLoadBalancerRuleWeb --lb-name myScaleSetLB --backend-pool-name myScaleSetLBBEPool --frontend-port 80 --backend-port 443 --frontend-ip-name loadBalancerFrontEnd --protocol tcp --resource-group $resource
