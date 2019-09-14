require_relative '../database'

describe Database do
  let(:db_url) { 'postgres://localhost/framework_dev' }
  let (:queries) do
    {
      create: %{
        create table submissions(name text, email text)
      },
      drop: %{
        drop table if exists submissions
      },
      # create_submission: %{
      #   insert into submissions(name, email)
      #     values ($1, $2)
      # },
      create_submission: %{
        insert into submissions(name, email)
          values ({name}, {email})
      },
      find_submission: %{
        select * from submissions
          where name = {name}
      },
    }
  end
  let(:db) { Database.connect(db_url, queries) }

  before do
    db.drop
    db.create
  end

  it "does not have sql injection vulnerabilities" do
    name = "'; drop table submissions; --"
    email = 'alice@example.com'
    expect { db.create_submission(name: name, email: email) }
      .to change { db.find_submission(name: name).length }
      .by(1)
  end

  it "retrieves records that it has inserted" do
    db.create_submission(name: 'Alice',
                         email: 'alice@example.com')
    alice = db.find_submission(name: 'Alice').fetch(0)
    expect(alice.name).to eq 'Alice'
  end

  it "doesn't care about the order of params" do
    db.create_submission(email: 'alice@example.com',
                         name: 'Alice')
    alice = db.find_submission(name: 'Alice').fetch(0)
    expect(alice.name).to eq 'Alice'
  end
end
