# Basic Scripting

A bash script for automated deployment and configuration of a PHP web application with Apache2 and MySQL.

## Overview

This repository contains a deployment script (`main.sh`) that automates the setup of a web application environment. The script handles:

- Installation of required packages (Apache2, PHP, MySQL)
- Cloning a GitHub repository
- Database setup and user creation
- Environment configuration
- Apache2 web server configuration

## Prerequisites

- Linux system with sudo privileges
- Internet connection for package installation and repository cloning
- Bash shell

## Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/nielxfb/basic-scripting.git
   cd basic-scripting
   ```

2. Make the script executable:
   ```bash
   chmod +x main.sh
   ```

3. Run the deployment script:
   ```bash
   ./main.sh
   ```

## What the Script Does

### Package Installation
The script installs the following packages:
- `apache2` - Web server
- `php` - PHP runtime
- `php-mysqli` - MySQL extension for PHP
- `mysql-server` - MySQL database server
- `git` - Version control system

### Repository Setup
- Clones the target repository: `WillyWinata/CoreTraining-NetworkBP-WWonKHa`
- Sets proper ownership for web server access

### Database Configuration
- Creates a MySQL user: `DanielAdamlu` with password `T047`
- Creates database: `wonka`
- Imports database schema from `wonka.sql`

### Environment Configuration
- Updates `.env` file with database credentials
- Configures Apache2 DocumentRoot
- Reloads Apache2 service

### Web Server Setup
- Moves application files to `/var/www/`
- Updates Apache2 configuration
- Reloads the web server

## Configuration Variables

The script uses the following configurable variables:

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `GITHUB_REPO` | `https://github.com/WillyWinata/CoreTraining-NetworkBP-WWonKHa` | Target repository URL |
| `DB_USER` | `DanielAdamlu` | MySQL username |
| `DB_PASS` | `T047` | MySQL password |
| `DB_NAME` | `wonka` | Database name |
| `CONF_FILE` | `/etc/apache2/sites-available/000-default.conf` | Apache configuration file |

## Security Notes

⚠️ **Warning**: This script contains hardcoded credentials and is intended for development/testing purposes only. For production use:

- Use environment variables for sensitive data
- Implement proper secret management
- Follow security best practices for database access
- Use strong, unique passwords

## Cleanup

The script includes a cleanup function that:
- Restarts Apache2 and MySQL services
- Removes previously downloaded repository files
- Removes web server files and configurations
- Drops the existing database (if any)

This ensures a clean installation on each run.

## Troubleshooting

### Common Issues

1. **Permission denied**: Ensure you have sudo privileges
2. **Package installation fails**: Check internet connection and package repositories
3. **MySQL connection issues**: Verify MySQL service is running
4. **File not found errors**: Ensure the target repository contains required files (`wonka.sql`, `.env`)

### Log Output

The script provides informative output during execution. If issues occur, check:
- System package manager logs
- MySQL error logs
- Apache2 error logs
