package main

import (
	"context"
	"slices"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"soup.dev/lambda-authorizer/src/auth"
	"soup.dev/lambda-authorizer/src/utils"
)

var validUsers = []string{"user1", "user2"}

type AuthorizerRequest struct {
	Token     string `json:"authorizationToken"`
	MethodArn string `json:"methodArn"`
}

func Handle(ctx context.Context, request *AuthorizerRequest) (events.APIGatewayCustomAuthorizerResponse, error) {
	username, err := auth.ParseToken(request.Token)
	if err != nil {
		return events.APIGatewayCustomAuthorizerResponse{}, err
	}

	if !slices.Contains(validUsers, username) {
		return events.APIGatewayCustomAuthorizerResponse{}, nil
	}

	// Extract the ARN data
	arnData, err := utils.ExtractArn(request.MethodArn)
	if err != nil {
		return events.APIGatewayCustomAuthorizerResponse{}, err
	}

	return events.APIGatewayCustomAuthorizerResponse{
		PrincipalID: username,
		PolicyDocument: events.APIGatewayCustomAuthorizerPolicy{
			Version: "2012-10-17",
			Statement: []events.IAMPolicyStatement{
				{
					Action:   []string{"execute-api:Invoke"},
					Effect:   "Allow",
					Resource: []string{arnData.String()},
				},
			},
		},
	}, nil
}

func main() {
	lambda.Start(Handle)
}
