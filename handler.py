import subprocess
import os

def lambda_handler():
   #with open("/opt/lib/perl5/vendor_perl/5.36.0/AWS/Lambda/Bootstrap.pm", "r") as file:
   #  f = file.read()

   print(f)
   for key, value in os.environ.items():
    if "AWS_LAMBDA_FUNCTION_NAME" in key:
        print(f"{key}: {value}")
   print("Starting process")
   result = subprocess.run(["/opt/bin/perl", "/app/handler.pl"])
   print(result)
   print("Finishing process")

   return {
     'code': 200
   }

if __name__ == '__main__':

   lambda_handler()
