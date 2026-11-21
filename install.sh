#!/usr/bin/env bash
# ==============================================================================
# Workstation Setup - Ubuntu/Debian XFCE Power Desktop
# ==============================================================================
# Automatiza a replicação exata do ambiente de produtividade:
# - Padronização de aplicativos e desvio DBus
# - Ocultação de apps redundantes (GNOME/KDE/XFCE)
# - Utilitários: Quick Look, Meu Computador, Launchpad, Hub de Ferramentas,
#               Print Tradutor, Clipboard History, Mission Control
# - Configurações de tema, atalhos globais e autostart
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$HOME"
LOCAL_BIN="$USER_HOME/.local/bin"
LOCAL_APPS="$USER_HOME/.local/share/applications"
LOCAL_DBUS="$USER_HOME/.local/share/dbus-1/services"
CONFIG_DIR="$USER_HOME/.config"

echo "=========================================================="
echo "  Iniciando Setup da Estação de Trabalho XFCE Power Desktop"
echo "  Usuário: $(whoami) | Home: $USER_HOME"
echo "=========================================================="

# 1. Instalação de Pacotes Essenciais
echo ""
echo "[1/7] Verificando e instalando dependências do sistema..."
PACKAGES=(
    fsearch
    xfce4-clipman-plugin
    xfdashboard
    plasma-systemmonitor
    flameshot
    rofi
    xclip
    gir1.2-gtksource-4
    poppler-utils
    python3-gi
    python3-pil
    fd-find
    curl
    jq
)

TO_INSTALL=()
for pkg in "${PACKAGES[@]}"; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
        TO_INSTALL+=("$pkg")
    fi
done

