package main

import (
	"context"
	"encoding/json"

	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"soup.dev/lambda-authorizer/src/auth"
)

type LoginRequest struct {
	Username string `json:"username"`
}

type LoginResponse struct {
	Token string `json:"token"`
}

func Handle(ctx context.Context, event *events.APIGatewayProxyRequest) (*LoginResponse, error) {
	request := LoginRequest{}
	err := json.Unmarshal([]byte(event.Body), &request)
	if err != nil {
		log.Println("error while unmarshalling request: ", err)
		return &LoginResponse{}, err
	}

	token, err := auth.CreateToken(request.Username)
	if err != nil {
		log.Println("error while creating token: ", err)
		return &LoginResponse{}, err
	}

	return &LoginResponse{Token: token}, nil
}

func main() {
	lambda.Start(Handle)
}
