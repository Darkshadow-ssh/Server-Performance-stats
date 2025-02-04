#!/bin/bash

# Clear the terminal
clear
echo -e "  

╔═╗┌─┐┬─┐┬  ┬┌─┐┬─┐  ╔═╗┌─┐┬─┐┌─┐┌─┐┬─┐┌┬┐┌─┐┌┐┌┌─┐┌─┐  ╔═╗┌┬┐┌─┐┌┬┐┌─┐
╚═╗├┤ ├┬┘└┐┌┘├┤ ├┬┘  ╠═╝├┤ ├┬┘├┤ │ │├┬┘│││├─┤││││  ├┤   ╚═╗ │ ├─┤ │ └─┐
╚═╝└─┘┴└─ └┘ └─┘┴└─  ╩  └─┘┴└─└  └─┘┴└─┴ ┴┴ ┴┘└┘└─┘└─┘  ╚═╝ ┴ ┴ ┴ ┴ └─┘

[+] Author: Sarthak Chauhan
[+] Twitter: @sarthakchauhan
[+] Description: Monitors and visualizes key server metrics like CPU, memory, and disk I/O.
                 Provides realtime insights into server health and performance."
#Get Date
date=$(date)

#Get HOSTNAME
cmpname=$(hostname)

#System UPTIME
timing=$(uptime)

# Get CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')

# Get memory usage
memory_usage=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')

# Get disk usage
disk_usage=$(df -h / | awk 'NR==2{print $5}')

#TOP 5 process 
top_cpu_processes() {

    echo "Top 5 Processes by CPU Usage"

    echo "----------------------------------------------------"

    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

    echo "----------------------------------------------------"
}


# Function to display top 5 processes by Memory usage
top_memory_processes() {

    echo "Top 5 Processes by Memory Usage"

    echo "----------------------------------------------------"

    ps -eo pid,comm,%mem --sort=-%mem | head -n 6

    echo "----------------------------------------------------"

}

# Failed Login attempts

# Define log file location based on the OS type
if [ -f /var/log/auth.log ]; then
    LOGFILE="/var/log/auth.log"
elif [ -f /var/log/secure ]; then
    LOGFILE="/var/log/secure"
else
    echo "Error: Authentication log file not found."
    exit 1
fi

# Function to display failed login attempts
check_failed_logins() {
    echo "Failed Login Attempts:"
    echo "----------------------------------------------------"
    # Extract failed login attempts and count them
    grep "Failed password" $LOGFILE | awk '{print $9}' | sort | uniq -c | sort -nr
    echo "----------------------------------------------------"
}

# Get network statistics
network_stats=$(ifconfig eth0 | grep "RX packets\|TX packets")
echo "--------------------------------------------------------------------------------------------------"
echo "Date and Time of Stats: $date"
echo "********************************"
echo "Host Name: $cmpname"
echo "********************************"
echo "System Uptime & Avg System Load: $timing"
echo "********************************"
echo "CPU Usage: $cpu_usage"
echo "********************************"
echo "Memory Usage: $memory_usage"
echo "********************************"
echo "Disk Usage: $disk_usage"
echo "********************************"
echo "Network Statistics:"
echo "$network_stats"
echo "********************************"
top_cpu_processes
top_memory_processes
echo "********************************"
check_failed_logins
echo "---------------------------------------------------------------------------------------------------"
