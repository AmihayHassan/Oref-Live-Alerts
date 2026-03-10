@echo off
:: ask for admin privileges if not already running as admin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting admin...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /B
)

title Oref Proxy + Auto Firewall
echo ===================================================
echo    Oref Proxy Server - Network Mode
echo ===================================================

set PORT=8080
set RULE_NAME=Oref_Proxy_Rule

:: run the PowerShell command to set up the firewall and start the server
powershell -NoProfile -ExecutionPolicy Bypass -Command "$port=%PORT%; $rule='%RULE_NAME%'; try { Write-Host 'Setting up Firewall...' -ForegroundColor Cyan; netsh advfirewall firewall delete rule name=$rule | Out-Null; netsh advfirewall firewall add rule name=$rule dir=in action=allow protocol=TCP localport=$port | Out-Null; $listener = New-Object System.Net.HttpListener; $listener.Prefixes.Add('http://+:'+$port+'/'); $listener.Start(); Write-Host '--- SERVER IS LIVE ---' -ForegroundColor Green; Write-Host 'Listening on http://*:'$port; while ($listener.IsListening) { $ctx = $listener.GetContext(); $req = $ctx.Request; $res = $ctx.Response; $res.Headers.Add('Access-Control-Allow-Origin', '*'); $res.Headers.Add('Content-Type', 'application/json; charset=utf-8'); $url = $req.QueryString['url']; if ($url) { try { $wc = New-Object System.Net.WebClient; $wc.Headers.Add('Referer', 'https://www.oref.org.il/heb'); $wc.Headers.Add('X-Requested-With', 'XMLHttpRequest'); $wc.Encoding = [System.Text.Encoding]::UTF8; $data = $wc.DownloadString($url); $bytes = [System.Text.Encoding]::UTF8.GetBytes($data); $res.OutputStream.Write($bytes, 0, $bytes.Length); } catch { $err = [System.Text.Encoding]::UTF8.GetBytes('[]'); $res.OutputStream.Write($err, 0, $err.Length); } } $res.Close(); } } finally { Write-Host 'Closing Port...' -ForegroundColor Red; netsh advfirewall firewall delete rule name=$rule | Out-Null; }"

pause