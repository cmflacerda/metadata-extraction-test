#!/bin/sh

# Run the Perl handler
/opt/bin/perl /app/handler.pl

# Check the exit status of the Perl command
if [ $? -ne 0 ]; then
  # The Perl command failed, so exit with an error message
  echo "Error: Perl handler failed" >&2
  exit 1
fi

# The Perl command succeeded, so exit with a success message
echo "Success: Perl handler completed"
exit 0

