#!/usr/bin/env bash
set -euo pipefail

# Projektstruktur ab include/ (plus restliche Ordner)
dirs=(
  "include/server"
  "src/core"
  "src/handlers"
  "src/tls"
  "src/util"
  "src/app"
  "config"
  "tests/unit"
  "tests/integration"
  "tools/bench"
  "tools/fuzz"
  "docs"
  "cmake"
)

for d in "${dirs[@]}"; do
  mkdir -p "$d"
done

# .gitkeep-Dateien, damit leere Ordner committet werden können
for d in "${dirs[@]}"; do
  touch "$d/.gitkeep"
done

# Beispiel-/Stub-Dateien
cat > CMakeLists.txt <<'EOF'
cmake_minimum_required(VERSION 3.20)
project(sentinel LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(server
  src/core/.gitkeep
  src/handlers/.gitkeep
  src/tls/.gitkeep
  src/util/.gitkeep
)
target_include_directories(server PUBLIC include)

add_executable(serverd src/app/main.cpp)
target_link_libraries(serverd PRIVATE server)
EOF

cat > src/app/main.cpp <<'EOF'
#include <iostream>
int main() {
  std::cout << "serverd bootstrap\n";
  return 0;
}
EOF

cat > config/server.example.yaml <<'EOF'
server:
  workers: { io: 4, cpu: 2 }
  timeouts: { header_ms: 5000, body_ms: 15000, idle_ms: 30000, write_ms: 15000 }
  limits: { header_bytes: 16384, body_bytes: 10485760, connections: 20000 }
  tls:
    enabled: false
routes: []
EOF

cat > docs/architecture.md <<'EOF'
# Architekturüberblick
- Library-Kern unter src/core, src/tls, src/util
- Handler-Erweiterungen unter src/handlers
- Dünne EXE unter src/app (Bootstrap, CLI)
- Öffentliche API-Header unter include/server
EOF

cat > .gitignore <<'EOF'
build/
.vscode/
.idea/
*.log
*.swp
EOF

echo "✅ Projekt-Skelett angelegt."

