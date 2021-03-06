require_relative './framework'
require_relative './database'
require_relative './queries'
require_relative './templates'

DB = Database.connect('postgres://localhost/framework_dev',
                      QUERIES)

TEMPLATES = Templates.new('views')

APP = App.new do
  get '/' do
    [1, 2, 3]
    # 'This is the root!'
  end

  get '/users/:username' do |params|
    "This is #{params.fetch('username')}!"
  end

  get '/submissions' do |params|
    DB.all_submissions
  end

  get '/submissions/:name' do |params|
    name = params.fetch('name')
    user = DB.find_submission_by_name(name: name).fetch(0)
    TEMPLATES.submissions_show(user: user)
  end
end
