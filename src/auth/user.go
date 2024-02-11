package auth

import "github.com/golang-jwt/jwt/v5"

type User struct {
	Username string `json:"username"`
	jwt.RegisteredClaims
}
