#!/bin/bash

# Define a versão do Flutter a ser usada
FLUTTER_VERSION="3.9.2"

echo "Ajustando ambiente Linux (usando YUM)..."

# Adicionada a flag --allowerasing para resolver o conflito
yum install -y curl git unzip --allowerasing

echo "Baixando Flutter SDK..."
git clone https://github.com/flutter/flutter.git --depth 1 --branch $FLUTTER_VERSION /flutter

# Adiciona o Flutter ao PATH
export PATH="$PATH:/flutter/bin"

echo "Configurando Flutter..."
flutter precache
flutter config --enable-web

echo "Baixando dependências do projeto..."
flutter pub get