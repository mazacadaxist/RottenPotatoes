class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.getRatings
    @selected_ratings = @all_ratings
    @order = params[:format]   
   
    if params[:ratings] != nil
      @selected_ratings = params[:ratings].keys
      session["selected_ratings"] = @selected_ratings
    elsif session["selected_ratings"] != nil
      @selected_ratings = session["selected_ratings"]
    end
    
    if @order != nil
      session["index_order"] = @order
    elsif session["index_order"] != nil
      @order = session["index_order"]
    end
    
    @movies = Movie.where("rating" => @selected_ratings).order(@order)
    @all_ratings = Hash[@all_ratings.map {|x| [x, @selected_ratings.include?(x)]}]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
