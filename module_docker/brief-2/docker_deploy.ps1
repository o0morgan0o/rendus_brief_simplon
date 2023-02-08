# Deployement Script for Booth Project
# Author: Morgan Thibert


# input parameters
# -startingPort: starting port number
# -numberOfInstances: number of instances to launch
# -onlyStopAndDeleteContainers: if set, only stop and delete containers of the project
param(
    [Parameter(HelpMessage="Enter starting port number")][int]$startingPort = -1,
    [Parameter(HelpMessage="Enter number of instances")][int]$numberOfInstances = 0,
    [switch]$onlyStopAndDeleteContainers = $false
)

# I choose arbitrarely 20 as max number of instances
$MAX_NUMBER_OF_INSTANCES = 20
# name of the image and project
$IMAGE_NAME = "booth-project-image"
$PROJECT_NAME = "booth-instance"


function show_usage {
    Write-Host( "")
    Write-Host( "Usage:")
    Write-Host( "For launching instances of the project:")
    Write-Host( "    docker_deploy.ps1 -startingPort <startingPort> -numberOfInstances <numberOfInstances>")
    Write-Host( "    example: docker_deploy.ps1 -startingPort 8000 -numberOfInstances 4")
    Write-Host( "")
    Write-Host( "If you just want to stop and delete containers of the project, use the flag -onlyStopContainers")
    Write-Host( "    docker_deploy.ps1 -onlyStopAndDeleteContainers")
    Write-Host( "")

}

function show_script_step {
    param($commandInfo)
    Write-Host("[+] $commandInfo") -ForegroundColor Green
}

function showError {
    param($errorMessage)
    Write-Host("=====================================") -ForegroundColor Red
    Write-Host("[!] $errorMessage") -ForegroundColor Red
    Write-Host("=====================================") -ForegroundColor Red
}

function stopContainer {
    show_script_step "Stopping all containers of the project $PROJECT_NAME ..."
    $runningContainers = [string](docker container ls -a -q --filter name=$PROJECT_NAME)
    if($null -ne $runningContainers){
        try { 
            Write-Host("trying to stop $runningContainers")
            $cmd = "docker container stop $runningContainers"
            Invoke-Expression $cmd
            Write-Host("Containers $runningContainers stopped")
        } catch { 
            showError "Error while stopping containers"
            Write-Host "$_"
        }
    }
}

function deleteContainer {
    show_script_step "Deleting all containers of the project $PROJECT_NAME ..."
    $runningContainers = [string](docker container ls -a -q --filter name=$PROJECT_NAME)
    if($null -ne $runningContainers){
        try { 
            Write-Host("trying to delete $runningContainers")
            $cmd = "docker container rm $runningContainers"
            Invoke-Expression $cmd
            Write-Host("Containers $runningContainers deleted")
        } catch { 
            showError "Error while removing containers"
            Write-Host "$_"
        }
    }
}
function validateStartingPortNumber {
    param($startingPort)
    $startingPortAsInt = $startingPort -as [int]
    $isStartingPortValid = $startingPortAsInt -gt 0 -and $startingPortAsInt -lt 65535
    return $isStartingPortValid
}

function validateNumberOfInstances {
    param($numberOfInstances)
    $numberOfInstancesAsInt = $numberOfInstances -as [int]
    $isNumberOfInstancesValid = $numberOfInstancesAsInt -gt 0 -and $numberOfInstancesAsInt -lt $MAX_NUMBER_OF_INSTANCES
    return $isNumberOfInstancesValid
}


# ======================================================
# ======================================================
# END OF FUNCTIONS DEFINITION
# START OF THE SCRIPT
# ======================================================
# ======================================================



# if the switch flag is not set AND one of the varaible StartingPort or numberOfInstances is not set, we show the usage
if($false -eq $onlyStopAndDeleteContainers){
    if($startingPort -eq -1 -or $numberOfInstances -eq 0){
        show_usage
        exit 1
    }
}


# ======================================================
# stopping and deleting containers 
if($onlyStopAndDeleteContainers -eq $true){
    stopContainer
    deleteContainer
    # if flag only stop containers is set, we exit here
    exit 0
}

# ======================================================
# validation of starting port
$isStartingPortValid = validateStartingPortNumber $startingPort
if(!$isStartingPortValid){
    showError "Invalid port number"
    exit 1
}

# ======================================================
# validation of number of instances
$isNumberOfInstancesValid = validateNumberOfInstances $numberOfInstances
if(!$isNumberOfInstancesValid){
    showError "Invalid number of instances"
    exit 1
}

# ======================================================
# get starting and ending port
$endingPort = $startingPort + $numberOfInstances - 1

# ======================================================
# building image step
show_script_step "Building image $IMAGE_NAME ..."
docker build --rm --file "dockerfile" --tag "$image_name" "."

# ======================================================
# stopping and deleting containers
stopContainer
deleteContainer

# ======================================================
# starting containers
Write-Host("")
for($i = $startingPort; $i -le $endingPort; $i++){
    $port = $i
    $containerName = "$PROJECT_NAME-$port"
    Write-Host "Starting container $containerName on port $port with image $IMAGE_NAME"
    $cmd = "docker run -d --name $containerName -p $($port):80 $IMAGE_NAME"
    try {
        Invoke-Expression $cmd
        show_script_step "container $containerName started on port $port"
    }catch {
        showError "Error while starting container $containerName"
        Write-Host "$_"
    }
    Write-Host("")
}

show_script_step "DONE !"