if [ ${#TO_INSTALL[@]} -gt 0 ]; then
    echo "Instalando: ${TO_INSTALL[*]}"
    sudo apt update
    sudo apt install -y "${TO_INSTALL[@]}"
else
    echo "Todas as dependências do sistema já estão instaladas."
fi

# 2. Criar Diretórios do Usuário
echo ""
echo "[2/7] Preparando estrutura de diretórios do usuário..."
mkdir -p "$LOCAL_BIN"
mkdir -p "$LOCAL_APPS"
mkdir -p "$LOCAL_DBUS"
mkdir -p "$CONFIG_DIR/app-catalog"
mkdir -p "$CONFIG_DIR/rofi"
mkdir -p "$CONFIG_DIR/fsearch"
mkdir -p "$CONFIG_DIR/ghostty"
mkdir -p "$CONFIG_DIR/Thunar"
mkdir -p "$CONFIG_DIR/autostart"

# 3. Copiar e Configurar Utilitários em ~/.local/bin/
echo ""
echo "[3/7] Instalando utilitários em $LOCAL_BIN..."
cp -f "$SCRIPT_DIR/bin/"* "$LOCAL_BIN/"
chmod +x "$LOCAL_BIN/"*

# Symlink fd -> fdfind se existir
if [ -x "/usr/bin/fdfind" ] && [ ! -e "$LOCAL_BIN/fd" ]; then
    ln -s /usr/bin/fdfind "$LOCAL_BIN/fd"
    echo "Symlink 'fd -> /usr/bin/fdfind' criado."
fi

# 4. Configurações de Aplicativos e Arquivos de Configuração
echo ""
echo "[4/7] Aplicando configurações em $CONFIG_DIR..."
# App Catalog
cp -n "$SCRIPT_DIR/config/app-catalog/tools.json" "$CONFIG_DIR/app-catalog/tools.json" || cp -f "$SCRIPT_DIR/config/app-catalog/tools.json" "$CONFIG_DIR/app-catalog/tools.json"

# Rofi Launchpad
cp -f "$SCRIPT_DIR/config/rofi/launchpad.rasi" "$CONFIG_DIR/rofi/launchpad.rasi"

# Ghostty config
if [ -f "$SCRIPT_DIR/config/ghostty/config" ]; then
    cp -f "$SCRIPT_DIR/config/ghostty/config" "$CONFIG_DIR/ghostty/config"
fi

# FSearch config adaptada ao home atual
sed "s|/home/edson|$USER_HOME|g" "$SCRIPT_DIR/config/fsearch/fsearch.conf" > "$CONFIG_DIR/fsearch/fsearch.conf"

# Thunar Custom Actions & Accels
sed "s|/home/edson|$USER_HOME|g" "$SCRIPT_DIR/config/Thunar/uca.xml" > "$CONFIG_DIR/Thunar/uca.xml"
cp -f "$SCRIPT_DIR/config/Thunar/accels.scm" "$CONFIG_DIR/Thunar/accels.scm"

# Autostart
cp -f "$SCRIPT_DIR/config/autostart/"* "$CONFIG_DIR/autostart/"

# Mimeapps (padrões de apps)
cp -f "$SCRIPT_DIR/config/mimeapps.list" "$CONFIG_DIR/mimeapps.list"

# DBus override para Thunar
cp -f "$SCRIPT_DIR/dbus-services/org.freedesktop.FileManager1.service" "$LOCAL_DBUS/"

# 5. Instalar Desktop Entries e Ocultação de Redundâncias
echo ""
echo "[5/7] Configurando lançadores (.desktop) e deduplicação de menus..."
for f in "$SCRIPT_DIR/applications/"*.desktop; do
    if [ -f "$f" ]; then
        fname="$(basename "$f")"
        sed "s|/home/edson|$USER_HOME|g" "$f" > "$LOCAL_APPS/$fname"
        chmod +x "$LOCAL_APPS/$fname"
    fi
done

# Aplicar NoDisplay=true para os apps conflitantes
if [ -d "$SCRIPT_DIR/applications/overrides" ]; then
    cp -f "$SCRIPT_DIR/applications/overrides/"*.desktop "$LOCAL_APPS/"
fi

update-desktop-database "$LOCAL_APPS" 2>/dev/null || true

# 6. Configurar Atalhos Globais no XFCE (xfconf-query)
echo ""
echo "[6/7] Registrando atalhos globais de teclado no XFCE..."

set_shortcut() {
    local key="$1"
    local cmd="$2"
    xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/$key" -n -t string -s "$cmd" 2>/dev/null || \
    xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/$key" -s "$cmd" 2>/dev/null
}

# Hub de Ferramentas (Super + H)
set_shortcut "<Super>h" "$LOCAL_BIN/hub-ferramentas"
set_shortcut "<Super>H" "$LOCAL_BIN/hub-ferramentas"

# J.A.R.V.I.S. HUD (Super + J e Ctrl + J)
set_shortcut "<Super>j" "$LOCAL_BIN/jarvis"
set_shortcut "<Super>J" "$LOCAL_BIN/jarvis"
set_shortcut "<Primary>j" "$LOCAL_BIN/jarvis"
set_shortcut "<Primary>J" "$LOCAL_BIN/jarvis"

# Este Computador (Super + E)
set_shortcut "<Super>e" "$LOCAL_BIN/meu-computador"

# Launchpad (F4 e Super + A)
set_shortcut "F4" "$LOCAL_BIN/launchpad"
set_shortcut "<Super>a" "$LOCAL_BIN/launchpad"

# Clipboard History (Super + V)
set_shortcut "<Super>v" "xfce4-popup-clipman"

# Visão de Tarefas / Mission Control (Super + Tab)
set_shortcut "<Super>Tab" "$LOCAL_BIN/toggle-taskview"

# Terminal Ghostty (Super + T e Ctrl + Alt + T)
set_shortcut "<Super>t" "ghostty"
set_shortcut "<Primary><Alt>t" "ghostty"

# Print & Traduzir (Super + Shift + T e Ctrl + Shift + T)
set_shortcut "<Shift><Super>t" "$LOCAL_BIN/flameshot-translate"
set_shortcut "<Shift><Super>T" "$LOCAL_BIN/flameshot-translate"
set_shortcut "<Primary><Shift>t" "$LOCAL_BIN/flameshot-translate"

# Flameshot Anotações (Ctrl + Shift + S)
set_shortcut "<Primary><Shift>s" "flameshot gui"

# FSearch Everything (Ctrl + Alt + B e Super + S)
set_shortcut "<Primary><Alt>b" "fsearch"
set_shortcut "<Super>s" "fsearch"

# Monitor do Sistema (Ctrl + Shift + Esc)
set_shortcut "<Primary><Shift>Escape" "plasma-systemmonitor"

# Ajustes do Clipman (Auto-paste ao selecionar)
xfconf-query -c xfce4-clipman -p "/tweaks/paste-on-activate" -n -t bool -s true 2>/dev/null || \
xfconf-query -c xfce4-clipman -p "/tweaks/paste-on-activate" -s true 2>/dev/null

xfconf-query -c xfce4-clipman -p "/tweaks/popup-at-pointer" -n -t bool -s true 2>/dev/null || \
xfconf-query -c xfce4-clipman -p "/tweaks/popup-at-pointer" -s true 2>/dev/null

# 7. Reiniciar Serviços Relevantes
echo ""
echo "[7/7] Inicializando daemons e recarregando o gerenciador de arquivos..."
# Reiniciar Thunar para aplicar atalhos e uca.xml
thunar -q 2>/dev/null || true

# Configurar e ativar serviço systemd do JARVIS
if [ -f "$SCRIPT_DIR/systemd/jarvis.service" ]; then
    mkdir -p "$USER_HOME/.config/systemd/user"
    cp -f "$SCRIPT_DIR/systemd/jarvis.service" "$USER_HOME/.config/systemd/user/jarvis.service"
    systemctl --user daemon-reload 2>/dev/null || true
    systemctl --user enable --now jarvis.service 2>/dev/null || true
fi

# Iniciar xfdashboard daemon se não estiver rodando
if ! pgrep -f "xfdashboard -d" >/dev/null; then
    nohup xfdashboard -d >/dev/null 2>&1 &
fi

echo ""
echo "=========================================================="
echo "  Setup Concluído com Sucesso!"
echo "  Todos os utilitários, atalhos e padrões estão ativos."
echo "=========================================================="
