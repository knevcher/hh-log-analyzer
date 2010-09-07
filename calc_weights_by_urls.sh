gawk -v parsing_interval=$1 -v needle_precedent=$2 '
  BEGIN{
    current_timestamp =  systime()
    starting_timestamp = current_timestamp - parsing_interval
    request_count = 0
    min_request_weight = 0
    max_request_weight = 0
    first_interval_count = 0
    second_interval_count = 0
  }
{
  log_timestamp = $5

  if(log_timestamp >= starting_timestamp)
  {

    split($12, url, "?");

    is_ids = match(url[1], /\/(([0-9]+)(,|))+/)
    if(is_ids)
      gsub(/\/(([0-9]+)(,|))+/, "/IDS", url[1]);

    is_params = match(url[1], /\/([0-9a-zA-Z]+),(([0-9a-zA-Z]+)(,|))+/)
    if(is_params && !is_ids)
      gsub(/\/([0-9a-zA-Z]+),(([0-9a-zA-Z]+)(,|))+/, "/PARAMS", url[1]);

    current_url = url[1]
    status = $11

    current_precedent = substr(status""current_url, 2)
    if(current_precedent == needle_precedent)
    {
      request_count += 1;

      if($4 > 2)
        second_interval_count += 1
      else if($4 > 1)
        first_interval_count += 1

      temp_max = $4;
      if (temp_max > max_request_weight)
        max_request_weight = temp_max;

      temp_min = $4;
      if (min_request_weight == 0)
        min_request_weight = temp_min;
      else if( min_request_weight > temp_min)
        min_request_weight = temp_min;

      if(min_log_timestamp == 0)
        min_log_timestamp = log_timestamp
    }
  }
}
END{
  if(request_count > 0)
  {
    print  "request_count:"request_count" min_request_weight:"min_request_weight" max_request_weight:"max_request_weight" first_interval_count:"first_interval_count" second_interval_count:"second_interval_count;
  }
}'
