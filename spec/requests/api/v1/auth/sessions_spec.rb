require "rails_helper"

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe " POST api/v1/auth/sign_in " do
    subject { post(api_v1_user_session_path, params: params) }

    context " 必要なパラメーターが存在しているとき " do
      let(:params) { attributes_for(:user, email: user.email, password: user.password) }
      let(:user) { create(:user) }

      it " ログインできる " do
        subject
        header = response.header
        expect(response).to have_http_status(:ok)
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["uid"]).to be_present
      end
    end

    context " パスワードが違うとき " do
      let(:params) { attributes_for(:user, email: user.email, password: "holo") }
      let(:user) { create(:user) }

      it " ログインできない " do
        subject
        header = response.header
        res = JSON.parse(response.body)
        expect(res["errors"]).to include("Invalid login credentials. Please try again.")
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["uid"]).to be_blank
      end
    end

    context " Eメールが違うとき " do
      let(:params) { attributes_for(:user, email: "holo", password: user.password) }
      let(:user) { create(:user) }

      it " ログインできない " do
        subject
        header = response.header
        res = JSON.parse(response.body)
        expect(res["errors"]).to include("Invalid login credentials. Please try again.")
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["uid"]).to be_blank
      end
    end
  end

  describe " DELETE api/v1/auth/sign_out " do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    context " ログアウトに必要な情報が送信されたとき " do
      let(:user) { create(:user) }
      let(:headers) { user.create_new_auth_token }

      it " ログアウトできる " do
        subject
        expect(user.reload.tokens).to be_blank
        expect(response).to have_http_status(:ok)
      end
    end

    context " ログアウトに必要な情報が送信されなかったとき " do
      let(:user) { create(:user) }
      let(:headers) { { "access-token" => "nil", "client" => "nil", "uid" => "nil" } }

      it " エラーする " do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to include("User was not found or was not logged in.")
      end
    end
  end
end
