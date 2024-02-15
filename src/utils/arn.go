package utils

import (
	"errors"
	"strings"
)

type RouteArn struct {
	Region    string `json:"region"`
	AccountId string `json:"accountId"`
	ApiId     string `json:"apiId"`
	Stage     string `json:"stage"`
}

func ExtractArn(arn string) (RouteArn, error) {
	arnData := strings.Split(arn, ":")
	if len(arnData) != 6 {
		return RouteArn{}, errors.New("invalid ARN")
	}
	routeData := strings.Split(arnData[5], "/")
	if len(routeData) != 4 {
		return RouteArn{}, errors.New("invalid ARN")
	}

	return RouteArn{
		Region:    arnData[3],
		AccountId: arnData[4],
		ApiId:     routeData[0],
		Stage:     routeData[1],
	}, nil
}

func (m *RouteArn) String() string {
	return "arn:aws:execute-api:" + m.Region + ":" + m.AccountId + ":" + m.ApiId + ":" + m.Stage + ":*/*/*"
}
