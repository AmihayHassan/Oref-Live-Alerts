@echo off
title Local Home Front Command Proxy
echo ===================================================
echo    Starting Local Proxy Server (No installation)
echo ===================================================
echo.
echo Server is running in the background and fetching data...
echo Open the HTML file in your browser. To stop, close this window.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$p='8080';$l=New-Object System.Net.HttpListener;$l.Prefixes.Add('http://localhost:'+$p+'/');try{$l.Start();Write-Host \"`nServer running on http://localhost:$p\" -ForegroundColor Green;Write-Host 'Open the HTML file in your browser. To stop, close this window.'}catch{$ts=Get-Date -Format 'yyyy-MM-dd HH:mm:ss';$e='Startup Error: '+$_.Exception.Message;Write-Host $e -ForegroundColor Red;$ts+' - '+$e | Out-File 'server_log.txt' -Append;pause;exit};while($l.IsListening){try{$c=$l.GetContext();$s=$c.Response;$s.Headers.Add('Access-Control-Allow-Origin','*');$s.Headers.Add('Content-Type','application/json; charset=utf-8');$u=$c.Request.QueryString['url'];if($u){try{$w=New-Object System.Net.WebClient;$w.Headers.Add('Referer','https://www.oref.org.il/heb');$w.Headers.Add('X-Requested-With','XMLHttpRequest');$w.Encoding=[System.Text.Encoding]::UTF8;$d=$w.DownloadString($u);$b=[System.Text.Encoding]::UTF8.GetBytes($d);$s.OutputStream.Write($b,0,$b.Length)}catch{$ts=Get-Date -Format 'yyyy-MM-dd HH:mm:ss';$ts+' - API Error: '+$_.Exception.Message | Out-File 'server_log.txt' -Append;$eb=[System.Text.Encoding]::UTF8.GetBytes('[]');$s.OutputStream.Write($eb,0,$eb.Length)}};$s.Close()}catch{$ts=Get-Date -Format 'yyyy-MM-dd HH:mm:ss';$ts+' - System Error: '+$_.Exception.Message | Out-File 'server_log.txt' -Append;Start-Sleep -Seconds 2}}"
pause