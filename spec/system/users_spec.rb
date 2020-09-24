require 'rails_helper'

RSpec.describe 'ユーザーログイン機能', type: :system do
  it 'ログインしていない状態でトップページに移動した場合、サインインページに遷移する' do
    # トップページに移動する
    visit root_path
    # サインインページに遷移していることを確認する
    expect(current_path).to eq new_user_session_path
  end

  it 'ログインに成功すると、トップページに遷移する' do
    # 予めユーザー情報をDBに保存する
    @user = FactoryBot.create(:user)
    # トップページに移動する
    visit root_path
    # ログインしていないため、サインインページに遷移することを確認する
    expect(current_path).to eq new_user_session_path
    # 保存済みのユーザーのemailとpasswordを入力する
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    # ログインボタンをクリックする
    click_on('Log in')
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
  end

  it 'ログインに失敗すると、再びサインインページに戻ってくる' do
    # 予めユーザー情報をDBに保存する
    @user = FactoryBot.create(:user)
    # トップページに移動する
    visit root_path
    # ログインしていないため、サインインページに遷移することを確認する
    expect(current_path).to eq new_user_session_path
    # 誤ったemailとpasswordを入力する
    fill_in 'Email', with: 'test'
    fill_in 'Password', with: 'test'
    # ログインボタンをクリックする
    click_on('Log in')
    # サインインページに戻されたことを確認する
    expect(current_path).to eq new_user_session_path
  end

end
