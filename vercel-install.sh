#!/bin/bash

# Define a versão do Flutter a ser usada
FLUTTER_VERSION="3.22.2" # Opcional: fixe uma versão se desejar

echo "Ajustando ambiente Linux..."
apt-get update -y
apt-get install -y curl git unzip

echo "Baixando Flutter SDK..."
git clone https://github.com/flutter/flutter.git --depth 1 --branch $FLUTTER_VERSION /flutter

# Adiciona o Flutter ao PATH
export PATH="$PATH:/flutter/bin"

echo "Configurando Flutter..."
flutter precache
flutter config --enable-web

echo "Baixando dependências do projeto..."
flutter pub get