class UserSessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to :root
    else
      @user = User.new
    end
  end
  
  def create
    respond_to do |format|
      anonymous_cart = cart
      if user = login(params[:username],params[:password])
        cart.merge_cart_items(anonymous_cart)
        format.html { redirect_back_or_to(:root, :notice => 'Login successful.') }
        format.xml { render :xml => user, :status => :created, :location => user }
      else
        format.html { flash.now[:alert] = "Login failed."; render :action => "new" }
        format.xml { render :xml => user.errors, :status => :unprocessable_entity }
      end
    end
  end
    
  def destroy
    logout
    redirect_to(:root, :notice => 'Logged out!')
  end
end
