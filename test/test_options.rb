#! /usr/bin/env ruby

require 'test/unit'
require 'snooper/options'
require 'snooper/version'

require 'utils'

class TestOptions < Test::Unit::TestCase

  def test_parse
    arguments = []
    opts = Snooper::Options.parse arguments
    assert opts
    assert_not_equal nil, opts.config_path #shoudl at least find our config..
    assert opts.command == nil

    arguments = ['this is a command']
    opts = Snooper::Options.parse arguments
    assert opts
    assert opts.command == 'this is a command'
    
    arguments = %w{-c config_name command}
    opts = Snooper::Options.parse arguments
    assert opts.config_path == 'config_name'
    assert opts.command == 'command'

    arguments = %w{--config foo_bar.baz}
    opts = Snooper::Options.parse arguments
    assert opts.config_path == 'foo_bar.baz'
    assert opts.command == nil
  end

  def test_exits
    assert_raise SystemExit do
      TestUtils.silent do
        Snooper::Options.parse %w{-h}
      end
    end
    assert_raise SystemExit do
      TestUtils.silent do
        Snooper::Options.parse %w{--help}
      end
    end
    assert_raise SystemExit do
      TestUtils.silent do
        Snooper::Options.parse %w{-h -c config_file}
      end
    end
    assert_raise SystemExit do
      TestUtils.silent do
        Snooper::Options.parse %w{-c config_file --help}
      end
    end
  end

  def test_version
    assert_raise SystemExit do
      TestUtils.silent do
        out = Snooper::Options.parse %w{--version}
      end
    end
    assert_raise SystemExit do
      TestUtils.silent do
        out = Snooper::Options.parse %w{--config configfile --version command string}
      end
    end
  end
end
