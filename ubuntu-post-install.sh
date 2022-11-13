#! /usr/bin/env sh
#================================================================
# UBUNTU POST INSTALL
#
# AUTOR     : Ricardo S.
# GITHUB    : https://github.com/ricjcs/ubuntu-post-install
# DESCRIÇÃO : Script para atualizar o sistema, efetuar pequenas
# alterações no desktop, e remover e instalar pacotes.
#
# DATA DA CRIAÇÃO    : 2015
# ÚLTIMA MODIFICAÇÃO : 13/11/2022
#================================================================

prgname="UBUNTU POST INSTALL"
version="2.0"

#################################################################
#   FUNÇÕES                                      ################
#################################################################

# VERIFICAÇÃO DE ROOT -------------------------------------------
check_root() {
    if [[ ! $(whoami) = "root" ]]; then 
        echo "OPS! VOCÊ TEM QUE EXECUTAR O SCRIPT COMO ROOT."
        exit 1
    fi
}
# ---------------------------------------------------------------

####################################
# INFO, UPDATE, UPGRADE, CLEAN
#################################### 

# INFORMAÇÕES DO SISTEMA
sys_info() {
    clear
    # Chamada da bibliotaca de variáveis para
    # saber as informações do sistema.
    . /etc/os-release

    totalPackages=$(dpkg-query -f '${binary:Package}\n' -W | wc -l)

    echo "---------------------------------------------------"
    echo "  Informações do Sistema"
    echo "---------------------------------------------------"
    echo "  Distribution : $NAME"
    echo "  Version : $VERSION_ID"
    echo "  Codename : $VERSION_CODENAME"
    echo "  Kernel : $(uname -r)"
    echo "  Uptime : $(uptime -p)"
    echo "  Total Package : $totalPackages packages"
    printf "  Date and Time : "
    date
}

# ATUALIZAR O SISTEMA
update_system() {
    clear
    echo "---------------------------------------------------"
    echo "  Atualizando o Sistema"
    echo "---------------------------------------------------"
    apt update
    apt upgrade
}

# LIMPAR O SISTEMA
clear_system() {
    clear
    echo "---------------------------------------------------"
    echo "  Limpando o Sistema"
    echo "---------------------------------------------------"
    apt clean
    apt autoremove
}

# REMOVER PACOTES PRÉ-INSTALADOS
remove_pre_installed_packages() {
 clear
    echo "---------------------------------------------------"
    echo "  Remover pacotes pré-instalados"
    echo "---------------------------------------------------"
    echo "
    - Os seguintes pacotes vão ser removidos:
        aisleriot
        gnome-mahjongg
        gnome-mines
    "
    echo "  Tem a certeza que deseja remover estes pacotes? [s/n]"
    printf "  "
    read allOP
    case $allOP in
        S|s)
            apt purge        \
            aisleriot        \
            gnome-mahjongg   \
            gnome-mines      \
            -y        
        ;;
        N|n) ;;
        *) echo " OPS! Você não digitou corretamente." ;;
    esac
}  

# REMOVER PACOTES INDICADOS
remove_pack() {
    clear
    echo "---------------------------------------------------"
    echo "  Remover Pacotes"
    echo "---------------------------------------------------"
    read -p "  Digite o nome de um ou mais pacotes para serem removidos -> " pack
    apt-get purge $pack
}

####################################
# UBUTNU DESKTOP / GNOME
####################################

# Configurar #######################

# MINIMIZAR AO CLICAR 
minimize_on_click() {
    clear
    echo "---------------------------------------------------"
    echo "  Minimizar ao clicar"
    echo "  Ao clicar num icon na dock minimiza a janela"
    echo "---------------------------------------------------"
    gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
    echo "  Feito!"
}

# MOSTRAR A PERCENTAGEM DE BATERIA
battery_percentage() {
    clear
    echo "---------------------------------------------------"
    echo "  Mostrar a percentagem da bateria na barra superior"
    echo "---------------------------------------------------"
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    echo "  Feito!"

}

# Pacotes ##########################

# EXTENSION MANAGER
install_extension_manager() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando Extension Manager"
    echo "---------------------------------------------------"
    apt install gnome-shell-extension-manager
}

# SUPORTE À INSTALAÇÃO DE EXTENSÕES GNOME VIA BROWSER
install_support_extensions_browser() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando suporte à intalação de extensões via browser"
    echo "---------------------------------------------------"
    apt install chrome-gnome-shell
}

# GNOME TWEAKS
install_gnome_tweaks() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando Gnome Tweaks"
    echo "---------------------------------------------------"
    apt install gnome-tweaks
}

# GNOME SUSHI (QuickLook)
install_gnome_sushi() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando Gnome Sushi (QuickLook)"
    echo "---------------------------------------------------"
    apt install gnome-sushi
}

