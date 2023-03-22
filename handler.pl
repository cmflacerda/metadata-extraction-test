use strict;
use warnings;
use HTTP::Tiny;
use Image::ExifTool;
use File::Basename;
use JSON;

$| = 1;

sub handler {

    my ($event, $context) = @_;

    my $bucket_name = 'agintel-general-image-bucket-01';
    my $asw = $event->{Records}[0]{s3}{object}{key};
    my $region = 'us-east-2';
    my $url = sprintf("https://%s.s3.%s.amazonaws.com/%s", $bucket_name, $region, $asw);
    my $http = HTTP::Tiny->new;
    my $response = $http->get($url);

    if ($response->{success}) {
        my $image_data = $response->{content};
        my $exifTool = Image::ExifTool->new;
        my $info = $exifTool->ImageInfo(\$image_data);
        my $metadata = { metadata => $info };
        my $metadata_string = join("\n", map { "$_ : $metadata->{metadata}->{$_}" } keys %{$metadata->{metadata}});
        
        #Writing the data on another bucket
        my ($filename, $directories, $extension) = fileparse($asw, qr/\.[^.]*/);
        my $new_key = $filename;

        my $upload_url = sprintf("https://%s.s3.%s.amazonaws.com/%s.txt", 'agintel-upload-bucket', $region, $new_key);
        my $upload_response = $http->put($upload_url, {
            content => $metadata_string,
            headers => {
                'Content-Type' => 'text/plain',
                'x-amz-acl' => 'public-read'
            }
        });
        

        if ($upload_response->{success}) {
            print "Metadata uploaded successfully\n";
        } else {
            die "Metadata upload failed: " . $upload_response->{status} . " " . $upload_response->{reason};
        }


        return {
            statusCode => 200            
        };

      } else {
          die $response->{status} . ' ' . $response->{reason};
      }
}

