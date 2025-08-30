#!/bin/bash

# AutoPPTGenerator Start Script
# This script handles starting the Flask application with proper error handling

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project directory
PROJECT_DIR="/work/tanmay/TDS/AutoPPTGenerator"
VENV_PATH="$PROJECT_DIR/.venv"
PYTHON_PATH="$VENV_PATH/bin/python"
APP_FILE="$PROJECT_DIR/app.py"
LOG_FILE="$PROJECT_DIR/app.log"
PID_FILE="$PROJECT_DIR/app.pid"

# Function to print colored output
print_status() {
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

# Function to check if app is running
is_running() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            return 0
        else
            rm -f "$PID_FILE"
            return 1
        fi
    fi
    return 1
}

# Function to start the application
start_app() {
    print_status "Starting AutoPPTGenerator..."
    
    # Check if already running
    if is_running; then
        print_warning "Application is already running (PID: $(cat $PID_FILE))"
        print_status "Local access: http://localhost:7777"
        print_status "Remote access: http://84.247.184.189:7777"
        exit 0
    fi
    
    # Change to project directory
    cd "$PROJECT_DIR"
    
    # Check if virtual environment exists
    if [ ! -f "$PYTHON_PATH" ]; then
        print_error "Virtual environment not found at $VENV_PATH"
        print_status "Please run: python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt"
        exit 1
    fi
    
    # Check if app.py exists
    if [ ! -f "$APP_FILE" ]; then
        print_error "Application file not found at $APP_FILE"
        exit 1
    fi
    
    # Create necessary directories
    mkdir -p uploads generated
    
    # Start the application in background
    print_status "Starting Flask application..."
    nohup "$PYTHON_PATH" app.py > "$LOG_FILE" 2>&1 &
    
    # Save PID
    echo $! > "$PID_FILE"
    
    # Wait a moment and check if it started successfully
    sleep 2
    
    if is_running; then
        print_success "AutoPPTGenerator started successfully!"
        print_success "PID: $(cat $PID_FILE)"
        print_success "Local access: http://localhost:7777"
        print_success "Remote access: http://84.247.184.189:7777"
        print_status "Logs are being written to: $LOG_FILE"
        print_status "To stop the application, run: ./start.sh stop"
    else
        print_error "Failed to start the application"
        print_status "Check the logs at: $LOG_FILE"
        exit 1
    fi
}

# Function to stop the application
stop_app() {
    print_status "Stopping AutoPPTGenerator..."
    
    if is_running; then
        local pid=$(cat "$PID_FILE")
        print_status "Stopping process with PID: $pid"
        kill "$pid"
        rm -f "$PID_FILE"
        print_success "Application stopped successfully"
    else
        print_warning "Application is not running"
    fi
}

# Function to restart the application
restart_app() {
    print_status "Restarting AutoPPTGenerator..."
    stop_app
    sleep 2
    start_app
}

# Function to show status
show_status() {
    if is_running; then
        local pid=$(cat "$PID_FILE")
        print_success "AutoPPTGenerator is running (PID: $pid)"
        print_status "Local access: http://localhost:7777"
        print_status "Remote access: http://84.247.184.189:7777"
        print_status "Log file: $LOG_FILE"
    else
        print_warning "AutoPPTGenerator is not running"
    fi
}

# Function to show logs
show_logs() {
    if [ -f "$LOG_FILE" ]; then
        print_status "Showing last 50 lines of logs (Press Ctrl+C to exit):"
        tail -f -n 50 "$LOG_FILE"
    else
        print_warning "Log file not found at $LOG_FILE"
    fi
}

# Function to show help
show_help() {
    echo "AutoPPTGenerator Management Script"
    echo ""
    echo "Usage: $0 {start|stop|restart|status|logs|help}"
    echo ""
    echo "Commands:"
    echo "  start   - Start the AutoPPTGenerator application"
    echo "  stop    - Stop the AutoPPTGenerator application"
    echo "  restart - Restart the AutoPPTGenerator application"
    echo "  status  - Show application status"
    echo "  logs    - Show application logs (real-time)"
    echo "  help    - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 status"
    echo "  $0 logs"
}

# Main script logic
case "${1:-start}" in
    start)
        start_app
        ;;
    stop)
        stop_app
        ;;
    restart)
        restart_app
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
