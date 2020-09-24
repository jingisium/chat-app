require 'rails_helper'

RSpec.describe Room, type: :model do
  before do
    @room = FactoryBot.build(:room)
  end

  it 'nameの値が存在すればルーム登録できる' do
    expect(@room).to be_valid
  end

  it 'nameが空ならば登録できない' do
    @room.name = nil
    @room.valid?
    expect(@room.errors.full_messages).to include("Name can't be blank") 
  end
end
