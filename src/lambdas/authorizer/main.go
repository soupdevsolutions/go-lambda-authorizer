package main

import (
	"context"
	"fmt"
	"slices"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"soup.dev/lambda-authorizer/src/auth"
	"soup.dev/lambda-authorizer/src/utils"
)

var validUsers = []string{"user1", "user2"}

type Headers struct {
	Token string `json:"authorization"`
}

type AuthorizerRequest struct {
	Headers   Headers `json:"headers"`
	MethodArn string  `json:"methodArn"`
}

func Handle(ctx context.Context, event *events.APIGatewayV2CustomAuthorizerV2Request) (*events.APIGatewayV2CustomAuthorizerSimpleResponse, error) {
	fmt.Println("Event: ", event)
	username, err := auth.ParseToken(event.Headers["authorization"])
	if err != nil {
		return &events.APIGatewayV2CustomAuthorizerSimpleResponse{}, err
	}
	fmt.Println("Username: ", username)

	if !slices.Contains(validUsers, username) {
		return &events.APIGatewayV2CustomAuthorizerSimpleResponse{
			IsAuthorized: false,
		}, nil
	}

	// Extract the ARN data
	arnData, err := utils.ExtractArn(event.RouteArn)
	if err != nil {
		return &events.APIGatewayV2CustomAuthorizerSimpleResponse{
			IsAuthorized: false,
		}, err
	}
	fmt.Println("ARN data: ", arnData)

	return &events.APIGatewayV2CustomAuthorizerSimpleResponse{
		IsAuthorized: true,
	}, nil
}

func main() {
	lambda.Start(Handle)
}
