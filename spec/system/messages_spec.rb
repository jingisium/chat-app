require 'rails_helper'

RSpec.describe 'メッセージ投稿機能', type: :system do
  before do
    @room_user = FactoryBot.create(:room_user)
  end

  context 'メッセージ投稿が成功した時' do
    it 'テキスト投稿に成功すると、投稿一覧に遷移して、投稿したテキストが表示されている' do
      # サインインする
      sign_in(@room_user.user)
      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)
      # 値をテキストフォームに入力する
      content = Faker::Lorem.sentence
      fill_in 'message_content', with: content
      # 送信した値がDBに保存されていることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)
      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)
      # 送信したテキストが表示されていることを確認する
      expect(page).to have_content(content)
    end
    it '画像投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
      # サインインする
      sign_in(@room_user.user)
      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)
      # 送信した値がDBに保存されていることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)
      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)
      # 送信した画像が表示されていることを確認する
      expect(page).to have_selector("img")
    end
    it 'テキストと画像の投稿に成功すると、投稿一覧に遷移して、投稿したテキストと画像が表示されている' do
      # サインインする
      sign_in(@room_user.user)
      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)
      # 値をテキストフォームに入力する
      content = Faker::Lorem.sentence
      fill_in 'message_content', with: content
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)
      # 送信した値がDBに保存されていることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)
      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)
      # 送信したテキストが表示されていることを確認する
      expect(page).to have_content(content)
      # 送信した画像が表示されていることを確認する
      expect(page).to have_selector("img")
    end
  end
  context 'メッセージ投稿が失敗した時' do
    it '送信する値が空ならば、メッセージ投稿に失敗する' do
      # サインインする
      sign_in(@room_user.user)
      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)
      # DBに保存されていないことを確認する
      expect {
        find('input[name="commit"]').click
      }.not_to change { Message.count }
      # 元のページに戻ってくることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)
    end
  end
end
