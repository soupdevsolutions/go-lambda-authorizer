package main

import (
	"context"

	"github.com/aws/aws-lambda-go/lambda"
)

type GetDataResponse struct {
	Data string `json:"data"`
}

func Handle(ctx context.Context) (GetDataResponse, error) {
	return GetDataResponse{
		Data: "Some very important data!",
	}, nil
}

func main() {
	lambda.Start(Handle)
}
