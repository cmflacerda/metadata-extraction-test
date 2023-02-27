FROM amazonlinux:2

# Install the necessary packages for installing Perl and ExifTool
RUN yum -y update && yum -y install perl perl-core zlib-devel openssl-devel gcc make wget tar gzip perl-App-cpanminus perl-MIME-Types && yum clean all

# Download and install Perl
RUN wget https://www.cpan.org/src/5.0/perl-5.34.0.tar.gz && \
    tar -xzf perl-5.34.0.tar.gz && \
    cd perl-5.34.0 && \
    ./Configure -des && \
    make && \
    make install

# Download and install the latest version of ExifTool
ADD Image-ExifTool-12.57.tar.gz /usr/src/
RUN cd /usr/src/Image-ExifTool-12.57 && \
    perl Makefile.PL && \
    make test && \
    make install

#COPY cpanm /usr/bin/cpanm

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any required Perl modules
RUN cpanm File::Which IO::Socket::INET LWP::UserAgent Test::Requires 
RUN cpanm --notest LWP::Protocol::https

RUN cpanm Encode encoding Exporter IO::File IO::Handle List::Util Scalar::Util Unicode::Normalize
#RUN cpanm --notest XML::Parser
#RUN cpanm --notest XML::SAX::Expat
#RUN cpanm --notest XML::SAX
#RUN cpanm --notest XML::Simple

#RUN cpanm File::ShareDir::Install
#RUN cpanm Amazon::S3

#ADD Amazon-S3-0.60.tar.gz /usr/src/
#RUN cd /usr/src/Amazon-S3-0.60 && \
#    perl Makefile.PL && \
#    make test && \
#    make install

# Define the command to run your Perl application
#ENTRYPOINT [ "perl", "-Mawslambdaric", "-e", "awslambdaric::run_handler('handler.pl', \\&handler)" ]

CMD [ "perl", "handler.pl" ]
#COPY handler.pl ${LAMBDA_TASK_ROOT}

#CMD ["handler.handler"]

