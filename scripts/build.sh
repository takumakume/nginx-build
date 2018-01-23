#!/bin/bash -x

export BUILD_HOME=/root/rpmbuild

function setup_module() {
  name=$1
  url=$2
  rm -rf /usr/local/src/${name}
  mkdir -p /usr/local/src/${name}
  wget -qO- ${url} | tar -xz -C /usr/local/src/${name} --strip=1
  ls -l /usr/local/src/${name}
}

[[ -z "${ROLE_NAME}" ]]      && echo "require env ROLE_NAME"      && exit 0
[[ -z "${NGINX_VERSION}" ]]  && echo "require env NGINX_VERSION"  && exit 0
[[ -z "${NGINX_SRPM_URL}" ]] && echo "require env NGINX_SRPM_URL" && exit 0

curl -o /usr/local/src/nginx_signing.key https://nginx.org/keys/nginx_signing.key
rpm --import /usr/local/src/nginx_signing.key

srpm_path="/usr/local/src/`basename ${NGINX_SRPM_URL}`"
curl -o ${srpm_path} ${NGINX_SRPM_URL}
rpm -Uv ${srpm_path}
yum-builddep -y ${srpm_path}

# extend script
[[ -f "roles/${ROLE_NAME}/build.sh" ]] && source roles/${ROLE_NAME}/build.sh

if [ -f '/root/rpmbuild/SPECS/nginx.spec.patch' ]; then
  cd /root/rpmbuild/SPECS
  patch -f -p0 < nginx.spec.patch
fi

echo "%_revision ${REVISION}" >> /root/.rpmmacros

ls -lR /root/rpmbuild/
rpmbuild -ba /root/rpmbuild/SPECS/nginx.spec

rm -rf /mnt/${ROLE_NAME}
mkdir -p /mnt/${ROLE_NAME}
find /root/rpmbuild/RPMS/ -type f -name "*.rpm" | xargs -i% cp % /mnt/${ROLE_NAME}/

find /root/rpmbuild/RPMS/ -type f -name "*.rpm" | xargs -i% rpm -ivh %

/root/rpmbuild/test/test.sh
