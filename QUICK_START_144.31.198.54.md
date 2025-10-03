# ⚡ Быстрый старт - Agent Logger для 144.31.198.54

## 🎯 Что нужно сделать

1. **Развернуть P2P сервер** на `144.31.198.54`
2. **Настроить мобильное приложение** для подключения к серверу
3. **Настроить веб-клиент** для получения логов

## 🚀 Шаг 1: Развертывание сервера

### Подключитесь к серверу
```bash
ssh root@144.31.198.54
```

### Установите Docker
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Запустите P2P сервер
```bash
git clone https://github.com/timaZapadniy/agent_logger_p2p.git
cd agent_logger_p2p
docker-compose up -d
```

### Откройте порты
```bash
sudo ufw allow 8080/tcp
sudo ufw allow 80/tcp
sudo ufw enable
```

## 📱 Шаг 2: Настройка мобильного приложения

### Запустите приложение
```bash
cd example
flutter run
```

### Проверьте подключение
1. Встряхните устройство
2. Посмотрите на иконку в AppBar (синяя = подключен)
3. Скопируйте Session ID

## 🌐 Шаг 3: Настройка веб-клиента

### Запустите веб-клиент
```bash
cd web_client
flutter run -d chrome
```

### Подключитесь
1. Откройте `http://144.31.198.54:8080`
2. Введите Session ID с мобильного устройства
3. Нажмите "Connect"
4. Логи появятся в реальном времени!

## 🧪 Тестирование

### Проверьте сервер
```bash
curl http://144.31.198.54:8080
curl http://144.31.198.54:8080/api/devices
```

### Проверьте подключение
```bash
./test_server_connection.sh
```

## 🔧 Конфигурация

### Мобильное приложение
```dart
// example/lib/config.dart
static const String p2pServerUrl = 'http://144.31.198.54:8080';
```

### Веб-клиент
```dart
// web_client/lib/config.dart
static const String serverUrl = '144.31.198.54:8080';
```

## 🎉 Готово!

Теперь Agent Logger работает с вашим сервером `144.31.198.54:8080`!

**URL для проверки:**
- Сервер: `http://144.31.198.54:8080`
- API: `http://144.31.198.54:8080/api/devices`
- WebSocket: `ws://144.31.198.54:8080/ws`

---

**Удачного использования! 🚀**
