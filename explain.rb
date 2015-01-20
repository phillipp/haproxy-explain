require 'active_support'

def explain_request(line)
  timings = line.match(/([0-9]+)\/([0-9]+)\/([0-9]+)\/([0-9]+)\/([\+0-9]+) ([0-9]+) ([0-9]+) ([^ ]+) ([^ ]+) ([^ ]+) ([0-9\/]+) ([0-9\/]+)/)
  if timings
    puts "[Timings]"
    puts "Waiting for request:      #{ActiveSupport::NumberHelper.number_to_delimited timings[1]} ms"
    puts "Waiting in queue:         #{ActiveSupport::NumberHelper.number_to_delimited timings[2]} ms"
    puts "Connection to backend:    #{ActiveSupport::NumberHelper.number_to_delimited timings[3]} ms (including retries)"
    if timings[4] != '-1'
      puts "Waiting for HTTP headers: #{ActiveSupport::NumberHelper.number_to_delimited timings[4]} ms (without sending data)"
    else
      puts "Waiting for HTTP headers: ABORTED!"
    end
    td = timings[5].to_i - (timings[1].to_i + timings[2].to_i + timings[3].to_i) + timings[4].to_i
    puts "Time to transmit data:    #{ActiveSupport::NumberHelper.number_to_delimited td} ms"
    puts "End-to-End timing:        #{ActiveSupport::NumberHelper.number_to_delimited timings[5]} ms#{timings[5].start_with?('+') ? ' (logasap is turned on, timing is not complete!)' : ''}"
    puts ""
    puts "[HTTP Request]"
    puts "Response code: #{timings[6]}"
    puts "Bytes read:    #{timings[7]} (#{ActiveSupport::NumberHelper.number_to_human_size timings[7].to_i})"
    puts ""

    actconn, feconn, beconn, srvconn, retries = timings[11].split('/')
    srv_queue, be_queue = timings[12].split('/')

    puts "[Connections and Queueing]"
    puts "Connections at the time of logging:"
    puts "Process:  #{ActiveSupport::NumberHelper.number_to_delimited actconn}"
    puts "Frontend: #{ActiveSupport::NumberHelper.number_to_delimited feconn}"
    puts "Backend:  #{ActiveSupport::NumberHelper.number_to_delimited beconn}"
    puts "Server:   #{ActiveSupport::NumberHelper.number_to_delimited srvconn}"
    puts "Retries:  #{ActiveSupport::NumberHelper.number_to_delimited retries}"
    puts ""
    puts "Requests before this one in queues:"
    puts "Server queue:  #{ActiveSupport::NumberHelper.number_to_delimited srv_queue}"
    puts "Backend queue: #{ActiveSupport::NumberHelper.number_to_delimited be_queue}"
  end
end

while line = ARGF.gets
  explain_request(line)
end
