class RoomsController < ApplicationController
    before_action :authenticate_user!

    def create
        @room = Room.create(user_id: current_user.id)
        @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
        @entry2 = Entry.create(params.require(:room).require(:entry).permit(:user_id).merge(room_id: @room.id))
        redirect_to "/rooms/#{@room.id}"
    end

    def show
        @room = Room.find(params[:id])
        if Entry.where(user_id: current_user.id, room_id: @room.id).present?
            @messages = @room.messages
            @message = Message.new
            @entries = @room.entries
            @my_user_id = current_user.id
        else
            redirect_back(fallback_location: root_path)
        end  #if Entry 終わり
    end  #def show 終わり
end  #class 終わり
