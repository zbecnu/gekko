require_relative '../spec_helper'

describe 'Gekko::Command' do

  before(:each) do
    logger     = mock(Logger)
    @connection = mock(Gekko::Connection)

    logger.stub!(:error)
    @connection.stub(:logger).and_return(logger)
  end

  describe '.parse' do
    it 'should parse a command' do
      cmd = '{ "command" : "order", "args" : { "category" : "buy", "amount" : 100000000 }}'
      enable_logger do
        EM.run do
          Gekko::Command.build(cmd, @connection).should be_kind_of Gekko::Command
          EM.stop
        end
      end
    end

    it 'should fail to parse invalid JSON' do
      expect { Gekko::Command.build('foo', @connection) }.to raise_error
    end
  end
end
