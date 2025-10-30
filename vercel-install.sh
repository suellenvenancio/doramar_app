#!/bin/bash

# Define a versão do Flutter a ser usada
FLUTTER_VERSION="stable" # <-- MUDANÇA ESTÁ AQUI

#!/bin/bash
# filepath: /Users/suellenvenanciodasilva/Documents/test/build-vercel.sh

# Instalar Flutter se não estiver disponível
if ! command -v flutter &> /dev/null; then
    echo "Flutter não encontrado, instalando..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
    export PATH="$PWD/flutter/bin:$PATH"
fi

# Verificar versão do Flutter
flutter --version

# Habilitar web
flutter config --enable-web

# Instalar dependências
flutter pub get

# Build para web
flutter build web --release --web-renderer html

echo "Build concluído!"