# Workstation Setup — Ubuntu / Debian XFCE Power Desktop

Receita completa, automatizada e modular para replicar a configuração de produtividade (estilo macOS + Windows 11 Power User) em qualquer computador com Linux XFCE.

---

## 🚀 Instalação Rápida em Nova Máquina

Clone o repositório e execute o script instalador:

```bash
git clone <url-do-repositorio> ~/workstation-setup
cd ~/workstation-setup
chmod +x install.sh
./install.sh
```

O script é **idempotente** (pode ser executado múltiplas vezes sem quebrar nada) e realiza todas as etapas automaticamente:
1. Instala pacotes do sistema via `apt`.
2. Instala os utilitários criados em `~/.local/bin/`.
3. Aplica as configurações em `~/.config/` (Launchpad, FSearch, Ghostty, Thunar, Autostart).
4. Configura o desvio de DBus para o Thunar e oculta programas redundantes nos menus.
5. Registra todos os atalhos globais no XFCE via `xfconf-query`.
6. Configura o histórico de clipboard com auto-paste (`Win + V`).
7. Inicia os daemons de segundo plano (`xfdashboard -d`, `xfce4-clipman`).

---

## ⚡ Atalhos e Funcionalidades Configuradas

| Atalho | Ferramenta | Descrição |
|---|---|---|
| **`Super + H`** | **Hub de Ferramentas** | Catálogo pesquisável com tags, atalhos, categorias e execução direta. |
| **`Super + E`** | **Este Computador** | Painel em colunas com discos e barras de uso, pastas e arquivos recentes. |
| **`Super + A`** ou **`F4`** | **Launchpad** | Gaveta de aplicativos em tela cheia semitransparente (estilo macOS). |
| **`Super + V`** | **Histórico de Clipboard** | Menu no cursor com últimos 50 textos e 10 imagens (com auto-paste). |
| **`Super + Tab`** | **Mission Control** | Visão geral de janelas abertas e miniaturas ao vivo das áreas de trabalho. |
| **`Super + T`** | **Ghostty Terminal** | Terminal moderno acelerado por GPU com tema TokyoNight e fonte Hack. |
| **`Super + Shift + T`** | **Print & Traduzir** | Tira print de uma área e abre direto no Google Tradutor Imagens. |
| **`Ctrl + Alt + B`** | **FSearch (Everything)** | Busca indexada ultrarrápida em microssegundos no Home e NVMe. |
| **`Ctrl + Espaço`** | **Ulauncher** | Barra estilo Spotlight / Raycast para comandos rápidos. |
| **`Ctrl + Shift + Esc`** | **Monitor do Sistema** | Plasma Systemmonitor com GPU NVIDIA GTX 1650, CPU, RAM e tráfego de rede por app. |
| **`Ctrl + Shift + S`** | **Flameshot** | Captura avançada com setas, caixas, borrão de dados e anotações. |
| **`F3`** (no Thunar) | **Quick Look** | Preview instantâneo de códigos, markdown, imagens e PDFs sem abrir programas. |

---

## 📁 Estrutura do Repositório

```
workstation-setup/
├── install.sh                  # Script automatizado de instalação
├── README.md                   # Esta documentação
├── bin/                        # Utilitários executáveis
│   ├── hub-ferramentas         # Hub de busca de ferramentas e atalhos (Python GTK3)
│   ├── quicklook               # Pré-visualizador instantâneo F3 (Python GTK3 + GtkSource4)
│   ├── meu-computador          # Painel de discos e arquivos recentes (Python GTK3)
│   ├── launchpad               # Gaveta de aplicativos translúcida (Rofi)
│   ├── flameshot-translate     # Script de print + tradutor
│   └── toggle-taskview         # Alternador do Mission Control (xfdashboard)
├── config/
│   ├── app-catalog/tools.json  # Catálogo com 17 ferramentas cadastradas
│   ├── rofi/launchpad.rasi     # Tema escuro translúcido do Launchpad
│   ├── fsearch/fsearch.conf    # Calibração do índice de busca FSearch
│   ├── ghostty/config          # Tema TokyoNight, fonte Hack, margens
│   ├── Thunar/                 # Ações customizadas (uca.xml) e atalhos (accels.scm)
│   ├── autostart/              # Lançadores automáticos do sistema
│   └── mimeapps.list           # Padronização de aplicativos padrão
├── applications/               # Lançadores (.desktop)
│   └── overrides/              # Entradas com NoDisplay=true para deduplicar menus
└── dbus-services/              # Desvio do DBus org.freedesktop.FileManager1 para Thunar
```

---

## 🛠️ Manutenção e Personalização

- **Adicionar novas ferramentas ao Hub:** Pressione `Super + H` e clique no botão **"+ Nova Ferramenta"** (ou `Ctrl + N`), ou edite diretamente `~/.config/app-catalog/tools.json`.
- **Alterar atalhos:** Todos os atalhos usam o padrão canônico do XFCE (`xfconf-query -c xfce4-keyboard-shortcuts`).
