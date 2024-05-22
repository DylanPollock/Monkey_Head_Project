#!/bin/bash

# Change to the script's own directory
cd "$(dirname "$0")"

# Clear screen and set color
clear
echo -e "\033[0;32m[****|     09_KUBERNETES.sh - Kubernetes Management   |****]\033[0m"
echo

# Function to ensure the script is running with administrative privileges
ensureAdmin() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run this script as an administrator."
        exit 1
    fi
}

# Function to check the last command and exit if it failed
checkError() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed with error code $?."
        logError "$1"
        exit 1
    fi
}

# Function to log errors
logError() {
    echo "$(date) - Error: $1 failed with error code $?" >> "$(dirname "$0")/kubernetes_error_log.txt"
}

# Function to install Kubernetes tools if not already installed
installK8sTools() {
    echo "Checking for kubectl and Minikube installation..."
    if ! command -v kubectl &> /dev/null; then
        echo "Installing kubectl..."
        sudo apt-get update
        sudo apt-get install -y kubectl
        checkError "kubectl Installation"
    else
        echo "kubectl is already installed."
    fi

    if ! command -v minikube &> /dev/null; then
        echo "Installing Minikube..."
        sudo apt-get update
        sudo apt-get install -y minikube
        checkError "Minikube Installation"
    else
        echo "Minikube is already installed."
    fi
}

# Function to start Minikube
startMinikube() {
    echo "Starting Minikube..."
    minikube start
    checkError "Starting Minikube"
}

# Function to stop Minikube
stopMinikube() {
    echo "Stopping Minikube..."
    minikube stop
    checkError "Stopping Minikube"
}

# Function to check Minikube status
checkMinikubeStatus() {
    echo "Checking Minikube status..."
    minikube status > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Minikube is not running. Attempting to start..."
        startMinikube
    else
        echo "Minikube is running."
    fi
}

# Function to deploy application to Kubernetes
deployApp() {
    echo "Deploying application to Kubernetes..."
    # Add the command to apply Kubernetes configurations
    kubectl apply -f k8s/
    checkError "Deploying Application to Kubernetes"
}

# Function to get status of Kubernetes resources
getStatus() {
    echo "Getting status of Kubernetes resources..."
    kubectl get all --namespace=default
    checkError "Getting Kubernetes Resource Status"
}

# Function to delete Kubernetes resources
deleteResources() {
    echo "Deleting Kubernetes resources..."
    kubectl delete -f k8s/
    checkError "Deleting Kubernetes Resources"
}

# Function to describe Kubernetes pod for debugging
describePod() {
    read -p "Enter the name of the pod to describe: " podName
    if [ -z "$podName" ]; then
        echo "Pod name cannot be empty."
        exit 1
    fi
    echo "Describing pod $podName..."
    kubectl describe pod "$podName"
    checkError "Describing Kubernetes Pod"
}

# Function to get logs of a Kubernetes pod for debugging
getPodLogs() {
    read -p "Enter the name of the pod to get logs: " podName
    if [ -z "$podName" ]; then
        echo "Pod name cannot be empty."
        exit 1
    fi
    echo "Getting logs for pod $podName..."
    kubectl logs "$podName"
    checkError "Getting Kubernetes Pod Logs"
}

# Function to log Kubernetes management steps
logK8sStep() {
    echo "Logging Kubernetes management step: $1"
    echo "$(date) - $1" >> kubernetes_log.txt
}

# Ensure the script runs with administrative privileges
ensureAdmin

# Install Kubernetes tools if not already installed
installK8sTools

while true; do
    clear
    echo -e "\033[0;32m[****|     Kubernetes Management   |****]\033[0m"
    echo "[1] Start Minikube"
    echo "[2] Stop Minikube"
    echo "[3] Check Minikube Status"
    echo "[4] Deploy Application to Kubernetes"
    echo "[5] Get Status of Kubernetes Resources"
    echo "[6] Delete Kubernetes Resources"
    echo "[7] Describe a Kubernetes Pod"
    echo "[8] Get Logs of a Kubernetes Pod"
    echo "[E] Exit"
    echo
    read -p "Please select an option (1-8, E to exit): " action
    case "$action" in
        1) startMinikube ;;
        2) stopMinikube ;;
        3) checkMinikubeStatus ;;
        4) deployApp ;;
        5) getStatus ;;
        6) deleteResources ;;
        7) describePod ;;
        8) getPodLogs ;;
        [Ee]) break ;;
        *) echo "Invalid selection, please try again."
           sleep 2 ;;
    esac
done

echo -e "\033[0;32m[****| Kubernetes management complete! |****]\033[0m"
echo "Logs can be found in $(dirname "$0")/kubernetes_error_log.txt"
