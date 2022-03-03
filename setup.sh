#!/bin/bash
resource=`az group list --query '[0].name' --output tsv`

echo "Creating VM Scale Set in $resource..."
az vmss create --resource-group $resource --name myScaleSet --image UbuntuLTS --upgrade-policy-mode automatic --admin-username azureuser --generate-ssh-keys

echo "Setting up webservers..."
az vmss extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --resource-group $resource --vmss-name myScaleSet --settings '{"fileUris":["https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate_nginx.sh"],"commandToExecute":"./automate_nginx.sh"}'

echo "Allowing port 80 to servers..."
az network lb rule create --resource-group $resource --name myLoadBalancerRuleWeb --lb-name myScaleSetLB --backend-pool-name myScaleSetLBBEPool --frontend-port 80 --backend-port 443 --frontend-ip-name loadBalancerFrontEnd --protocol tcp
