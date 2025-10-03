# P2P Setup Guide - Agent Logger

Полное руководство по настройке P2P системы для Agent Logger с центральным relay сервером.

## 🏗️ Архитектура

```
┌─────────────────┐                    ┌─────────────────┐
│  Mobile Device  │                    │   Web Client    │
│  (Flutter App)  │                    │  (Flutter Web)  │
│                 │                    │                 │
│  🔌 WebSocket   │◄──────────────────►│  WebSocket      │
│  (type=mobile)  │                    │  (type=web)     │
└─────────────────┘                    └─────────────────┘
         │                                       │
         └─────────────────┬─────────────────────┘
                           │
                    ┌─────────────────┐
                    │  P2P Relay      │
                    │  Server         │
                    │  (Dart Server)  │
                    └─────────────────┘
```

## 🚀 Быстрый старт

### 1. Запуск P2P Relay сервера

```bash
# Перейти в директорию проекта
cd /path/to/agent_logger

# Запустить скрипт
./scripts/start_p2p_server.sh
```

Или вручную:

```bash
cd p2p_relay_server
dart pub get
dart run bin/server.dart --port 8080
```

Сервер будет доступен по адресу: `http://localhost:8080`

### 2. Настройка мобильного приложения

В вашем Flutter приложении:

```dart
import 'package:agent_logger/agent_logger.dart';

void main() {
  runApp(
    MaterialApp(
      home: AgentLogger(
        enable: true,
        shakeThresholdGravity: 2.7,
        // Подключение к P2P relay серверу
        p2pServerUrl: 'http://YOUR_SERVER_IP:8080',
        child: MyApp(),
      ),
    ),
  );
}
```

### 3. Подключение веб-клиента

1. Откройте веб-клиент: `http://localhost:8080` (или ваш сервер)
2. Выберите режим "Relay Server"
3. Введите адрес сервера: `YOUR_SERVER_IP:8080`
4. Введите Session ID с мобильного устройства
5. Нажмите "Connect"

## 📱 Использование

### На мобильном устройстве

1. **Откройте приложение** с Agent Logger
2. **Встряхните устройство** для открытия логгера
3. **Нажмите на иконку облака** 📶 в AppBar (синяя иконка = подключен к relay серверу)
4. **Скопируйте Session ID** из QR кода или информации о подключении
5. **Поделитесь Session ID** с веб-клиентом

### В веб-клиенте

1. **Откройте веб-клиент** в браузере
2. **Выберите "Relay Server"** режим
3. **Введите адрес сервера** (например: `192.168.1.100:8080`)
4. **Введите Session ID** с мобильного устройства
5. **Нажмите "Connect"**
6. **Логи появятся в реальном времени!**

## 🔧 Конфигурация

### P2P Relay Server

#### Параметры командной строки

```bash
dart run bin/server.dart [options]

Options:
  -p, --port <port>        Server port (default: 8080)
  -h, --host <host>        Server host (default: 0.0.0.0)
  -v, --verbose            Enable verbose logging
  --help                   Show help message
```

#### Переменные окружения

```bash
export P2P_SERVER_HOST=192.168.1.100
export P2P_SERVER_PORT=3000
export P2P_SERVER_VERBOSE=true
dart run bin/server.dart
```

### Мобильное приложение

#### Прямое подключение к relay серверу

```dart
// В main.dart или где инициализируете AgentLogger
final p2pServer = P2PServer();
await p2pServer.start(relayServerUrl: 'http://192.168.1.100:8080');
```

#### Локальный P2P сервер (без relay)

```dart
// Для прямого подключения без relay сервера
final p2pServer = P2PServer();
await p2pServer.start(); // Запустит локальный сервер
```

### Веб-клиент

#### Режимы подключения

1. **Relay Server** - через P2P relay сервер (рекомендуется)
2. **Direct P2P** - прямое подключение к мобильному устройству

## 🌐 Сетевые требования

### Для Relay Server

