# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#

set :output, "/var/www/bluepassers.com/shared/log/cron_log.log"

every 5.minutes do
  runner "FlightMaster.consume_tweets"
end

every 10.minutes do
  runner "FlightMaster.tweet_passengers"
end
