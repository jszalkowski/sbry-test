package main

import (
    "expvar"
    "fmt"
    "net/http"
    "io"
    "os"
)

var numCalls = expvar.NewInt("num_calls")
var lastUser = expvar.NewString("last_user")

func HelloServer(w http.ResponseWriter, req *http.Request) {
    user := req.FormValue("user")

    numCalls.Add(1)
    lastUser.Set(user)
    msg := fmt.Sprintf("<!DOCTYPE html>\n<html>\n<script type=\"text/javascript\">setInterval('window.location.reload(true)', 2000);</script>\n<body>\n<br><BR><center>This is Round-Robin test<BR>Site refreshes every 2 seconds<BR> \n<progress value=%s max=50>%s</progress>\n", numCalls)
    h, _ := os.Hostname()
    msgz := fmt.Sprintf("<BR><BR><BR>Hi there, I'm served from %s! (Updated) \n<center></body>\n</html>\n", h)
    io.WriteString(w, msg + msgz )

}






func main() {
    http.HandleFunc("/", HelloServer)
    http.ListenAndServe(":8484", nil)
}
