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
    @rating_checked = {}
    params[:commit] ? is_checked = false : is_checked = true
    @all_ratings.each {|r| @rating_checked[r] = is_checked}
    @all_ratings.each {|r| @rating_checked[r] = true if params[:ratings][r]} if params[:ratings]

    @movies = Movie.all
    @movies = @movies.where(rating: params[:ratings].keys) if params[:ratings]
    if params[:sort_by_title]
      @sort_by_title = 1
      @movies = @movies.order(:title)
    end
    if params[:sort_by_release]
      @sort_by_release = 1
      @movies = @movies.order(:release_date)
    end    
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
