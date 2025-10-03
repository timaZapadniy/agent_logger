#!/bin/bash

# Test script for Agent Logger P2P Relay Server
# Server: 144.31.198.54:8080

echo "🔍 Testing Agent Logger P2P Relay Server Connection"
echo "Server: 144.31.198.54:8080"
echo "=================================================="

# Test 1: Basic HTTP connectivity
echo "1. Testing HTTP connectivity..."
if curl -s --connect-timeout 10 http://144.31.198.54:8080 > /dev/null; then
    echo "   ✅ HTTP connection successful"
else
    echo "   ❌ HTTP connection failed"
    exit 1
fi

# Test 2: API endpoints
echo "2. Testing API endpoints..."

# Test devices endpoint
echo "   Testing /api/devices..."
if curl -s --connect-timeout 10 http://144.31.198.54:8080/api/devices > /dev/null; then
    echo "   ✅ /api/devices endpoint accessible"
else
    echo "   ❌ /api/devices endpoint failed"
fi

# Test sessions endpoint
echo "   Testing /api/sessions..."
if curl -s --connect-timeout 10 http://144.31.198.54:8080/api/sessions > /dev/null; then
    echo "   ✅ /api/sessions endpoint accessible"
else
    echo "   ❌ /api/sessions endpoint failed"
fi

# Test 3: WebSocket connectivity (basic test)
echo "3. Testing WebSocket connectivity..."
if curl -i -N --connect-timeout 10 -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Sec-WebSocket-Key: test" -H "Sec-WebSocket-Version: 13" http://144.31.198.54:8080/ws?type=mobile 2>/dev/null | grep -q "101 Switching Protocols"; then
    echo "   ✅ WebSocket connection successful"
else
    echo "   ❌ WebSocket connection failed"
fi

# Test 4: Server response time
echo "4. Testing server response time..."
response_time=$(curl -o /dev/null -s -w '%{time_total}' http://144.31.198.54:8080)
echo "   Response time: ${response_time}s"

# Test 5: Server information
echo "5. Getting server information..."
echo "   Server info:"
curl -s http://144.31.198.54:8080/api/devices | python3 -m json.tool 2>/dev/null || echo "   No devices connected"

echo ""
echo "=================================================="
echo "🎉 Server connection test completed!"
echo ""
echo "Next steps:"
echo "1. Run mobile app: cd example && flutter run"
echo "2. Run web client: cd web_client && flutter run -d chrome"
echo "3. Connect and test log streaming"
echo ""
echo "Server URL: http://144.31.198.54:8080"
echo "WebSocket URL: ws://144.31.198.54:8080"
