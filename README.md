# go-lambda-authorizer
A simple API Gateway Lambda authorizer written in Go.

## Usage

### Build
To build the Lambda functions, you can run the Python script:

```bash
python3 scripts/build.py
```

### Deploy
To deploy all the `tofu` resources, you can use the build command first, and then run the `tofu apply` command.  
This step does require an S3 bucket as the `tofu` backend, so make sure to change the value in `infrastructure/main.tf` and **manually** create the bucket in your account.
```bash
python3 scripts/build.py
tofu -chdir=infrastructure apply -auto-approve
```

OR you can use the `just` command:

```bash
just deploy
```
