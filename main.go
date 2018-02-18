package main // import "github.com/bvberkum/x-docker-hub-build-monitor"

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"strings"

	"github.com/PuerkitoBio/goquery"
	"github.com/hoisie/redis"
)

var version = "0.0.2-dev" // x-docker-hub-build-monitor
var redisUrl = flag.String("redis", "localhost:6379", "Redis URL <host ip>:<port>")
var serveAddr = flag.String("serve", ":80", "Interface address and port, <ip>:<port>")
var keyTimeout = flag.Int("cache-timeout", 300, "Time, in seconds, for key expiration")
var assetsDir = flag.String("assets", "/fetcher", "Dir which has assets stored in it")

var Redis redis.Client

func main() {
	flag.Parse()
	Redis = redis.Client{Addr: *redisUrl}
	http.HandleFunc("/", handler)
	http.ListenAndServe(*serveAddr, Log(http.DefaultServeMux))
}

func Log(handler http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s %s %s", r.RemoteAddr, r.Method, r.URL)
		handler.ServeHTTP(w, r)
	})
}

func handler(w http.ResponseWriter, r *http.Request) {

  if r.URL.Path == "/favicon.ico" {
		http.Error(w, "", 404)

  } else if r.URL.Path[1:7] == "status" {
    status, err := lastBuild( r.URL.Path[8:] )
    if err != nil {
      http.Error(w, fmt.Sprintf("%s", err), 500)
    } else {
      w.Header().Set("Content-Type", "text/plain")
      fmt.Fprintf(w, "%s", status)
    }

  } else if r.URL.Path[1:6] == "badge" {
    status, err := lastBuild( r.URL.Path[7:] )
    w.Header().Set("Content-Type", "text/plain")
    if err != nil {
      http.Error(w, fmt.Sprintf("%s", err), 500)
    } else {
      status = *assetsDir + "/" + status + ".svg"
      w.Header().Set("Content-Type", "image/svg+xml")
      http.ServeFile(w, r, status)
    }

  } else if r.URL.Path[1:7] == "builds" {
    repo := r.URL.Path[8:]
    //status, err := cache(repo)
    //if err != nil {
    //	http.Error(w, fmt.Sprintf("%s", err), 500)
    //} else {
      w.Header().Set("Content-Type", "text/plain")
      fmt.Fprintf(w, "TODO: print JSON of buildlog %s", repo)
    //}

  } else {
		http.Error(w, "", 404)

  }
}

func lastBuild(repo string) (string, error) {
  status, err := cache(repo)

  if err != nil {
    return "", err

  } else {

    switch status {
      case "Success": status = "passing"
      case "Error": status = "failing"
      case "Canceled": status = "none"
      default: status = status
    }
    return status, nil
  }
}

func GetBuildStatus(repo string) (string, error) {
	hub_url := "https://hub.docker.com"
	url := fmt.Sprintf("%s/r/%s/builds/", hub_url, repo)

	_, states, err := getBuilds(url)
	if err != nil {
    fmt.Printf("Cannot retrieve url %s: %s\n", url, err)
		return "", err
	}

	return states[0], nil
}

func cache(key string) (string, error) {
	rkey := "hub_repo_status:" + key
	val, err := Redis.Get(rkey)
	if err != nil {
		s, err := GetBuildStatus(key)
		if err != nil {
			return "", err
		}

		val = []byte(s)
		go func() {
			Redis.Set(rkey, val)
			Redis.Expire(rkey, int64(*keyTimeout))
		}()
		return string(val), nil
	}
	return string(val), nil
}

func getBuilds(src string) ([]string, []string, error) {
	var (
		build_ids []string
		states []string
		err error
	)
	doc, err := goquery.NewDocument(src)
	if err != nil {
    return nil, nil, err
	}
  // XXX: would want a partial classname matcher
	//doc.Find("div[class~='BuildDetails__row___'").Each( func(i int, s *goquery.Selection) {
	doc.Find("div.BuildDetails__row___oo2Ml").Each( func(i int, s *goquery.Selection) {
		var (
		  data string
		  exists bool
    )
		data, exists = s.Attr("data-reactid")
		if !exists {
			err = fmt.Errorf("Could not get build details")
		}
    build_ids = append( build_ids, strings.Split(data, ":")[1][1:] )
    status := strings.Trim( s.Find("i.fa.fa-fw").Parent().Text(), " \n\t" )
    states = append( states, status )
	})

  if len(states) == 0 {
		err = fmt.Errorf("Not an autobuild")
    return nil, nil, err
  }

	return build_ids, states, err
}
