use strict;
use warnings;
use HTTP::Tiny;
use Image::ExifTool;

sub handler {
    my $bucket_name = 'agintel-general-image-bucket-01';
    my $key = 'asdcxeDJI_0492.JPG';
    my $region = 'us-east-2';
    my $url = "https://${bucket_name}.s3.${region}.amazonaws.com/${key}";

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
            body => $metadata_string
        };
    } else {
        die $response->{status} . ' ' . $response->{reason};
    }
}

# test the handler function
handler();

