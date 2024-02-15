# builds the lambda functions and copies them to the infrastructure folder
import os

base_command = "GOOS=linux GOARCH=amd64 go build -tags lambda.norpc -o bootstrap {path}/main.go"

functions = [name for name in os.listdir("src/lambdas/")]

commands = ["mkdir -p infrastructure/data/lambdas"]

for function in functions:
    commands.extend([
        base_command.format(path=f"src/lambdas/{function}"),
        f"zip infrastructure/data/lambdas/{function}.zip bootstrap",
        ]
    )
os.system("; ".join(commands))
