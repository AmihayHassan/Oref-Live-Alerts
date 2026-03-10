@echo off
title Local Home Front Command Proxy
echo ===================================================
echo    Starting Local Proxy Server (No installation)
echo ===================================================
echo.
echo Server is running in the background and fetching data...
echo Open the HTML file in your browser. To stop, close this window.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$port = 8080; $listener = New-Object System.Net.HttpListener; $listener.Prefixes.Add('http://localhost:'+$port+'/'); $listener.Start(); Write-Host 'Listening on http://localhost:'$port -ForegroundColor Green; while ($listener.IsListening) { try { $ctx = $listener.GetContext(); $req = $ctx.Request; $res = $ctx.Response; $res.Headers.Add('Access-Control-Allow-Origin', '*'); $res.Headers.Add('Content-Type', 'application/json; charset=utf-8'); $url = $req.QueryString['url']; if ($url) { try { $wc = New-Object System.Net.WebClient; $wc.Headers.Add('Referer', 'https://www.oref.org.il/heb'); $wc.Headers.Add('X-Requested-With', 'XMLHttpRequest'); $wc.Encoding = [System.Text.Encoding]::UTF8; $data = $wc.DownloadString($url); $bytes = [System.Text.Encoding]::UTF8.GetBytes($data); $res.OutputStream.Write($bytes, 0, $bytes.Length); } catch { $err = [System.Text.Encoding]::UTF8.GetBytes('[]'); $res.OutputStream.Write($err, 0, $err.Length); } } $res.Close(); } catch { break } }"
pause