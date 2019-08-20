class SeasonsController < ApplicationController
  before_action :build_movie_tvshow, only: :show
  def show
    @user = User.new
    @tv_show = TvShow.find_by id: params[:tv_show_id]
    @season = Season.find_by id: params[:id]
  end

  private

  def build_movie_tvshow
    @top_score_movie = Movie.create_top_score
    @top_score_movie_tab = @top_score_movie.take 15

    @top_score_tvshow = TvShow.all.create_top_score
    @top_score_tvshow_tab = @top_score_tvshow.take 15
  end
end