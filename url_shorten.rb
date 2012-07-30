require 'rubygems'
require 'sinatra'
require 'sqlite3'

db = SQLite3::Database.new('url.db')
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
  new_url = gen
  result = db_retrieve(new_url, params["url"])
  result = result.last
  "<html>
    <body>
    Your new URL is <a href=\"#{result[1]}\">#{result[0]}</a> which redirects to <a href=\"#{result[1]}\">#{result[1]}</a>.<br />
    Test #{result}.<br />
    Return to <a href=/new>entry</a>.
    <body>
  </html>"
end

def gen
  new_url = []
  6.times do 
    new_url << ('A'..'Z').to_a.sample
  end
  new_url = new_url.join.to_s
  new_url
end

def db_retrieve(new, original)
  db = SQLite3::Database.new('url.db')
  #Must be a more concise way to do not exists
  db.execute "insert into url_shortener values ( ?, ? )", new, original
  #full_result = db.execute "select * from url_shortener"
  #puts full_result
  #return full_result
  result = db.execute "select * from url_shortener where url_shortener.url = ?", original
  puts result
  return result
end