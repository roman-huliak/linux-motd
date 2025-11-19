# Linux MOTD

A customizable Message of the Day (MOTD) for Linux systems. This project provides dynamic system information displayed upon login, including system stats, uptime, and more. It enhances the terminal experience with colorful, informative banners.

## Features

- **Dynamic Content**: Displays real-time system information like load average, memory usage, and disk space.
- **SSH Integration**: Configurable to show MOTD via SSH banner.
- **Lightweight**: No heavy dependencies; uses standard Linux tools.
- **Customizable**: Easily modify scripts and templates.

## Prerequisites

- Root access (all commands must be run as root).
- A Debian-based or compatible Linux distribution (e.g., Ubuntu, Debian).
- Basic tools like `cp`, `nano`, and `systemctl` installed.

## Installation

Run the following commands **as root** to install the MOTD files. This will copy the necessary files to their standard locations, overwriting any existing files if present.

1. Clone the repository:
   ```
   git clone https://github.com/roman-huliak/linux-motd.git /tmp/linux-motd
   cd /tmp/linux-motd
   ```

2. Copy the MOTD script and templates (overwrites if files exist):
   ```
   cp -f etc/update-motd.d/10-system-status /etc/update-motd.d/10-system-status
   cp -f etc/issue.net /etc/issue.net
   chmod +x /etc/update-motd.d/10-system-status
   ```

3. Empty the default MOTD file to ensure only the custom content displays:
   ```
   truncate -s 0 /etc/motd
   ```

4. Run the MOTD update to generate the initial content:
   ```
   run-parts /etc/update-motd.d/
   ```

## Configure SSH to Display It

To display the MOTD as an SSH banner:

1. Edit the SSH configuration file:
   ```
   nano /etc/ssh/sshd_config
   ```

2. Find or add the following line and set it to:
   ```
   Banner /etc/issue.net
   ```

3. Save and exit the editor.

4. Restart the SSH service:
   ```
   systemctl restart sshd
   ```

Now, when users connect via SSH, they will see the custom MOTD banner before the login prompt.

## Usage

- **Local Login**: The MOTD will display automatically upon terminal login.
- **SSH Login**: After configuration, it shows as the SSH banner.
- **Regenerate MOTD**: Run `run-parts /etc/update-motd.d/` as root to refresh the content.

Example output:
```
% ssh user@example.com
WARNING: This system is for authorized use only.
All activities are monitored and logged.
Unauthorized access will be prosecuted.
------------------------------------------------------------
 Host: s1-prod-example
 Uptime: up 5 days, 23 hours, 33 minutes
 Load: 0.75 0.68 0.65
 CPU:   13th Gen Intel(R) Core(TM) i5-13500
 Mem:  26Gi/62Gi
 Disk: 363G/436G used (88%)
 Network: 50.90.50.200
 Security:
    Failed logins (24h): 94
    Pending updates:     0
------------------------------------------------------------
Linux s1-prod-example 6.1.0-41-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.158-1 (2025-11-09) x86_64
Last login: Wed Nov 19 23:15:39 2025 from 200.80.100.5
```


## Troubleshooting

- **No Output**: Ensure `run-parts /etc/update-motd.d/` runs without errors. Check permissions on `/etc/update-motd.d/`.
- **SSH Not Showing Banner**: Verify `Banner` is correctly set in `/etc/ssh/sshd_config` and SSH is restarted.

## Contributing

Contributions are welcome! Fork the repo, make changes, and submit a pull request. Focus on enhancing the script's features or adding support for other distros.

## License

This project is licensed under the MIT License