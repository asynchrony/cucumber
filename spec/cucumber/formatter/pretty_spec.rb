require File.dirname(__FILE__) + '/../../spec_helper'
require 'stringio'
require 'cucumber/ast'
require 'cucumber/step_mother'
require 'cucumber/formatter/pretty'

require 'cucumber/ast/feature_factory'

module Cucumber
  module Formatter
    describe Pretty do
      include Ast::FeatureFactory

      it "should format itself" do
        step_mother = Object.new
        f = create_feature(step_mother)
        io = StringIO.new
        pretty = Formatter::Pretty.new(step_mother, io, {:source => true})
        pretty.visit_feature(f)

        # Just to ensure that the API is the same
        visitor = Ast::Visitor.new(step_mother)
        visitor.visit_feature(f)

        io.rewind
        io.read.should == %{# My feature comment
\e[34m@one\e[0m \e[34m@two\e[0m
Pretty printing

  # My scenario comment
  # On two lines
  \e[34m@three\e[0m \e[34m@four\e[0m
  Scenario: A Scenario\e[90m                       # features/pretty_printing.feature:9\e[0m
    \e[32mGiven a \e[32m\e[1mpassing\e[0m\e[0m\e[32m step with an inline arg:\e[90m # spec/cucumber/ast/feature_factory.rb:15\e[0m\e[0m
      | \e[32m1   \e[0m | \e[32m22   \e[0m | \e[32m333   \e[0m |
      | \e[32m4444\e[0m | \e[32m55555\e[0m | \e[32m666666\e[0m |
    \e[32mGiven a \e[32m\e[1mhappy\e[0m\e[0m\e[32m step with an inline arg:\e[90m   # spec/cucumber/ast/feature_factory.rb:15\e[0m\e[0m
\e[32m      \"\"\"
      
       I like
      Cucumber sandwich
      
      \"\"\"\e[0m
    \e[31mGiven a \e[31m\e[1mfailing\e[0m\e[0m\e[31m step\e[90m                     # spec/cucumber/ast/feature_factory.rb:17\e[0m\e[0m
\e[31m      I flunked (RuntimeError)
      ./spec/cucumber/ast/../../cucumber/ast/feature_factory.rb:9:in `flunk'
      ./spec/cucumber/ast/../../cucumber/ast/feature_factory.rb:18:in `/^a (.*) step$/'
      features/pretty_printing.feature:12:in `Given a failing step'\e[0m

}
      end
    end
  end
end