# DCONF EDITOR
install_dconf_editor() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando Dconf Editor"
    echo "---------------------------------------------------"
    apt install dconf-editor
} 

# LISTA DE EXTENSÕES GNOME
list_gnome_extensions() {
    clear
    echo "---------------------------------------------------"
    echo "  Lista de extensões úteis para o Gnome"
    echo "---------------------------------------------------"
    echo "
    User Themes
    https://extensions.gnome.org/extension/19/user-themes/

    Dash to Dock
    https://extensions.gnome.org/extension/307/dash-to-dock/

    Dash to Panel
    https://extensions.gnome.org/extension/1160/dash-to-panel/

    Blur my Shell
    https://extensions.gnome.org/extension/3193/blur-my-shell/

    Dynamic Panel Transparency
    https://extensions.gnome.org/extension/1011/dynamic-panel-transparency/

    Transparent Top Bar (Adjustable transparency)
    https://extensions.gnome.org/extension/3960/transparent-top-bar-adjustable-transparency/

    Gesture Improvements
    https://extensions.gnome.org/extension/4245/gesture-improvements/

    Quick Settings Tweaker
    https://extensions.gnome.org/extension/5446/quick-settings-tweaker/

    Search Ligh
    https://extensions.gnome.org/extension/5489/search-light/

    Quick Settings Button Remover
    https://extensions.gnome.org/extension/5443/quick-settings-button-remover/

    Vitals
    https://extensions.gnome.org/extension/1460/vitals/

    System monitor
    https://extensions.gnome.org/extension/120/system-monitor/

    NetSpeed
    https://extensions.gnome.org/extension/104/netspeed/

    Applications Menu
    https://extensions.gnome.org/extension/6/applications-menu/

    ArcMenu
    https://extensions.gnome.org/extension/3628/arcmenu/

    Recent Items
    https://extensions.gnome.org/extension/72/recent-items/

    Clipboard Indicator
    https://extensions.gnome.org/extension/779/clipboard-indicator/

    Caffeine
    https://extensions.gnome.org/extension/517/caffeine/

    GSConnect
    https://extensions.gnome.org/extension/1319/gsconnect/

    User Avatar In Quick Settings
    https://extensions.gnome.org/extension/5506/user-avatar-in-quick-settings/
    "
}

####################################
# SEGURANÇA E BACKUPS
####################################

# GUFW (Firewall)
install_gufw() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando GUFW (Firewall)"
    echo "---------------------------------------------------"
    apt install gufw
    ufw default deny incoming
    ufw enable
    ufw status
}

# TIMESHIFT
install_timeshift() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando Timeshift"
    echo "---------------------------------------------------"
    apt install timeshift
}

####################################
# UTILITÁRIOS E OUTROS PACOTES
####################################

# UBUNTU CODECS EXTRAS
install_ubuntu_codecs_extras() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando Codecs Extras"
    echo "---------------------------------------------------"
    apt install ubuntu-restricted-extras
}

# SUPORTE AO FLATPACK
install_flatpack() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando suporte ao Flatpak"
    echo "---------------------------------------------------"
    apt install flatpak
    apt install gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo
    echo "  Feito! Agora Você precisa reiniciar o sistema."
}

# SUPORTE AO APPIMAGE
install_support_appimage() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando suporte ao AppImage"
    echo "---------------------------------------------------"
    apt install libfuse2
}

# NEOFETCH
install_neofetch() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando Neofetch"
    echo "---------------------------------------------------"
    apt install neofetch
}

# HTOP
install_htop() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando Htop"
    echo "---------------------------------------------------"
    apt install htop
}

# TERMINATOR TERMINAL EMULATOR
install_terminator() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando Terminatoor"
    echo "---------------------------------------------------"
    apt install terminator
}

# GOOGLE CHROME
install_chrome() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando Google Chrome"
    echo "---------------------------------------------------"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    dpkg -i google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb
}

# VLC
install_vlc() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando VLC"
    echo "---------------------------------------------------"
    apt install vlc
}

# VSCODE
install_vscode() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando VSCode"
    echo "---------------------------------------------------"
    snap install code --classic
}

# CATFISH
install_catfish() {
    clear
    echo "---------------------------------------------------"
    echo "  Instalando Catfish"
    echo "---------------------------------------------------"
    apt install catfish
}

