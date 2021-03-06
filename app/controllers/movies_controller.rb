class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    unless params[:ratings]
      unless session[:index]
          # Init session with all the ratings selected
          session[:index] = {}
          session[:index][:ratings] = {}
          @all_ratings.each {|r| session[:index][:ratings][r] = true}          
      end
      flash.keep
      # redirect to a RESTFUL route
      redirect_to movies_path(session[:index])
      return
    end

    session[:index] = params

    @movies = Movie.all
    @movies = @movies.where(rating: params[:ratings].keys)
    @movies = @movies.order(:title) if params[:sort_by_title]
    @movies = @movies.order(:release_date) if params[:sort_by_release]
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
