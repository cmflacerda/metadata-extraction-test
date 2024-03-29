FROM public.ecr.aws/shogo82148/p5-aws-lambda:base-5.36-paws.al2

# Install the necessary packages for installing Perl and ExifTool
RUN yum -y update && yum -y install gcc make wget tar gzip libwww-perl && yum clean all

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


RUN yum install -y python3

# Set the working directory to /app
WORKDIR /app

COPY handler.pl /var/task

# Copy the current directory contents into the container at /app
COPY . /app

CMD ["handler.handler"]
