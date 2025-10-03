# 🚀 Развертывание P2P Relay Server на 144.31.198.54

Инструкция по развертыванию Agent Logger P2P Relay Server на вашем сервере.

## 📋 Предварительные требования

- Доступ к серверу `144.31.198.54` по SSH
- Права администратора (sudo)
- Интернет соединение на сервере

## 🚀 Быстрое развертывание (Docker)

### 1. Подключение к серверу

```bash
ssh root@144.31.198.54
# или
ssh username@144.31.198.54
```

### 2. Установка Docker

```bash
# Обновляем систему
sudo apt update && sudo apt upgrade -y

# Устанавливаем Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Добавляем пользователя в группу docker
sudo usermod -aG docker $USER

# Устанавливаем Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 3. Клонирование P2P репозитория

```bash
# Клонируем репозиторий
git clone https://github.com/timaZapadniy/agent_logger_p2p.git
cd agent_logger_p2p

# Проверяем файлы
ls -la
```

### 4. Запуск сервера

```bash
# Запускаем все сервисы
docker-compose up -d

# Проверяем статус
docker-compose ps

# Проверяем логи
docker-compose logs -f
```

### 5. Настройка файрвола

```bash
# Разрешаем необходимые порты
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw allow 8080/tcp  # P2P Relay Server

# Включаем файрвол
sudo ufw enable
```

## 🔧 Ручное развертывание (без Docker)

### 1. Установка Dart

```bash
# Добавляем репозиторий Dart
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list | sudo tee /etc/apt/sources.list.d/dart_stable.list

# Обновляем пакеты и устанавливаем Dart
sudo apt update
sudo apt install -y dart

# Проверяем установку
dart --version
```

### 2. Установка Nginx

```bash
# Устанавливаем Nginx
sudo apt install -y nginx

# Запускаем Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

### 3. Клонирование и настройка

```bash
# Клонируем репозиторий
git clone https://github.com/timaZapadniy/agent_logger_p2p.git
cd agent_logger_p2p

# Устанавливаем зависимости
dart pub get
```

### 4. Создание systemd сервиса

```bash
# Создаем файл сервиса
sudo tee /etc/systemd/system/agent-logger-p2p.service > /dev/null <<EOF
[Unit]
Description=Agent Logger P2P Relay Server
After=network.target

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=$(pwd)
ExecStart=/usr/lib/dart/bin/dart run bin/server.dart --port 8080 --host 0.0.0.0
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Перезагружаем systemd и запускаем сервис
sudo systemctl daemon-reload
sudo systemctl enable agent-logger-p2p
sudo systemctl start agent-logger-p2p

# Проверяем статус
sudo systemctl status agent-logger-p2p
```

### 5. Настройка Nginx

```bash
# Создаем конфигурацию
sudo tee /etc/nginx/sites-available/agent-logger > /dev/null <<EOF
server {
    listen 80;
    server_name 144.31.198.54;

    # Веб-клиент
    location / {
        root /var/www/agent-logger;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }

    # Прокси для P2P Relay Server
    location /ws {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # API endpoints
    location /api/ {
        proxy_pass http://localhost:8080/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Активируем сайт
sudo ln -s /etc/nginx/sites-available/agent-logger /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
```

## 🧪 Тестирование

### 1. Проверка сервера

```bash
# Проверяем доступность
curl http://144.31.198.54:8080

# Проверяем API
curl http://144.31.198.54:8080/api/devices
```

### 2. Проверка WebSocket

```bash
# Тестируем WebSocket
curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Sec-WebSocket-Key: test" -H "Sec-WebSocket-Version: 13" http://144.31.198.54:8080/ws?type=mobile
```

### 3. Проверка с локальной машины

```bash
# Запускаем тест подключения
cd /path/to/agent_logger
./test_server_connection.sh
```

## 🔍 Мониторинг

### Логи сервера

```bash
# Docker
docker-compose logs -f p2p-server

# Systemd
sudo journalctl -u agent-logger-p2p -f
```

### Статистика

```bash
# Проверяем подключенные устройства
curl http://144.31.198.54:8080/api/devices

# Проверяем активные сессии
curl http://144.31.198.54:8080/api/sessions
```

## 🛠️ Troubleshooting

### Проблема: Сервер не запускается

```bash
# Проверяем логи
docker-compose logs p2p-server
# или
sudo journalctl -u agent-logger-p2p -n 50

# Проверяем порт
sudo netstat -tulpn | grep :8080
```

### Проблема: Nginx не работает

```bash
# Проверяем конфигурацию
sudo nginx -t

# Проверяем статус
sudo systemctl status nginx

# Перезапускаем
sudo systemctl restart nginx
```

### Проблема: Файрвол блокирует

```bash
# Проверяем статус файрвола
sudo ufw status

# Разрешаем порт
sudo ufw allow 8080/tcp
```

## 🔄 Обновление

### Docker

```bash
cd agent_logger_p2p
git pull origin main
docker-compose down
docker-compose up -d --build
```

### Systemd

```bash
cd agent_logger_p2p
git pull origin main
dart pub get
sudo systemctl restart agent-logger-p2p
```

## 🎉 Готово!

После развертывания:

1. **Сервер будет доступен** по адресу `http://144.31.198.54:8080`
2. **API endpoints** будут работать
3. **WebSocket соединения** будут приниматься
4. **Мобильные приложения** смогут подключаться
5. **Веб-клиенты** смогут получать логи

**Следующие шаги:**
1. Запустите мобильное приложение
2. Запустите веб-клиент
3. Подключитесь и протестируйте передачу логов

---

**Удачного развертывания! 🚀**
