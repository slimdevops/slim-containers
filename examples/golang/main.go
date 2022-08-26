package main

import (
  "net/http"
  "github.com/gin-gonic/gin"
  "os"
)

func main() {
  r := gin.Default()

  r.GET("/", func(c *gin.Context) {
  	host, _ := os.Hostname()
    c.JSON(http.StatusOK, gin.H{"hostname": host})
  })

  r.Run()
}
