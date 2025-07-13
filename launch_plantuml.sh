#!/bin/bash

# PlantUML Server Launch Script
# Usage: ./plantuml-server.sh [version]
# Example: ./plantuml-server.sh 1.2025.4

set -e

# Configuration
DEFAULT_VERSION="1.2025.4"
PORT=8081
PICOWEB_ARGS="-picoweb:${PORT}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Java is installed
check_java() {
    if ! command -v java &> /dev/null; then
        print_error "Java is not installed or not in PATH"
        print_info "Please install Java Runtime Environment (JRE) version 8 or higher"
        exit 1
    fi
    
    java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
    print_info "Java version: $java_version"
}

# Function to find existing PlantUML jar
find_plantuml_jar() {
    local jar_files=(plantuml-*.jar)
    
    # Check if any jar files exist
    if [ -e "${jar_files[0]}" ]; then
        # Return the first found jar file
        echo "${jar_files[0]}"
        return 0
    else
        return 1
    fi
}

# Function to download PlantUML jar
download_plantuml() {
    local version=$1
    local jar_name="plantuml-${version}.jar"
    local download_url="https://github.com/plantuml/plantuml/releases/download/v${version}/${jar_name}"
    
    print_info "Downloading PlantUML GPL version ${version}..."
    print_info "URL: ${download_url}"
    
    if command -v curl &> /dev/null; then
        curl -L -o "${jar_name}" "${download_url}"
    elif command -v wget &> /dev/null; then
        wget -O "${jar_name}" "${download_url}"
    else
        print_error "Neither curl nor wget is available for downloading"
        exit 1
    fi
    
    # Verify download
    if [ ! -f "${jar_name}" ] || [ ! -s "${jar_name}" ]; then
        print_error "Download failed or file is empty"
        exit 1
    fi
    
    print_success "Downloaded ${jar_name}"
    echo "${jar_name}"
}

# Function to start PlantUML server
start_server() {
    local jar_file=$1
    
    print_info "Starting PlantUML PicoWeb server..."
    print_info "JAR file: ${jar_file}"
    print_info "Port: ${PORT}"
    print_info "Command: java -jar ${jar_file} ${PICOWEB_ARGS}"
    
    # Start server with nohup, redirect stderr to /dev/null
    nohup java -jar "${jar_file}" ${PICOWEB_ARGS} > plantuml-server.log 2>/dev/null &
    local pid=$!
    
    # Wait a moment to ensure the process started
    sleep 2
    
    # Check if process is still running
    if kill -0 $pid 2>/dev/null; then
        print_success "PlantUML server started successfully!"
        echo ""
        print_info "Server Details:"
        echo "  - Process ID (PID): $pid"
        echo "  - Port: ${PORT}"
        echo "  - URL: http://localhost:${PORT}"
        echo "  - Log file: plantuml-server.log"
        echo ""
        print_info "Test the server:"
        echo "  curl http://localhost:${PORT}"
        echo "  or visit http://localhost:${PORT} in your browser"
        echo ""
        print_warning "To stop the server:"
        echo "  kill $pid"
        echo "  or"
        echo "  pkill -f 'java.*plantuml.*picoweb'"
        echo ""
        
        # Save PID to file for easier management
        echo $pid > plantuml-server.pid
        print_info "PID saved to plantuml-server.pid"
    else
        print_error "Server failed to start"
        exit 1
    fi
}

# Main script execution
main() {
    local version="${1:-$DEFAULT_VERSION}"
    
    print_info "PlantUML Server Launch Script"
    print_info "Version to use: ${version}"
    echo ""
    
    # Check if Java is available
    check_java
    
    # Check for existing PlantUML jar
    print_info "Checking for existing PlantUML jar files..."
    
    if jar_file=$(find_plantuml_jar); then
        print_success "Found existing PlantUML jar: ${jar_file}"
        
        # Ask user if they want to use existing jar or download new one
        if [ "$#" -eq 0 ]; then
            print_info "Using existing jar file"
        else
            print_warning "Version specified but jar exists. Using existing: ${jar_file}"
        fi
    else
        print_info "No PlantUML jar found in current directory"
        print_info "Downloading version ${version}..."
        jar_file=$(download_plantuml "${version}")
    fi
    
    # Check if server is already running
    if [ -f "plantuml-server.pid" ]; then
        local existing_pid=$(cat plantuml-server.pid)
        if kill -0 $existing_pid 2>/dev/null; then
            print_warning "PlantUML server appears to be already running (PID: $existing_pid)"
            print_info "To stop it: kill $existing_pid"
            exit 1
        else
            print_info "Removing stale PID file"
            rm -f plantuml-server.pid
        fi
    fi
    
    # Start the server
    start_server "${jar_file}"
}

# Run main function with all arguments
main "$@"
