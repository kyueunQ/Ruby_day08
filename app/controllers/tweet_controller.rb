class TweetController < ApplicationController
    def index
        @tweets = Board.all
    end
    
    def show
        @tweet = Board.find(params[:id])
    end
    
    def new
    end
    
    def create
        tweet = Board.new
        tweet.contents = params[:contents]
        tweet.ip_address = request.ip
        tweet.save
        redirect_to "/tweet"
    end
    
    def edit
        @tweet = Board.find(params[:id])
    end
    
    def update
        tweet = Board.find(params[:id])
        tweet.contents = params[:contents]
        tweet.save
        redirect_to "/tweet"
    end
    
    def destroy
        tweet = Board.find(params[:id])
        tweet.destroy
        redirect_to "/tweet"
    end
    
end
