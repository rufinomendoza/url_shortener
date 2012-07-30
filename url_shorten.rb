require 'rubygems'
require 'sinatra'
require 'sqlite3'

db = SQLite3::Database.new('url.sql')
db.execute( "create table if not exists url_shortener (id TEXT PRIMARY KEY, url TEXT);" )

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
  new_url = []
  6.times do 
    new_url << ('A'..'Z').to_a.sample
  end
  new_url = new_url.join.to_s
  #result = db.execute ( "select url_shortener.id, url_shortener.url from url_shortener where url_shortener.id = #{new_url}" )
  #"#{result}"
  "Your new URL is <a href=\"#{params["url"]}\">#{new_url}</a> which redirects to #{params["url"]}"
  {
    "id" => new_url,
    "url" => params["url"],
  }.each do |pair|
    db.execute "insert into url_shortener values ( ?, ? )", pair
  end
end