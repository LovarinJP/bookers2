class BooksController < ApplicationController
  def new
    @book = Book.new
  end

  def create
      @book = Book.new(book_params)
      @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "Book was successfully created"
      redirect_to books_path
    else
      flash[:alert] = "error:Book failed to be created"
      render :new
    end
  end

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
    flash[:notice] = "Book was successfully updated"
    redirect_to book_path(@book.id)
    else
    flash[:alert] = "error:Book failed to be updated"
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
end
