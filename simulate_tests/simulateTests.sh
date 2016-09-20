#!/bin/bash

function error() {
  timestamp=$( date '+%m/%d/%y %H:%M:%S' )
  >&2 printf "ERROR:\t$timestamp\t$1\n"
}

function warn() {
  timestamp=$( date '+%m/%d/%y %H:%M:%S' )
  >&2 printf "WARN:\t$timestamp\t$1\n"
}

function log() {
  timestamp=$( date '+%m/%d/%y %H:%M:%S' )
  printf "LOG:\t$timestamp\t$1\n"
}

log "Starting tests"

log "Response time from /index.php meets SLA with 100 concurrent users"
sleep 10s

log "Response time from /index.php meets SLA with 250 concurrent users"
sleep 13s

warn "Response time from /index.php borderling SLA with 500 concurrent users"
sleep 17s

error "Response time from /index.php below SLA with 1000 concurrent users"

sleep 500
log "Tests completed"
