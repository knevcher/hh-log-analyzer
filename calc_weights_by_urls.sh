gawk -v parsing_interval=$1 '
  BEGIN{
    current_timestamp =  systime()
    starting_timestamp = current_timestamp - parsing_interval
  }
{
  log_timestamp = $5

  if(log_timestamp >= starting_timestamp)
  {
    split($12, url, "?");
    gsub(/[0-9]+/, "ID", url[1]);

    current_url = url[1]
    status = $11

    total_requests_weight += $4;
    total_requests_counter += 1;

    urls_weights[status" "current_url] += $4;
    requests_count[status" "current_url] += 1;

    temp_max = $4;
    if (temp_max > max_request_weight[status" "current_url]) max_request_weight[status" "current_url] = temp_max;

    temp_min = $4;
    if (min_request_weight[status" "current_url] == 0) min_request_weight[status" "current_url] = temp_min;
    else if( min_request_weight[status" "current_url] > temp_min) min_request_weight[status" "current_url] = temp_min;

    if(min_log_timestamp == 0)
      min_log_timestamp = log_timestamp
  }
}
END{
  if(total_requests_counter > 0)
  {
    print " "
    print " logs since "strftime("%a %b %d %H:%M:%S %Z %Y", min_log_timestamp)" until "strftime("%a %b %d %H:%M:%S %Z %Y", current_timestamp)
    print " Total requests counter:"total_requests_counter;
    print " Total requests weight:"total_requests_weight;
    for(i in urls_weights)
    {
      print urls_weights[i] ";" i ";" requests_count[i] ";" min_request_weight[i] ";" max_request_weight[i];
    }
  }
  else
  {
    print " worked on " strftime("%a %b %d %H:%M:%S %Z %Y", current_timestamp)
  }
}'