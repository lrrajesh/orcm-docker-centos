FROM centos:centos6

MAINTAINER Ben McClelland <ben.mcclelland@gmail.com>

RUN yum update -y
RUN yum install -y wget unzip tar git gcc m4 gcc-c++ make flex libtool-ltdl openssl \
                   openssl-devel sigar sigar-devel unixODBC unixODBC-devel xz patch \
                   rpm-build libtool

ENV PATH /usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/opt/open-rcm/bin
ENV LD_LIBRARY_PATH /opt/open-rcm/lib64

RUN wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz && \
    tar xf autoconf-2.69.tar.xz && cd autoconf-2.69 && \
    ./configure --prefix=/usr/local && make && make install && \
    cd .. && rm -rf autoconf-2.69*

RUN wget http://ftp.gnu.org/gnu/automake/automake-1.12.2.tar.xz && \
    tar xf automake-1.12.2.tar.xz && cd automake-1.12.2 && \
    ./configure --prefix=/usr/local && make && make install && \
    cd .. && rm -rf automake-1.12.2*

RUN wget http://ftp.gnu.org/gnu/libtool/libtool-2.4.2.tar.xz && \
    tar xf libtool-2.4.2.tar.xz && cd libtool-2.4.2 && \
    ./configure --prefix=/usr/local && make && make install && \
    cd .. && rm -rf libtool-2.4.2*

RUN wget -nd --reject=*.html* --no-parent -r \
    http://ipmiutil.sourceforge.net/FILES/ipmiutil-2.9.4-1.src.rpm && \
    rpmbuild --rebuild ipmiutil-2.9.4-1.src.rpm && \
    rm -f ipmiutil-2.9.4* && \
    yum -y localinstall /root/rpmbuild/RPMS/x86_64/ipmiutil-2.9.4-1.el6.x86_64.rpm \
                        /root/rpmbuild/RPMS/x86_64/ipmiutil-devel-2.9.4-1.el6.x86_64.rpm

RUN git clone https://github.com/open-mpi/orcm.git && \
    cd orcm && \
    mkdir -p /opt/open-rcm && \
    ./autogen.pl && \
    ./configure --prefix=/opt/open-rcm \
                --with-platform=./contrib/platform/intel/hillsboro/orcm-linux && \
    make -j 4 && \
    make install

ADD orcm-site.xml /opt/open-rcm/etc/orcm-site.xml

RUN echo "export LD_LIBRARY_PATH=/opt/open-rcm/lib64" >>/root/.bashrc
RUN echo "export PATH=/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/opt/open-rcm/bin" >>/root/.bashrc
