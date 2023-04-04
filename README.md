# metadata-extraction-test

## Description

The metadata-extraction-test is an open-source project build to extract metadata from images with ExifTool inside AWS Lambda environment.

## Installation

It is necessary to have docker installed. It can be done following the steps provided in Docker Website (https://docs.docker.com/engine/install/).

After installing, git clone the repository
```
git clone https://github.com/cmflacerda/metadata-extraction-test.git
```
Make sure the docker is active. For Ubuntu distro use the following commands
```
sudo systemctl status docker
# If not active run the next command
sudo systemctl start docker
```
Open the file handler.pl in a text editor and change the `<bucket-name-input>` to the bucket name that you want to read the images, and the `<bucket-name-output>` to the bucket name where the Lambda will write the metadata extracted.
Go to the metadata-extraction-test directory and build the image
```
docker build -t <repo>:<version> .
```
Push the image to the container registry you already use. I pushed mine to ECR. After these steps, you will need to login at AWS and create a Lambda choosing Container Image. This process can be done following the AWS Lambda documentation (https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-images.html)

## Usage

The Lambda image works only for public buckets. Improvement for using in private buckets will be done.

## Credits

The base image used in the Dockerfile (https://github.com/shogo82148/p5-aws-lambda)
