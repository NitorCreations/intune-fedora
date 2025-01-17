FROM fedora:41

RUN dnf install -y alien patchelf

ARG UBUNTU_VER=24.04
ARG UBUNTU_NAME=noble
ARG INTUNE_VER=1.2411.14
ARG DBUSCLIENT_VER=1.0.1
ARG DBUSCLIENT_UBUVER=22.04
ARG IDENTITY_VER=2.0.1

ARG LIBCURL_VER=7.81.0-1ubuntu1.20
ARG LIBLDAP_VER=2.5.18+dfsg-0ubuntu0.22.04.2
ARG LIBSASL_VER=2.1.27+dfsg2-3ubuntu1.2

RUN curl \
  -O https://packages.microsoft.com/ubuntu/${DBUSCLIENT_UBUVER}/prod/pool/main/m/msalsdk-dbusclient/msalsdk-dbusclient_${DBUSCLIENT_VER}_amd64.deb \
  -O https://packages.microsoft.com/ubuntu/${UBUNTU_VER}/prod/pool/main/m/microsoft-identity-broker/microsoft-identity-broker_${IDENTITY_VER}_amd64.deb \
  -O https://packages.microsoft.com/ubuntu/${UBUNTU_VER}/prod/pool/main/i/intune-portal/intune-portal_${INTUNE_VER}-${UBUNTU_NAME}_amd64.deb \
  -O http://archive.ubuntu.com/ubuntu/pool/main/c/curl/libcurl4_${LIBCURL_VER}_amd64.deb \
  -O http://archive.ubuntu.com/ubuntu/pool/main/o/openldap/libldap-2.5-0_${LIBLDAP_VER}_amd64.deb \
  -O http://archive.ubuntu.com/ubuntu/pool/main/c/cyrus-sasl2/libsasl2-2_${LIBSASL_VER}_amd64.deb

RUN mkdir ubuntu

RUN mkdir curl && cd curl && ar x ../libcurl4_${LIBCURL_VER}_amd64.deb && tar xf data.tar.zst
RUN cp -a curl/usr/lib/x86_64-linux-gnu/libcurl.so.* ubuntu

RUN mkdir ldap && cd ldap && ar x ../libldap-2.5-0_${LIBLDAP_VER}_amd64.deb && tar xf data.tar.zst
RUN cp -a ldap/usr/lib/x86_64-linux-gnu/libl*.so.* ubuntu

RUN mkdir sasl && cd sasl && ar x ../libsasl2-2_${LIBSASL_VER}_amd64.deb && tar xvf data.tar.zst
RUN cp -a sasl/usr/lib/x86_64-linux-gnu/libsasl2.so.* ubuntu

RUN chmod a+x ubuntu/*so* && patchelf --set-rpath /usr/lib64/ubuntu ubuntu/*.so.*.*.*

RUN alien --to-rpm -g intune-portal_${INTUNE_VER}*_amd64.deb

RUN cd intune-portal-$INTUNE_VER \
  && mkdir usr/lib64 \
  && mv usr/lib/x86_64-linux-gnu/security usr/lib64/ \
  && mv ../ubuntu usr/lib64/ \
  && grep -v '^%dir "/\(usr\|usr/share\|usr/share/doc\|usr/lib/tmpfiles.d\|opt\|usr/lib\|lib\|usr/lib/x86_64-linux-gnu\|lib/systemd\|lib/systemd/user\|lib/systemd/system\)/"' intune-portal-${INTUNE_VER}*.spec \
     | sed -e 's#/usr/lib/x86_64-linux-gnu/security#/usr/lib64/security#g' \
           -e 's#\(%files.*\)#%global __requires_exclude ^libcurl\\.so\\.4.*\n%build\npatchelf --set-rpath /usr/lib64/ubuntu $RPM_BUILD_ROOT/opt/microsoft/intune/bin/intune-*\n\1\n/usr/lib64/ubuntu/*#' > new.spec \
  && rpmbuild --buildroot="$PWD" -bb --target x86_64 new.spec

RUN alien --to-rpm -g microsoft-identity-broker_${IDENTITY_VER}_amd64.deb

RUN cd microsoft-identity-broker-$IDENTITY_VER \
  && sed -i 's/-amd64//' usr/lib/systemd/system/microsoft-identity-device-broker.service usr/lib/systemd/user/microsoft-identity-broker.service \
  && sed -i '/.*JAVA_HOME=.*/a Environment="JAVA_OPTS=-Xmx128m -Xss256k -XX:+UseParallelGC -XX:ParallelGCThreads=1"' usr/lib/systemd/system/microsoft-identity-device-broker.service usr/lib/systemd/user/microsoft-identity-broker.service \
  && sed -i 's#JAVA_HOME=/usr/lib/jvm/java-11-openjdk#JAVA_HOME=/usr/lib/jvm/jre-11-openjdk#' usr/lib/systemd/system/microsoft-identity-device-broker.service usr/lib/systemd/user/microsoft-identity-broker.service \
  && grep -v '^%dir "/\(usr\|usr/share\|usr/share/doc\|usr/lib/tmpfiles.d\|opt\|usr/lib\|lib\\|lib/systemd\|lib/systemd/user\|lib/systemd/system\|usr/share/dbus-1\|usr/share/dbus-1/services\|usr/share/dbus-1/system-services\|usr/share/dbus-1/system.d\|usr/lib/sysusers.d\|usr/local\|usr/local/share\)/"' microsoft-identity-broker-${IDENTITY_VER}*.spec | sed '/Release:.*/a Requires: java-11-openjdk-headless' > new.spec \
  && rpmbuild --buildroot="$PWD" -bb --target x86_64 new.spec

RUN alien --to-rpm -g msalsdk-dbusclient_${DBUSCLIENT_VER}_amd64.deb

RUN cd msalsdk-dbusclient-$DBUSCLIENT_VER \
  && mv usr/lib usr/lib64 \
  && grep -v '^%dir "/\(usr\|usr/share\|usr/share/doc\|usr/lib/tmpfiles.d\|opt\|usr/lib\|lib\\|lib/systemd\|lib/systemd/user\|lib/systemd/system\|usr/local\|usr/local/share\)/"' msalsdk-dbusclient-${DBUSCLIENT_VER}*.spec | sed 's#"/usr/lib/#%attr(644, root, root) "/usr/lib64/#g' > new.spec \
  && rpmbuild --buildroot="$PWD" -bb --target x86_64 new.spec

