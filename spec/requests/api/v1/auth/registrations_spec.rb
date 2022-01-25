require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe " POST api/v1/auth " do
    subject { post(api_v1_user_registration_path, params: params) }

    context " 必要なパラメーターが存在するとき " do
      let(:params) { attributes_for(:user) }

      it " ユーザーが新規作成される " do
        expect { subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)
        expect(res["data"]["name"]).to eq params[:name]
        expect(res["data"]["email"]).to eq params[:email]
      end

      it "header 情報を取得することができる" do
        subject
        header = response
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["expiry"]).to be_present
        expect(header["uid"]).to be_present
        expect(header["token-type"]).to be_present
      end
    end

    context " 名前が空欄のとき " do
      let(:params) { attributes_for(:user, name: nil) }
      it "エラーする " do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res["errors"]["name"]).to include("can't be blank")
      end
    end

    context " Eメールが空欄のとき " do
      let(:params) { attributes_for(:user, email: nil) }
      it "エラーする " do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res["errors"]["email"]).to include("can't be blank")
      end
    end

    context " パスワードが空欄のとき " do
      let(:params) { attributes_for(:user, password: nil) }
      it "エラーする " do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res["errors"]["password"]).to include("can't be blank")
      end
    end
  end
end
