class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per(5).reverse_order
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(8).reverse_order
    @following_users = @user.following_user
    @follower_users = @user.follower_user

    @current_user_entry = Entry.where(user_id: current_user.id)
    @user_entry = Entry.where(user_id: @user.id)

    if @user.id == current_user.id
      # 自分のページなので、何もしない
    else
      @isRoom = false
      # 「部屋はまだない」と仮定しておく
      @current_user_entry.each do |cu|
        break if @isRoom
        @user_entry.each do |u|
          if cu.room_id == u.room_id
            @isRoom = true
            @roomId = cu.room_id
            break
          end  # ← if cu.room_id == u.room_id 終わり
        end  # ← @user_entry.each 終わり
      end  # ← @current_user_entry.each 終わり
      unless @isRoom
        @room = Room.new
        @entry = Entry.new
      end # ← if @isRoom 終わり
    end  # ← if @user.id == current_user.id 終わり
  end  # ← def show 終わり

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def follows
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(3).reverse_order
  end

  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(3).reverse_order
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end

end
