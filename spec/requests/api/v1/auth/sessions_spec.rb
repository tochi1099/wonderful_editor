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
end
