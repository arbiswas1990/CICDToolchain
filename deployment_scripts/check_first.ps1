$label = kubectl get deployments -l app=demo-#{PackageName} --show-labels --sort-by=.metadata.creationTimestamp |  Select-Object -Skip 1 | foreach { ($_. trim() -split '\s+')[5]; } | select-object -first 1
write-host $label
if($label -eq "app=demo-#{PackageName}"){
write-host "Not the first deployment"
Set-OctopusVariable -name "FirstTime" -value "False"
}else{
write-host "first deployment"
Set-OctopusVariable -name "FirstTime" -value "True"
}
