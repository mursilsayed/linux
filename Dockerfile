FROM centos:centos6
MAINTAINER Mursil Sayed <mursilsayed@gmail.com>
#Custom centos6 image with SSH support and a startup script that launches sshd


# Cpoying the yum configuring file needed to download packages behind Packages
#COPY yum.conf /etc/yum.conf
RUN echo "proxy=http://172.17.42.1:3128" >> /etc/yum.conf

# Install packages and set up sshd
RUN yum -y install openssh-server telnet openssh-clients
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config


# Set root passwd
RUN echo "root:root"|chpasswd


#Creating volume for holding instance specific files
VOLUME /Applications


# Add startup script
ADD programs_to_run.sh /Applications/programs_to_run.sh
#RUN chmod +x /Applications/*.sh

EXPOSE 22
CMD sh /Applications/programs_to_run.sh



