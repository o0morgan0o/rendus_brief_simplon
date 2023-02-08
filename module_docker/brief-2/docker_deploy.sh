#!/bin/bash
# Deployement Script for Booth Project
# Author: Morgan Thibert


# ======================================================
# definition of constants
MAX_NUMBER_OF_CONTAINERS=20
IMAGE_NAME="booth-project-image"
PROJECT_NAME="booth-instance"

# Utility function to show error message in red color
function show_error_message(){
    tput setaf 1
    echo "$1"
    tput sgr0
}

function show_in_yellow(){
    tput setaf 3
    echo "$1"
    tput sgr0
}

# Utility function to show success message in green color
function show_success_message(){
    tput setaf 2
    echo "$1"
    tput sgr0
}


function show_usage {
    echo "Usage: $0 [-h] [-d] [-p starting_port] [-n number_of_instances]"
    echo "-h : show usage"
    echo "-d : only stop and delete all containers"
    echo "-p : starting port for launching containers"
    echo "-n : number of instances"
    echo ""
    echo "Examples: "
    echo "  Stop and delete all containers of project:"
    echo "  $0 -d"
    echo "  Launch 3 instances of project starting from port 8080:"
    echo "  $0 -p 8080 -n 3"
}

function starting_port_validation {
    # this condition checks if the argument passed is an integer
    if ! [ "$1" -eq "$1" ] 2>/dev/null ; then
        show_error_message "Starting port should be an integer"
        exit 1
    fi
    if [ "$1" -gt 65535 ]; then
        show_error_message "Starting port too high (max 65535)"
        exit 1
    fi
    if [ "$1" -lt 1 ]; then
        show_error_message "Invalid starting port (min 1)"
        exit 1
    fi
}

function number_of_instances_validation {
    if ! [ "$1" -eq "$1" ] 2>/dev/null ; then
        show_error_message "number of instances should be an integer"
        exit 1
    fi
    if [ "$1" -lt 1 ]; then
        show_error_message "Invalid number of instances (min 1)"
        exit 1
    fi
    if [ "$1" -gt $MAX_NUMBER_OF_CONTAINERS ]; then
        show_error_message "Too many instances (max $MAX_NUMBER_OF_CONTAINERS)"
        exit 1
    fi
}

function stop_containers {
    show_in_yellow "[+] Stopping  all containers..."
    RUNNING_CONTAINERS_CMD="docker container ls -a -q --filter name=$PROJECT_NAME"
    RUNNING_CONTAINERS=$(eval $RUNNING_CONTAINERS_CMD)
    if [ -z "$RUNNING_CONTAINERS" ]; then
        show_in_yellow "[W] No containers to stop"
    else
        show_success_message "[+] Stopping containers: $RUNNING_CONTAINERS"
        STOP_CONTAINERS_CMD="docker container stop $RUNNING_CONTAINERS"
        eval $STOP_CONTAINERS_CMD
    fi
}

function delete_containers {
    show_in_yellow "[+] Deleting all containers..."
    FOUND_CONTAINERS_CMD="docker container ls -a -q --filter name=$PROJECT_NAME"
    FOUND_CONTAINERS=$(eval $FOUND_CONTAINERS_CMD)
    if [ -z "$FOUND_CONTAINERS" ]; then
        show_in_yellow "[W] No containers to delete"
    else
        show_success_message "[+] Deleting containers: $RUNNING_CONTAINERS"
        DELETE_CONTAINERS_CMD="docker container rm $RUNNING_CONTAINERS"
        eval $DELETE_CONTAINERS_CMD
    fi

}


# ======================================================
# ======================================================
# END OF FUNCTIONS DEFINITION
# START OF THE SCRIPT
# ======================================================
# ======================================================


# ======================================================
# definition of variables
STARTING_PORT=-1
INSTANCES=-1
STOP_AND_DELETE_CONTAINERS=0

# ======================================================
# if no args passed, show usage
if [ $# -eq 0 ]; then
    show_usage
    exit 1
fi

# ======================================================
# parsing arguments
while getopts "hdp:n:" option; do
    case "$option" in
        h)
            show_usage
            exit 0
            ;;
        d)
            STOP_AND_DELETE_CONTAINERS=1
            ;;
        p)
            STARTING_PORT=$OPTARG
            ;;
        n)
            INSTANCES=$OPTARG
            ;;
        *)
            show_usage
            exit 1
            ;;
    esac
done

# ======================================================
# if we passed the flag to stop and delete containers, we stop and delete containers and exit
if [ $STOP_AND_DELETE_CONTAINERS -eq 1 ]; then
    stop_containers
    delete_containers
    exit 0
fi

# ======================================================
# check if the instance number is OK
number_of_instances_validation $INSTANCES

# ======================================================
# check if the starting port is OK
starting_port_validation $STARTING_PORT 

END_PORT=`expr $STARTING_PORT + $INSTANCES - 1`

# ======================================================
# building image
show_in_yellow "[+] Building image..."
docker build --rm --file "dockerfile" --tag $IMAGE_NAME .

# ======================================================
# stopping and deleting existing containers
stop_containers
delete_containers

# ======================================================
# starting containers
echo ""
for i in $(seq $STARTING_PORT $END_PORT); do
    show_in_yellow "[+] Starting container $i..."
    docker run -d -p $i:80 --name $PROJECT_NAME-$i $IMAGE_NAME
done