####################################
# DE UMA SÓ VEZ
####################################
several() {
    clear
    echo "---------------------------------------------------"
    echo "  Várias alterações de uma só vez"
    echo "---------------------------------------------------"
    echo "
    - O Sistema vai ser atualizado.

    - Vai ser modificado o seguinte:
       Ao clicar num icon na dock minimiza a janela.

    - Os seguintes pacotes vão ser instalados:
       gnome-shell-extension-manager
       gnome-tweaks
       gnome-sushi
       neofetch
       gufw
       vlc
       Chrome
       VSCode
    "
    echo "  Tem a certeza que deseja efetuar as alterações? [s/n]"
    printf " "
    read allOP
    case $allOP in
        S|s)
            update_system
            minimize_on_click
            
            apt install                   \
            gnome-shell-extension-manager \
            gnome-tweaks                  \
            gnome-sushi                   \
            neofetch                      \
            htop                          \
            gufw                          \
            vlc                           \
            -y
            
            install_chrome
            install_vscode             
        ;;
        N|n) ;;
        *) echo " OPS! Você não digitou corretamente." ;;
    esac
}


# PAUSA NO LOOP -------------------------------------------------
pause() {
    printf "\e[1;91m\n  <ENTER PARA CONTINUAR> \e[m\n"
    read go
}
# ---------------------------------------------------------------

#################################################################
#   INICIO / MENU                               #################
#################################################################
check_root
while true; do
    clear
    echo "---------------------------------------------------"
    printf "\e[37;45m $prgname - $version \e[m\n"
    echo "---------------------------------------------------"
    echo
    printf "\e[1;96m INFO, UPDATE, UPGRADE, CLEAN \e[m\n"
    echo " I. Informações do Sistema"
    echo " A. Atualizar o Sistema"
    echo " L. Limpar o Sistema"
    echo " P. Remover pacotes pré-instalados"
    echo " R. Remover Pacotes indicados"
    echo
    printf "\e[1;96m UBUNTU DESKTOP/ GNOME \e[m\n"
    printf "\e[1;96m Configurar: \e[m\n"
    echo " M. Minimizar ao Clicar"
    echo " B. Mostrar a percentagem da bateria"
    printf "\e[1;96m Pacotes: \e[m\n"
    echo " 1. Extension Manager"
    echo " 2. Suporte à instalação de extensões via browser"
    echo " 3. Gnome Tweaks"
    echo " 4. Gnome Sushi (QuickLook)"
    echo " 5. Dconf Editor"
    echo " 6. Lista de extensões úteis para o Gnome"
    echo
    printf "\e[1;96m SEGURANÇA E BACKUPS \e[m\n"
    echo " 7. Gufw (Firewall)"
    echo " 8. Timeshift"
    echo
    printf "\e[1;96m UTILITÁRIOS E OUTROS PACOTES \e[m\n"
    echo " 9. Ubuntu Codecs Extras"
    echo " 10. Suporte ao Flatpack"
    echo " 11. Suporte ao AppImage"
    echo " 12. Neofetch"
    echo " 13. Htop"
    echo " 14. Terminator Terminal Emulator"
    echo " 15. Google Chrome"
    echo " 16. Vlc"
    echo " 17. VSCode"
    echo " 18. Catfish"
    echo
    printf "\e[1;96m DE UMA SÓ VEZ \e[m\n"
    echo " X. Atualização, Configurações automáticas e Instalações"
    echo
    echo "---------------------------------------------------"
    printf "\e[1;91m E. Exit    \e[1;93m S. Sobre \e[m\n"
    echo "---------------------------------------------------"
    printf " Escolha uma opção: "
    read menuOP

    case $menuOP in
        # INFO, UPDATE, UPGRADE, CLEAN
        I|i) sys_info ;;
        A|a) update_system ;;
        L|l) clear_system ;;
        P|p) remove_pre_installed_packages ;;
        R|r) remove_pack ;;
        # UBUNTU DESKTOP / GNOME
        # Configurar
        M|m) minimize_on_click ;;
        B|b) battery_percentage ;;
        # Pacotes
        1) install_extension_manager ;;
        2) install_support_extensions_browser ;;
        3) install_gnome_tweaks ;;
        4) install_gnome_sushi ;;
        5) install_dconf_editor ;;
        6) list_gnome_extensions ;;
        # SEGURANÇA E BACKUPS
        7) install_gufw ;;
        8) install_timeshift ;;
        # UTILITÁRIOS E OUTROS PACOTES
        9) install_ubuntu_codecs_extras ;;
        10) install_flatpack ;;
        11) install_support_appimage ;;
        12) install_neofetch ;;
        13) install_htop ;;
        14) install_terminator ;;
        15) install_chrome ;;
        16) install_vlc ;;
        17) install_vscode ;;
        18) install_catfish ;;
        # DE UMA SÓ VEZ
        X|x) several ;;
        ###
        E|e) echo; echo " Até à Próxima!"; echo; exit 0 ;;
        S|s) echo "
        Script para atualizar o sistema, efetuar
        pequenas alterações no desktop, e remover
        e instalar pacotes.
        GITHUB: https://github.com/ricjcs/ubuntu-post-install
        AUTOR: Ricardo S.
        " ;;
        *) echo " OPS! Você não digitou corretamente." ;;
    esac
    pause
done
