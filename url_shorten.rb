require 'sinatra'
require 'sqlite3'

class ShortenedURL
  def initialize(destination_url)
    @destination_url = destination_url
    @shortened_url = generate_url
    @db = SQLite3::Database.new('url.db')
  end

  def save
    @db.execute("insert into urls values (?, ?)", @destination_url, @shortened_url)
  end

  def shortened
    @shortened_url
  end

  def destination
    @destination_url
  end

  def self.all
    foo = @db.execute("select * from urls")
    foo
  end

  def self.find_by_shortened_url(short_url)
    if short_url &&
      foo = @db.execute("select url from urls where shortened_url = ?", short_url)
      foo = foo[0][0]
      puts foo
      return foo
    end
  end

  private

  def generate_url
    new_url = []
    6.times do
      new_url << ('A'..'Z').to_a.sample
    end
    new_url.join
  end
end

get '/new' do
  "<html>
    <body>
      <form action='/new' method='POST'>
        <input type='url' name='url' placeholder='Enter URL here'>
        <input type='submit' value='GO'>
      </form>
    </body>
  </html>"
end

post '/new' do
  new_url = ShortenedURL.new(params[:url])
  new_url.save
  "Your new URL is #{new_url.shortened} which redirects to #{new_url.destination}"
end

get '/:short_url' do |url|
  redirect ShortenedURL.find_by_shortened_url(url).destination
end

get '/all' do
  "#{ShortenedURL.all}"
end