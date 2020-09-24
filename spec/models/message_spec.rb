require 'rails_helper'

RSpec.describe Message, type: :model do
  before do
    @message = FactoryBot.build(:message)
  end 

  context 'メッセージが保存できる時' do
    it 'contentとimageの両方が存在するならば保存できる' do
      expect(@message).to be_valid
    end
    it 'contentが空でもimageが存在すれば保存できる' do
      @message.content = nil
      expect(@message).to be_valid
    end
    it 'imageが存在しなくてもcontentの値が存在すれば保存できる' do
      @message.image = nil
      expect(@message).to be_valid
    end
  end
  context 'メッセージが保存できない時' do
    it 'contentとimageの両方が空ならば保存できない' do
      @message.content = nil
      @message.image = nil
      @message.valid?
      expect(@message.errors.full_messages).to include("Content can't be blank")
    end
    it 'userが紐づいていないと保存できない' do
      @message.user = nil
      @message.valid?
      expect(@message.errors.full_messages).to include("User must exist")
    end
    it 'roomが紐づいていないと保存できない' do
      @message.room = nil
      @message.valid?
      expect(@message.errors.full_messages).to include("Room must exist")
    end
  end
end
