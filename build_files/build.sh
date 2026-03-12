#!/bin/bash
set -ouex pipefail

echo "=== Инициализация сборки HavenOS ==="

# 1. Подключаем репозиторий CachyOS
# Это необходимо для скачивания оптимизированного ядра для твоего Ryzen 9800X3D
curl -Lo /etc/yum.repos.d/cachyos.repo https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-fedora-$(rpm -E %fedora).repo

# 2. Замена ядра (Core Swap)
# Вырезаем стандартное ядро Linux и ставим CachyOS
rpm-ostree override remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra \
    --install kernel-cachyos

# 3. Установка критических пакетов HavenOS
# scx-scheds: BPF-планировщики для Ryzen 9800X3D
# i2c-tools: доступ к шине SMBus для OpenRGB (управление подсветкой ASUS)
# nvidia-open-dkms: открытые модули для RTX 5080 (Blackwell)
rpm-ostree install scx-scheds i2c-tools nvidia-open-dkms

# 4. Ребрендинг (Перезаписываем метаданные системы)
sed -i 's/^NAME=.*/NAME="Haven"/' /usr/lib/os-release
sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="HavenOS"/' /usr/lib/os-release
sed -i 's/^ID=.*/ID=havenos/' /usr/lib/os-release

echo "=== Сборка HavenOS успешно сконфигурирована ==="
