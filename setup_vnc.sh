#!/bin/bash

# Actualizar el sistema
apt update -y && apt upgrade -y

# Instalar VNC Server y dependencias
apt install -y tightvncserver dbus-x11

# Instalar los entornos de escritorio GNOME, KDE y LXDE
apt install -y gnome kde-standard lxde-core

# Crear usuarios para cada entorno de escritorio
useradd -m -s /bin/bash debian_gnome
useradd -m -s /bin/bash debian_kde
useradd -m -s /bin/bash debian_lxde

# Configurar contraseñas para los usuarios
echo "debian_gnome:password" | chpasswd
echo "debian_kde:password" | chpasswd
echo "debian_lxde:password" | chpasswd

# Configurar VNC para cada usuario
for user in debian_gnome debian_kde debian_lxde; do
    su - $user -c "mkdir -p ~/.vnc"
    su - $user -c "echo password | vncpasswd -f > ~/.vnc/passwd"
    su - $user -c "chmod 600 ~/.vnc/passwd"
    
    # Configurar el archivo xstartup según el escritorio
    if [ "$user" == "debian_gnome" ]; then
        su - $user -c "echo -e '#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nxrdb $HOME/.Xresources\ngnome-session &' > ~/.vnc/xstartup"
    elif [ "$user" == "debian_kde" ]; then
        su - $user -c "echo -e '#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nxrdb $HOME/.Xresources\nstartplasma-x11 &' > ~/.vnc/xstartup"
    elif [ "$user" == "debian_lxde" ]; then
        su - $user -c "echo -e '#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nxrdb $HOME/.Xresources\nlxsession &' > ~/.vnc/xstartup"
    fi
    
    su - $user -c "chmod +x ~/.vnc/xstartup"
    su - $user -c "vncserver"
    
    echo "VNC configurado para el usuario $user con su escritorio correspondiente."
done

# Instalar clientes VNC en el servidor para pruebas
apt install -y remmina xtightvncviewer tigervnc-viewer

# Mostrar estado del servidor VNC
vncserver -list

echo "Configuración de escritorios y VNC finalizada. Ahora prueba con los clientes!"