- **Порт 8080** (или выбранный) должен быть открыт
- **Все устройства** должны быть в одной сети или иметь доступ к серверу
- **Фаервол** должен разрешать входящие соединения

### Для Direct P2P

- **Мобильное устройство** и **веб-клиент** должны быть в одной WiFi сети
- **Порт 8080** (или выбранный) должен быть свободен на мобильном устройстве
- **Фаервол** может блокировать подключения

## 🔍 Troubleshooting

### Проблема: Не могу подключиться к relay серверу

**Решение:**
1. Проверьте что сервер запущен: `http://YOUR_SERVER_IP:8080`
2. Проверьте правильность IP адреса
3. Проверьте фаервол на сервере
4. Проверьте логи сервера

### Проблема: Веб-клиент не получает логи

**Решение:**
1. Убедитесь что мобильное устройство подключено к relay серверу
2. Проверьте правильность Session ID
3. Проверьте что мобильное приложение отправляет логи
4. Проверьте консоль браузера на ошибки

### Проблема: QR код не генерируется

**Решение:**
1. Убедитесь что мобильное устройство подключено к серверу
2. Проверьте что P2P сервер запущен
3. Перезапустите P2P сервер
4. Проверьте логи приложения

### Проблема: Высокое потребление ресурсов

**Решение:**
1. Ограничьте количество логов в мобильном приложении
2. Используйте фильтрацию логов
3. Реализуйте ротацию логов
4. Увеличьте ресурсы сервера

## 📊 Мониторинг

### Веб-интерфейс сервера

Откройте `http://YOUR_SERVER_IP:8080` для просмотра:
- Статистики подключений
- Списка устройств
- API документации

### Логи сервера

```bash
# Запуск с подробным логированием
dart run bin/server.dart --verbose

# Логи показывают:
# - Подключения устройств
# - Ошибки соединения
# - Статистику трафика
```

### API Endpoints

- `GET /` - Главная страница
- `GET /devices` - Список устройств
- `GET /sessions` - Список сессий
- `GET /session/{id}` - Информация о сессии

## 🔐 Безопасность

### Рекомендации

1. **Используйте только в доверенной сети**
2. **Настройте фаервол** для ограничения доступа
3. **Используйте HTTPS/WSS** в production
4. **Добавьте аутентификацию** при необходимости

### Пример с аутентификацией

```dart
// TODO: Будет добавлено в следующей версии
final server = P2PServer();
await server.start(
  relayServerUrl: 'http://192.168.1.100:8080',
  authToken: 'your-secret-token',
);
```

## 🚀 Production Deployment

### Docker

```dockerfile
FROM dart:stable AS build
WORKDIR /app
COPY p2p_relay_server/ .
RUN dart pub get
RUN dart compile exe bin/server.dart -o server

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=build /app/server /usr/local/bin/
EXPOSE 8080
CMD ["server", "--port", "8080"]
```

### Systemd Service

```ini
[Unit]
Description=P2P Relay Server for Agent Logger
After=network.target

[Service]
Type=simple
User=p2p-server
WorkingDirectory=/opt/p2p-relay-server
ExecStart=/usr/local/bin/server --port 8080
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

## 📚 Примеры использования

### Разработка

```bash
# Запуск сервера для разработки
./scripts/start_p2p_server.sh

# В мобильном приложении
final p2pServer = P2PServer();
await p2pServer.start(relayServerUrl: 'http://localhost:8080');
```

### Тестирование

```bash
# Запуск на другом порту
dart run bin/server.dart --port 3000

# В веб-клиенте используйте localhost:3000
```

### Production

```bash
# Запуск на production сервере
dart run bin/server.dart --host 0.0.0.0 --port 8080

# В мобильном приложении используйте IP сервера
final p2pServer = P2PServer();
await p2pServer.start(relayServerUrl: 'http://YOUR_PRODUCTION_IP:8080');
```

## 🤝 Поддержка

- **Issues**: [GitHub Issues](https://github.com/your-repo/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-repo/discussions)
- **Email**: support@example.com

---

**🎉 Наслаждайтесь P2P системой Agent Logger!**
