package main

import (
	"context"

	"log"

	"github.com/aws/aws-lambda-go/lambda"
	"soup.dev/lambda-authorizer/src/auth"
)

type LoginRequest struct {
	Username string `json:"username"`
}

type LoginResponse struct {
	Token string `json:"token"`
}

func Handle(ctx context.Context, request *LoginRequest) (LoginResponse, error) {
	token, err := auth.CreateToken(request.Username)
	if err != nil {
		log.Println("error while creating token: ", err)
		return LoginResponse{}, err
	}

	return LoginResponse{Token: token}, nil
}

func main() {
	lambda.Start(Handle)
}
