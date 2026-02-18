FROM oraclelinux:9

# Install packages
RUN dnf update -y && \
    dnf install -y \
        python3 \
        python3-pip \
        openssh-server \
        sudo \
        iproute \
        vim \
        which && \
    dnf clean all

# Create ansible user
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansiblepass" | chpasswd && \
    echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible

RUN useradd -m -s /bin/bash oracle && \
    echo "oracle:oraclepass" | chpasswd && \
    echo "oracle ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/oracle
    
# SSH setup
RUN mkdir -p /home/ansible/.ssh && \
    chown -R ansible:ansible /home/ansible/.ssh && \
    chmod 700 /home/ansible/.ssh && \
    ssh-keygen -A


RUN mkdir -p /home/oracle/.ssh && \
    chown -R oracle:oracle /home/oracle/.ssh && \
    chmod 700 /home/oracle/.ssh 
    
# Allow password authentication
RUN sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22

# Start SSH server as default command
CMD ["/usr/sbin/sshd", "-D"]
