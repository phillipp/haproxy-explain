# haproxy-explain

Let's say you have the following log-line from a haproxy HTTP log file:

```
Jan 20 15:46:00 localhost haproxy[3167]: 127.0.0.1:38052 [20/Jan/2015:15:46:00.116] http-in zeus-apache/megatron 0/0/6/11/17 200 314 - - ---- 68/20/1/0/0 0/0 - "GET /index.html HTTP/1.0"
```

Now you want to know how long each step of the processing took, how many requests were queued etc. You can look it up the docs, but that takes some time. Why not let it explain to you like this?

`cat your_request.log | ruby explain.rb`

Or from the clipboard:

`cat - | ruby explain.rb`

You will get a nice explanation for each request, like this:

```
[Timings]
Waiting for request:      0 ms
Waiting in queue:         0 ms
Connection to backend:    6 ms (including retries)
Waiting for HTTP headers: 11 ms (without sending data)
Time to transmit data:    0 ms
End-to-End timing:        17 ms

[HTTP Request]
Response code: 200
Bytes read:    314 (314 Bytes)

[Connections and Queueing]
Connections at the time of logging:
Process:  68
Frontend: 20
Backend:  1
Server:   0
Retries:  0

Requests before this one in queues:
Server queue:  0
Backend queue: 0
```

Just for me it's easier to read ;-)

## Installation

Just install `active_support` (fo the number helper) gem and you're all set:

```
gem install activesupport
```
