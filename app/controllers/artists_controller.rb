class ArtistsController < ApplicationController
require 'open-uri'
	before_action :authenticate_user!


	def searchartist
		if params[:search].present?
			user_history=SearchHistory.where("email" => current_user.email).first
			if !user_history.present?
				user_history=SearchHistory.new
				user_history.email=current_user.email
			end
			user_history.history.push(params[:search])
			user_history.save

			@artist= JSON.load(open(URI.encode("http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=#{params[:search]}&api_key=8d53ac6cc65b018b652167d3f2b596a1&format=json")))
			@similar_artists=JSON.load(open(URI.encode("http://ws.audioscrobbler.com/2.0/?method=artist.getsimilar&artist=#{params[:search]}&api_key=8d53ac6cc65b018b652167d3f2b596a1&format=json")))
			if @artist["results"].present?
				@artist=@artist["results"]["artistmatches"]["artist"]
				if @similar_artists["similarartists"].present?
					@similar_artists_list=@similar_artists["similarartists"]["artist"] 
			 	else
			 		@similar_artists__message=@similar_artists["message"]
			 	end
			 else
			 		fail
			 		@message="Sorry no artist is present"
			 		@artist=nil
			end
		end
		
	end
	def history
		@user_history=SearchHistory.where("email" => current_user.email).first
	end
end
