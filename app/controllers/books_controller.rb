class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def new
  end

  def create
      @book = Book.new(book_params)
      @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      @user = current_user
      render :index
    end
  end

  def index
    #@books = Book.all
    @book = Book.new
    @user = current_user
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
        sort_by {|x|
        -x.favorites.includes(:favorites).where(created_at: from...to).count
        }
  end

  def show
    @book = Book.find(params[:id])
    #閲覧数を増やす
    @book.increment!(:view_count)
    @new = Book.new
    @user = @book.user
    @book_comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
    flash[:notice] = "You have updated book successfully."
    redirect_to book_path(@book.id)
    else
    render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end


  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == current_user.id
      redirect_to books_path
    end
  end

end
