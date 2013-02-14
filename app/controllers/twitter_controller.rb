class TwitterController < ApplicationController
  def index
  end

  def search
  	q = params["q"]
  	TwitterWorker.perform_async(q, 'tweets')
  	TwitterWorker.perform_async(q, 'hashtags')
  	TwitterWorker.perform_async(q, 'users')
  	
  	respond_to do |format|
  		format.js
  	end
  end
end