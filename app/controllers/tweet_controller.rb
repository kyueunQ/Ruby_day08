class TweetController < ApplicationController
    def index
        @tweets = Board.all
        cookies[:user_name] = "규은"
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
        flash[:success] = "새 글이 등록되었습니다."
        redirect_to "/tweet/#{tweet.id}"
    end
    
    def edit
        @tweet = Board.find(params[:id])
    end
    
    def update
        tweet = Board.find(params[:id])
        tweet.contents = params[:contents]
        tweet.save
        flash[:success] = "글이 수정됐습니다."
        redirect_to "/tweet"
    end
    
    def destroy
        tweet = Board.find(params[:id])
        tweet.destroy
        flash[:error] = "글이 삭제됐습니다."
        redirect_to "/tweet"
    end
    
end
