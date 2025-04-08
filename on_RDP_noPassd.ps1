# 1.执行策略允许运行脚本
Set-ExecutionPolicy Unrestricted

# 2.开启远程桌面功能
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0

# 3.禁用网络级别身份验证
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 0

# 4.创建一个新的防火墙规则，命名为 "Allow RDP"。允许远程桌面协议 (RDP) 使用的端口 3389 的入站 TCP 流量
netsh advfirewall firewall add rule name="Allow RDP" protocol=TCP dir=in localport=3389 action=allow

# 5.创建一个新的注册表项，设置远程桌面不使用密码进行身份验证
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fPromptForPassword /t REG_DWORD /d 0 /f

# 6.修改注册表项以允许空密码的用户通过远程桌面进行登录
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f

# 7.查询远程桌面是否运行
netstat -an | Select-String "3389"

# 8.获取当前主机名对应的所有 IP 地址
$ips = [System.Net.Dns]::GetHostAddresses($env:COMPUTERNAME) | Where-Object { $_.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork }
foreach ($ip in $ips) {
    Write-Output "local IP address：$ip"
}

# 获取的是 Windows 实际认证的用户名
$username = $env:UserName
Write-Output "Current username: $username"

