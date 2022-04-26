require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "return blog posts" do

      user = User.create!(name: "Test", email: "test@test.com", password: "password")

      Post.create!(user_id: user.id, title: Faker::Company.catch_phrase, body: Faker::Hipster.paragraph(sentence_count: 6), image: "https://i.picsum.photos/id/302/200/300.jpg?hmac=b5e6gUSooYpWB3rLAPrDpnm8PsPb84p_NXRwD-DK-1I")
      Post.create!(user_id: user.id, title: Faker::Company.catch_phrase, body: Faker::Hipster.paragraph(sentence_count: 6), image: "https://i.picsum.photos/id/131/200/300.jpg?hmac=9q7mRSOguNBFGg_gPPRKlfjNINGjXWeDBTYPP1_gEas")
      Post.create!(user_id: user.id, title: Faker::Company.catch_phrase, body: Faker::Hipster.paragraph(sentence_count: 6), image: "https://i.")

      get "/posts"
      posts = JSON.parse(response.body)
      
      expect(response).to have_http_status(200)
      expect(posts.length).to eq(3)
    end
  end

  describe "GET /posts/:id" do
    it "should return the attributes of one specific post" do

      title = Faker::Company.catch_phrase
      body = Faker::Hipster.paragraph(sentence_count: 6)

      user = User.create!(name: "Test", email: "test@test.com", password: "password")

      post = Post.create!(user_id: user.id, title: Faker::Company.catch_phrase, body: Faker::Hipster.paragraph(sentence_count: 6), image: "https://i.picsum.photos/id/302/200/300.jpg?hmac=b5e6gUSooYpWB3rLAPrDpnm8PsPb84p_NXRwD-DK-1I")

      get "/posts/#{post.id}"
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["title"]).to eq(post["title"])
      expect(post["body"]).to eq(post["body"])

    end
  end

  describe "POST /recipes" do
    it "creates a new blog post" do

      user = User.create!(name: "Test", email: "test@test.com", password: "password")

      jwt = JWT.encode(
        {user_id: user.id, exp: 24.hours.from_now.to_i},
        Rails.application.credentials.fetch(:secret_key_base), "HS256"
      )
      
      post "/posts",
      params: {
        user_id: user.id,
        title: "Test Title",
        body: "Blah blah blah words words words.",
        image: "an_image_url"
      },
      headers: {"Authorization" => "Bearer #{jwt}"}

      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["title"]).to eq("Test Title")
      expect(post["body"]).to eq("Blah blah blah words words words.")
    end
  end

end
