FROM registry.redhat.io/ansible-automation-platform-24/ee-minimal-rhel8:latest

USER root
COPY ansible.cfg /etc/ansible/ansible.cfg
COPY requirements.yml /tmp/requirements.yml
COPY requirements.txt /tmp/requirements.txt
COPY bindep.txt /tmp/bindep.txt

# Enable required repositories and install system dependencies
RUN microdnf install -y yum-utils && \
    yum-config-manager --enable rhel-8-for-aarch64-appstream-rpms && \
    microdnf install -y python38-devel gcc python38 && \
    curl -L https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz | tar -xz -C /usr/local/bin/ oc kubectl

# Install Python dependencies
RUN pip3 install --upgrade pip setuptools
RUN pip3 install -r /tmp/requirements.txt

# Configure Ansible Galaxy
RUN mkdir -p ~/.ansible && \
    echo "[galaxy]" > ~/.ansible/galaxy.yml && \
    echo "server_list = automation_hub, galaxy" >> ~/.ansible/galaxy.yml && \
    echo "" >> ~/.ansible/galaxy.yml && \
    echo "[galaxy_server.automation_hub]" >> ~/.ansible/galaxy.yml && \
    echo "url=https://console.redhat.com/api/automation-hub/" >> ~/.ansible/galaxy.yml && \
    echo "auth_url=https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token" >> ~/.ansible/galaxy.yml && \
    echo "token=eyJhbGciOiJIUzUxMiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI0NzQzYTkzMC03YmJiLTRkZGQtOTgzMS00ODcxNGRlZDc0YjUifQ.eyJpYXQiOjE3MzIxMzkyMDYsImp0aSI6ImU1ODg4MWUyLTg2ODQtNGJiMC1iZjQ3LTI0YjE5ZDg1ZDg1YSIsImlzcyI6Imh0dHBzOi8vc3NvLnJlZGhhdC5jb20vYXV0aC9yZWFsbXMvcmVkaGF0LWV4dGVybmFsIiwiYXVkIjoiaHR0cHM6Ly9zc28ucmVkaGF0LmNvbS9hdXRoL3JlYWxtcy9yZWRoYXQtZXh0ZXJuYWwiLCJzdWIiOiJmOjUyOGQ3NmZmLWY3MDgtNDNlZC04Y2Q1LWZlMTZmNGZlMGNlNjphZGFtcGlwcGVydCIsInR5cCI6Ik9mZmxpbmUiLCJhenAiOiJjbG91ZC1zZXJ2aWNlcyIsIm5vbmNlIjoiYWM3MWZhMGMtOWY0Ni00ZjRkLThiYTItY2UwZmM0MGU4Yjg5Iiwic2lkIjoiMWJiMDNjM2UtYjJlNC00YzE0LWE1ZWQtMTAwYjZmMzlkNWUyIiwic2NvcGUiOiJvcGVuaWQgYmFzaWMgYXBpLmlhbS5zZXJ2aWNlX2FjY291bnRzIHJvbGVzIHdlYi1vcmlnaW5zIGNsaWVudF90eXBlLnByZV9rYzI1IG9mZmxpbmVfYWNjZXNzIn0.5SY2Oh34ZOq8nwfCm6gLOo8rPbyrjHCpln_BJSmmb4i5LTwj6HsphO9UZsrtjtXtblvi3NaaGLEkhfHSzz6-Ig" >> ~/.ansible/galaxy.yml && \
    echo "" >> ~/.ansible/galaxy.yml && \
    echo "[galaxy_server.galaxy]" >> ~/.ansible/galaxy.yml && \
    echo "url=https://galaxy.ansible.com/" >> ~/.ansible/galaxy.yml

# Install Ansible collections
RUN ANSIBLE_GALAXY_DISABLE_GPG_VERIFY=1 ansible-galaxy collection install -r /tmp/requirements.yml

# Configure Python alternatives
RUN ln -sf /usr/bin/python3 /usr/bin/python

USER 1001
