package utils

import (
	"errors"
	"strings"
)

type MethodArn struct {
	Region    string `json:"region"`
	AccountId string `json:"accountId"`
	ApiId     string `json:"apiId"`
	Stage     string `json:"stage"`
}

func ExtractArn(arn string) (MethodArn, error) {
	arnData := strings.Split(arn, ":")
	if len(arn) != 6 {
		return MethodArn{}, errors.New("invalid ARN")
	}
	methodData := strings.Split(arnData[5], "/")
	if len(methodData) != 2 {
		return MethodArn{}, errors.New("invalid ARN")
	}

	return MethodArn{
		Region:    arnData[3],
		AccountId: arnData[4],
		ApiId:     methodData[0],
		Stage:     methodData[1],
	}, nil
}

func (m *MethodArn) String() string {
	return "arn:aws:execute-api:" + m.Region + ":" + m.AccountId + ":" + m.ApiId + ":" + m.Stage + ":*/*/*"
}
