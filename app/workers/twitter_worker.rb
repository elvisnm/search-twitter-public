class TwitterWorker
  include Sidekiq::Worker

  def perform(q, type_search)
  	case type_search
    when "tweets"
  	  result =  Twitter.search("#{q} -status", count: 5).results.map do |tweet|
                  {user: "#{tweet.user["screen_name"]}", status: "#{tweet.text}"}
                end
    when "hashtags"
  	  result =  Twitter.search("##{q} -rt", count: 5).results.map do |tweet|
                  {user: "#{tweet.user["screen_name"]}", status: "#{tweet.text}"}
                end
    when "users"
  	  result =  Twitter.user_search("#{q}", count: 5).map do |user|
                  {user: "#{user["screen_name"]}", description: "#{user["description"]}"}
                end
    end
    Pusher['twitter-results'].trigger(type_search, {:result => result.to_json, :q => q})
  end
end