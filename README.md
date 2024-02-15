# go-lambda-authorizer
A simple API Gateway Lambda authorizer written in Go.

## Deploying

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

## Usage

The project contains a login route (which is public), and a protected route (only accessible with an authorization header).

### Login

```bash
curl -X POST https://<api-id>.execute-api.<region>.amazonaws.com/login -d '{"username": "user1"}' | jq .token
```

### Getting data

Use the token returned by `/login` to access the protected route:

```bash
curl -X GET https://<api-id>.execute-api.<region>.amazonaws.com/data -H "Authorization:<token>"
```
