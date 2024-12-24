class ChatsController < ApplicationController

  def show
    @user = User.find(params[:id])
    #現在のユーザーが参加しているチャットルームの一覧を取得
    rooms = current_user.user_rooms.pluck(:room_id)
    #相手と共通のルームがあるか確認
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    unless user_rooms.nil?
      #ルームがあるときそのルームを表示
      @room = user_rooms.room
    else
      #存在しない場合新しいルームを作成
      @room = Room.new
      @room.save

      #ルームに現在のユーザーと相手を追加
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    #関連付けられたメッセーじの取得
    @chats = @room.chats
    #新しいメッセージを作成するための空のオブジェクト
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    #フォームから送信されたメッセージを取得し現在のユーザーに関連付けて保存
    @chat = current_user.chats.new(chat_params)
    @chat.save
  end

private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

end

