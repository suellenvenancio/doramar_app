#!/bin/bash 
FLUTTER_VERSION="stable"

echo "Ajustando ambiente Linux (usando YUM)..."
yum install -y curl git unzip --allowerasing

echo "Baixando Flutter SDK (versão $FLUTTER_VERSION)..."
git clone https://github.com/flutter/flutter.git --depth 1 --branch $FLUTTER_VERSION /flutter

echo "Configurando Flutter (usando caminho absoluto)..."
/flutter/bin/flutter precache
/flutter/bin/flutter config --enable-web

echo "Baixando dependências do projeto (usando caminho absoluto)..."
/flutter/bin/flutter pub get