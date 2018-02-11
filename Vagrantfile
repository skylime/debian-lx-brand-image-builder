# -*- mode: ruby -*-
# vi: set ft=ruby :

$export_env = <<SCRIPT
tee "/root/env.sh" > "/dev/null" <<EOF
export BUILD_DATE=$(date +%Y%m%d)

export IMAGE_NAME=#{ENV['IMAGE_NAME']}
export TMP_IMAGE_NAME=${IMAGE_NAME//- /}
export KERNEL=#{ENV['KERNEL']}

export OS_VERSION=#{ENV['OS_VERSION']}
export OS_NAME="${TMP_IMAGE_NAME^} LX Brand"
export OS_DESC="${TMP_IAMGE_NAME^} 64-bit lx-brand image."

export MIN_PLATFORM="20170803T064301Z"
export PUBLISH_URL="#{ENV['PUBLISH_URL']}"

echo nameserver 9.9.9.9 > /etc/resolv.conf
EOF
SCRIPT

$install_script = <<SCRIPT
source /root/env.sh
cd /vagrant && \
/vagrant/install -r ${OS_VERSION} \
                 -d /data/chroot \
                 -m http://httpredir.debian.org/debian/ \
                 -i core-${IMAGE_NAME} \
                 -p "${OS_NAME}" \
                 -D "${OD_DESC}" \
                 -u https://docs.joyent.com/images/container-native-linux && \
echo core-${IMAGE_NAME}-${BUILD_DATE} > /vagrant/done
SCRIPT

$create_lx_script = <<SCRIPT
source /root/env.sh
cd /vagrant && \
/vagrant/create-lx-image -t /vagrant/core-${IMAGE_NAME}-${BUILD_DATE}.tar.gz \
                         -k ${KERNEL} \
                         -m ${MIN_PLATFORM} \
                         -i core-${IMAGE_NAME} \
                         -d "${OS_DESC}" \
                         -u https://docs.joyent.com/images/container-native-linux
SCRIPT

$create_manifest = <<SCRIPT
source /root/env.sh
cd /vagrant && \
/vagrant/create-manifest -f core-${IMAGE_NAME}-${BUILD_DATE}.zfs.gz \
                         -k ${KERNEL} \
                         -m ${MIN_PLATFORM} \
                         -n core-${IMAGE_NAME}-${BUILD_DATE} \
                         -v ${BUILD_DATE} \
                         -p true \
> core-${IMAGE_NAME}-${BUILD_DATE}.json
SCRIPT

$imgadm_publish = <<SCRIPT
source /root/env.sh
cd /vagrant && \
imgadm publish -m core-${IMAGE_NAME}-${BUILD_DATE}.json -f core-${IMAGE_NAME}-${BUILD_DATE}.zfs.gz ${PUBLISH_URL}
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.define :debian do |debian|
    debian.vm.box = "generic/debian9"
    debian.vm.network :private_network, ip: "10.0.0.10"
    debian.vm.hostname = "debian"

    debian.vm.synced_folder ".", "/vagrant"

    debian.vm.provision "requirements", type: "shell" do |s|
      s.inline = "apt-get update && apt-get install -y debootstrap git && mkdir -p /data/chroot"
      s.env = {"DEBIAN_FRONTEND" => "noninteractive"}
    end

    debian.vm.provision "env", type: "shell", inline: $export_env, run: "always"

    debian.vm.provision "install", type: "shell", inline: $install_script
  end

  config.vm.define :smartos do |smartos|
    smartos.vm.box = "drscream/smartos"
    smartos.vm.network :private_network, ip: "10.0.0.11"
    smartos.vm.hostname = "smartos"

    smartos.vm.provision "env", type: "shell", inline: $export_env, run: "always", privileged: false

    smartos.vm.provision "create-lx-image", type: "shell", inline: $create_lx_script, privileged: false
    smartos.vm.provision "create-manifest", type: "shell", inline: $create_manifest, privileged: false
    smartos.vm.provision "imgadm-publish", type: "shell", inline: $imgadm_publish, privileged: false
  end
end
