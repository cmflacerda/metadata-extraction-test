use strict;
use warnings;
use HTTP::Tiny;
use Image::ExifTool;

$| = 1;

sub handler {

    my ($event, $context) = @_;

    my $bucket_name = 'agintel-general-image-bucket-01';
    #my $asw = 'asdcxeDJI_0492.JPG';
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
        print $metadata_string . "\n";
        return {
            statusCode => 200,
            event => $event,
            a => $asw
            
        };
    } else {
        die $response->{status} . ' ' . $response->{reason};
    }
}

