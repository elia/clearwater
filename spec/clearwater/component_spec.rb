require_relative '../../lib/clearwater/component'

module Clearwater
  RSpec.describe Component do
    let(:component) { Class.new { include Clearwater::Component }.new }

    it 'generates html' do
      html = component.div({ id: 'foo', class_name: 'bar' }, [
        component.p("baz"),
      ]).to_s

      expect(html).to eq('<div id="foo" class="bar"><p>baz</p></div>')
    end

    it 'converts styles into strings' do
      html = component.div({
        style: {
          font_size: '24px',
          padding: '3px',
        }
      }, "Hello world!").to_s

      expect(html).to eq('<div style="font-size:24px;padding:3px">Hello world!</div>')
    end
  end
end
