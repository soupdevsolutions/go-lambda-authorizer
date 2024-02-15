package auth

import (
	"fmt"
	"log"

	"github.com/golang-jwt/jwt/v5"
)

var key []byte = []byte("secret")

func CreateToken(username string) (string, error) {
	jwt := jwt.NewWithClaims(
		jwt.SigningMethodHS256,
		jwt.MapClaims{
			"username": username,
		},
	)
	token, err := jwt.SignedString(key)
	if err != nil {
		log.Println("error while creating JWT: ", err)
		return "", err
	}
	return token, nil
}

func ParseToken(token string) (string, error) {
	jwtToken, err := jwt.ParseWithClaims(token, &User{}, func(t *jwt.Token) (interface{}, error) {
		return key, nil
	})
	fmt.Println("JWT token:", jwtToken)
	if err != nil {
		log.Println("error while parsing JWT: ", err)
		return "", err
	}

	if !jwtToken.Valid {
		log.Println("invalid JWT token")
		return "", err
	}

	fmt.Println("JWT claims:", jwtToken.Claims)

	user, ok := jwtToken.Claims.(*User)
	if !ok {
		log.Println("error while parsing JWT: ", err)
		return "", err
	}
	return user.Username, nil
}
