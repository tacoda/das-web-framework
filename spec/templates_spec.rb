require_relative '../templates'

# Class is to make namespacing easier
class Templates
  describe Template do
    it 'renders templates' do
      # ~ in here doc declaration trims whitespace to the left
      source = <<~END
        div
          p
            | User:
          p
            = email
      END

      expected = <<~END
        <div>
          <p>
            User:
          </p>
          <p>
            alice@example.com
          </p>
        </div>
      END

      rendered = Template.new(source).render(email: 'alice@example.com')
      expect(rendered).to eq expected
    end
  end
end
