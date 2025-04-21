# Intelligent Auto Start for Minecraft Server with systemd

[Read in Portuguese](#auto-start-inteligente-para-servidor-de-minecraft-em-servidores-linux-com-systemd)

This project demonstrates how to configure an intelligent auto start for a Minecraft server using systemd. The implemented solution allows the server to start automatically when connections are detected on port 25565, saving resources when the server is not in use.

## 🖥️ What is systemd and .service files?

`systemd` is a widely used initialization and service management system in Linux distributions. It is responsible for booting the system and managing running processes, providing an efficient way to control services, sockets, devices, and other system components.

`.service` files are `systemd` configuration units that describe how a service should be managed. They contain information such as:

- **Dependencies**: Which services or conditions need to be present for the service to start.
- **Start and stop commands**: How to start or stop the service.
- **Environment settings**: Working directory, user, group, among others.

These files are usually stored in the `/etc/systemd/system/` directory and can be enabled, disabled, started, or stopped using commands like `systemctl`.

## ⚙️ How systemd and .service files work

Systemd uses `.service` files to manage services. Each file has three main sections:

- **[Unit]**: Defines dependencies and execution conditions.
- **[Service]**: Configures how the service will be executed.
- **[Install]**: Defines when the service will be activated with `systemctl enable`.

### Important directives:
- **After**: Defines the startup order relative to other services.
- **Requires**: Defines mandatory dependencies for the service.
- **Conflicts**: Defines services that cannot run simultaneously.
- **ExecStart**: Command to start the service.
- **ExecStopPost**: Command executed after the service is stopped.

## 🚫 Why systemd socket activation was not used in this implementation?

Systemd socket activation does not work with the Minecraft server because it uses the TCP protocol with its own handshake. This requires direct control of the socket from the beginning of the connection. The `minecraft_server.jar` cannot properly inherit the file descriptor passed by systemd, as a socket activation-compatible process would (e.g., an HTTP server).

## 🛠️ How this project was implemented

The implemented solution uses three main components:

1. **minecraft.service**: Responsible for starting the Minecraft server via the `run.sh` script. This service has the `After=network.target` directive, ensuring it will only start after network services are available. It also uses `ExecStopPost` to restart the watcher when the server is stopped.
2. **minecraft-watcher.service**: Listens for connections on port 25565 using the `minecraft-autostart.sh` script. When a connection is detected, it starts the `minecraft.service` and automatically stops (thanks to `Conflicts=minecraft.service`). This service also depends on `network.target` to ensure the network is available before starting.
3. **restart-watcher.sh**: Executed when the `minecraft.service` is stopped (via `ExecStopPost`). It restarts the `minecraft-watcher.service` to continue the cycle.

## ⚙️ Enable/start configuration of services

- The `minecraft-watcher.service` must be **enabled** and **started** so that it automatically runs when the system boots.
- The `minecraft.service` must remain **disabled**, as it should only start when a connection is detected on port 25565 (i.e., on-demand).

## 📁 Project Structure

- **src/scripts/minecraft-autostart.sh**: Script that monitors connections on port 25565 and starts the `minecraft.service` when necessary.
- **src/scripts/restart-watcher.sh**: Script that restarts the `minecraft-watcher.service` after the `minecraft.service` is stopped.
- **src/scripts/run.sh**: Script that starts the Minecraft server.
- **systemd-services/minecraft.service**: Systemd configuration file to start the Minecraft server.
- **systemd-services/minecraft-watcher.service**: Systemd configuration file to monitor connections and start the server on-demand.

## 📝 How to use

1. Create the `.sh` files in the Minecraft server folder (e.g., `/home/{your-user}/minecraft-server/`) with the following contents:
   - **minecraft-autostart.sh**: Script to monitor connections.
   - **restart-watcher.sh**: Script to restart the watcher.
   - **run.sh**: Script to start the server.

2. Make the scripts executable:
   ```bash
   chmod +x /home/{your-user}/minecraft-server/*.sh
   ```

3. Create the `.service` files in the `/etc/systemd/system/` directory with the following contents:
   - **minecraft-watcher.service**: Configuration file to monitor connections and start the server on-demand.
   - **minecraft.service**: Configuration file to start the Minecraft server.

   **Note**: Replace `{your-user}` in the `.service` files with your system username. For example, if your username is `johndoe`, change `/home/{your-user}/...` to `/home/johndoe/...`.

4. Enable and start the `minecraft-watcher.service`:
   ```bash
   sudo systemctl enable minecraft-watcher.service
   sudo systemctl start minecraft-watcher.service
   ```

5. Ensure the `minecraft.service` is disabled:
   ```bash
   sudo systemctl disable minecraft.service
   ```

Now, the Minecraft server will automatically start when connections are detected on port 25565!

## 🛠️ Useful Commands for Monitoring

- **Check the status of the watcher**:
  ```bash
  sudo systemctl status minecraft-watcher.service
  ```
  Shows the current status of the `minecraft-watcher.service`.

- **Monitor watcher logs in real-time**:
  ```bash
  sudo journalctl -u minecraft-watcher -f
  ```
  Displays the logs of the `minecraft-watcher.service` in real-time.

- **Check the status of the Minecraft server**:
  ```bash
  sudo systemctl status minecraft.service
  ```
  Shows the current status of the `minecraft.service`.

- **Stop the Minecraft server**:
  ```bash
  sudo systemctl stop minecraft.service
  ```
  Stops the `minecraft.service`.

- **Monitor Minecraft server logs in real-time**:
  ```bash
  sudo journalctl -u minecraft -f
  ```
  Displays the logs of the `minecraft.service` in real-time.

---

# Auto Start Inteligente para Servidor de Minecraft em Servidores Linux com systemd

[Leia em Inglês](#intelligent-auto-start-for-minecraft-server-with-systemd)

Este projeto demonstra como configurar um auto start inteligente para um servidor de Minecraft utilizando o systemd. A solução implementada permite que o servidor seja iniciado automaticamente ao detectar conexões na porta 25565, economizando recursos quando o servidor não está em uso.

## 🖥️ O que é systemd e arquivos .service?

O `systemd` é um sistema de inicialização e gerenciamento de serviços amplamente utilizado em distribuições Linux. Ele é responsável por inicializar o sistema e gerenciar processos em execução, oferecendo uma maneira eficiente de controlar serviços, sockets, dispositivos e outros componentes do sistema.

Os arquivos `.service` são unidades de configuração do `systemd` que descrevem como um serviço deve ser gerenciado. Eles contêm informações como:

- **Dependências**: Quais serviços ou condições precisam estar presentes para que o serviço seja iniciado.
- **Comandos de inicialização e parada**: Como iniciar ou parar o serviço.
- **Configurações de ambiente**: Diretório de trabalho, usuário, grupo, entre outros.

Esses arquivos são geralmente armazenados no diretório `/etc/systemd/system/` e podem ser habilitados, desabilitados, iniciados ou parados usando comandos como `systemctl`.

## ⚙️ Como funciona o systemd e os arquivos .service

O systemd utiliza arquivos `.service` para gerenciar serviços. Cada arquivo possui três seções principais:

- **[Unit]**: Define dependências e condições de execução.
- **[Service]**: Configura como o serviço será executado.
- **[Install]**: Define quando o serviço será ativado com `systemctl enable`.

### Diretivas importantes:
- **After**: Define a ordem de inicialização em relação a outros serviços.
- **Requires**: Define dependências obrigatórias para o serviço.
- **Conflicts**: Define serviços que não podem ser executados simultaneamente.
- **ExecStart**: Comando para iniciar o serviço.
- **ExecStopPost**: Comando executado após o serviço ser parado.

## 🚫 Por que o systemd socket não foi usado nessa implementação ?

O systemd socket activation não funciona com o servidor de Minecraft porque ele utiliza o protocolo TCP com um handshake próprio. Isso exige controle direto do socket desde o início da conexão. O `minecraft_server.jar` não consegue herdar corretamente o file descriptor passado pelo systemd, como um processo compatível com socket activation faria (por exemplo, um servidor HTTP).

## 🛠️ Como foi feito neste projeto

A solução implementada utiliza três componentes principais:

1. **minecraft.service**: Responsável por iniciar o servidor de Minecraft via o script `run.sh`. Este serviço possui a diretiva `After=network.target`, garantindo que ele só será iniciado após os serviços de rede estarem disponíveis. Ele também utiliza `ExecStopPost` para reiniciar o watcher quando o servidor é parado.
2. **minecraft-watcher.service**: Escuta conexões na porta 25565 usando o script `minecraft-autostart.sh`. Quando detecta uma conexão, inicia o `minecraft.service` e é encerrado automaticamente (graças ao `Conflicts=minecraft.service`). Este serviço também depende de `network.target` para garantir que a rede esteja disponível antes de iniciar.
3. **restart-watcher.sh**: Executado quando o `minecraft.service` é parado (através do `ExecStopPost`). Ele reinicia o `minecraft-watcher.service` para que o ciclo continue.

## ⚙️ Configuração de enable/start dos serviços

- O `minecraft-watcher.service` deve ser **habilitado** (`enabled`) e **iniciado** (`started`), para que ele seja automaticamente executado quando o sistema iniciar.
- O `minecraft.service` deve permanecer **desabilitado** (`disabled`), pois ele só deve iniciar quando uma conexão for detectada na porta 25565 (ou seja, de forma sob demanda).

## 📁 Estrutura do Projeto

- **src/scripts/minecraft-autostart.sh**: Script que monitora conexões na porta 25565 e inicia o `minecraft.service` quando necessário.
- **src/scripts/restart-watcher.sh**: Script que reinicia o `minecraft-watcher.service` após o `minecraft.service` ser parado.
- **src/scripts/run.sh**: Script que inicia o servidor de Minecraft.
- **systemd-services/minecraft.service**: Arquivo de configuração do systemd para iniciar o servidor de Minecraft.
- **systemd-services/minecraft-watcher.service**: Arquivo de configuração do systemd para monitorar conexões e iniciar o servidor sob demanda.

## 📝 Como usar

1. Crie os arquivos `.sh` na pasta do servidor do Minecraft (exemplo: `/home/{seu-usuario}/minecraft-server/`) com os seguintes conteúdos:
   - **minecraft-autostart.sh**: Script para monitorar conexões.
   - **restart-watcher.sh**: Script para reiniciar o watcher.
   - **run.sh**: Script para iniciar o servidor.

2. Torne os scripts executáveis:
   ```bash
   chmod +x /home/{seu-usuario}/minecraft-server/*.sh
   ```

3. Crie os arquivos `.service` no diretório `/etc/systemd/system/` com os seguintes conteúdos:
   - **minecraft-watcher.service**: Arquivo de configuração para monitorar conexões e iniciar o servidor sob demanda.
   - **minecraft.service**: Arquivo de configuração para iniciar o servidor de Minecraft.

   **Nota**: Substitua `{your-user}` nos arquivos `.service` pelo nome do seu usuário no sistema. Por exemplo, se o seu usuário for `johndoe`, altere `/home/{your-user}/...` para `/home/johndoe/...`.

4. Habilite e inicie o `minecraft-watcher.service`:
   ```bash
   sudo systemctl enable minecraft-watcher.service
   sudo systemctl start minecraft-watcher.service
   ```

5. Certifique-se de que o `minecraft.service` está desabilitado:
   ```bash
   sudo systemctl disable minecraft.service
   ```

Agora, o servidor de Minecraft será iniciado automaticamente ao detectar conexões na porta 25565!

## 🛠️ Comandos Úteis para Monitoramento

- **Verificar o status do watcher**:
  ```bash
  sudo systemctl status minecraft-watcher.service
  ```
  Mostra o status atual do serviço `minecraft-watcher.service`.

- **Monitorar logs do watcher em tempo real**:
  ```bash
  sudo journalctl -u minecraft-watcher -f
  ```
  Exibe os logs do `minecraft-watcher.service` em tempo real.

- **Verificar o status do servidor Minecraft**:
  ```bash
  sudo systemctl status minecraft.service
  ```
  Mostra o status atual do serviço `minecraft.service`.

- **Parar o servidor Minecraft**:
  ```bash
  sudo systemctl stop minecraft.service
  ```
  Para o serviço `minecraft.service`.

- **Monitorar logs do servidor Minecraft em tempo real**:
  ```bash
  sudo journalctl -u minecraft -f
  ```
  Exibe os logs do `minecraft.service` em tempo real.