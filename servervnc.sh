#!/bin/bash

# Configurar y dejar funcionando el Servidor VNC con GNOME, KDE y LXDE

# Actualizar paquetes
sudo apt update -y && sudo apt upgrade -y

# Instalar VNC Server y entornos de escritorio
sudo apt install -y tightvncserver xfce4 xfce4-goodies gnome-session kde-plasma-desktop lxde

# Asignar contraseñas a los usuarios
echo "debian_gnome:password" | sudo chpasswd
echo "debian_kde:password" | sudo chpasswd
echo "debian_lxde:password" | sudo chpasswd

# Configurar VNC para cada usuario
for user in debian_gnome debian_kde debian_lxde; do
    sudo -u $user mkdir -p /home/$user/.vnc
    echo "password" | sudo -u $user vncpasswd -f > /home/$user/.vnc/passwd
    sudo -u $user chmod 600 /home/$user/.vnc/passwd

done

# Configurar los escritorios en VNC para cada usuario
sudo -u debian_gnome bash -c 'echo -e "#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nxrdb \$HOME/.Xresources\ngnome-session &" > ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup'

sudo -u debian_kde bash -c 'echo -e "#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nxrdb \$HOME/.Xresources\nstartplasma-x11 &" > ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup'

sudo -u debian_lxde bash -c 'echo -e "#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nxrdb \$HOME/.Xresources\nlxsession &" > ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup'

# Iniciar los servidores VNC para cada usuario
sudo -u debian_gnome vncserver :1 -geometry 1280x720 -depth 24
sudo -u debian_kde vncserver :2 -geometry 1280x720 -depth 24
sudo -u debian_lxde vncserver :3 -geometry 1280x720 -depth 24

# Habilitar los puertos en el firewall
sudo ufw allow 5901/tcp
sudo ufw allow 5902/tcp
sudo ufw allow 5903/tcp
sudo ufw reload

echo "✅ Servidor VNC configurado correctamente!"
echo "📌 Conéctate con:"
echo "   - GNOME: xtightvncviewer 10.0.0.24:1"
echo "   - KDE: xtightvncviewer 10.0.0.24:2"
echo "   - LXDE: xtightvncviewer 10.0.0.24:3"