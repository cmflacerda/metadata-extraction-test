use strict;                   # Enable strict mode
use warnings;                 # Enable warnings
use HTTP::Tiny;               # Import the HTTP::Tiny library to handle HTTP requests
use Image::ExifTool;          # Import the Image::ExifTool library to extract image metadata
use File::Basename;           # Import the File::Basename library to extract the filename from the object key
use JSON;                     # Import the JSON library to handle JSON data

$| = 1;                       # Disable output buffering

sub handler {

    my ($event, $context) = @_; # Extract the event and context from the input arguments

    # Extract the bucket name and object key from the input event
    my $bucket_name = '<bucket-name-input>'; ## CHANGE THIS LINE
    my $asw = $event->{Records}[0]{s3}{object}{key};

    my $region = 'us-east-2'; # Set the S3 bucket region. Change this for the region you want.
    my $url = sprintf("https://%s.s3.%s.amazonaws.com/%s", $bucket_name, $region, $asw);
    my $http = HTTP::Tiny->new; # Create a new HTTP::Tiny object to handle the HTTP request
    my $response = $http->get($url); # Send a GET request to download the object from S3

    if ($response->{success}) { # Check if the HTTP request was successful
        my $image_data = $response->{content}; # Store the downloaded object content in $image_data

        # Use Image::ExifTool to extract the metadata from the image data
        my $exifTool = Image::ExifTool->new;
        my $info = $exifTool->ImageInfo(\$image_data);
        my $metadata = { metadata => $info }; # Create a hash containing the metadata
        my $metadata_string = join("\n", map { "$_ : $metadata->{metadata}->{$_}" } keys %{$metadata->{metadata}});  # Convert the metadata hash to a string
        
        # Extract the filename, directories, and extension from the object key
        my ($filename, $directories, $extension) = fileparse($asw, qr/\.[^.]*/);
        my $new_key = $filename; # Use the filename as the new key for the text file

        # Construct the URL to upload the metadata text file to another S3 bucket
        my $bucket_name_output = '<bucket-name-output>'; ## CHANGE THIS LINE
        my $upload_url = sprintf("https://%s.s3.%s.amazonaws.com/%s.txt", $bucket_name_output, $region, $new_key);
        my $upload_response = $http->put($upload_url, {
            content => $metadata_string, # Set the content of the text file to the metadata string
            headers => {
                'Content-Type' => 'text/plain', # Set the content type to text/plain
                'x-amz-acl' => 'public-read' # Set the ACL to public-read
            }
        });
        

        if ($upload_response->{success}) { # Check if the HTTP request to upload the text file was successful
            print "Metadata uploaded successfully\n"; # Print a success message to the console
        } else {
            die "Metadata upload failed: " . $upload_response->{status} . " " . $upload_response->{reason}; # Print an error message and terminate the script if the upload fails
        }
        

        # Return a successful response code
        return {
            statusCode => 200            
        };

      } else {
          die $response->{status} . ' ' . $response->{reason};
      }
}

