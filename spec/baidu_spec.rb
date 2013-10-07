require File.expand_path('../spec_helper.rb', __FILE__)

describe Backup::Storage::Baidu do
  let(:model)   { Backup::Model.new(:test_trigger, 'test label') }
  let(:storage) do
    Backup::Storage::Baidu.new(model) do |db|
      db.api_key      = 'lZUsGbfnXOkwa2tvtZVI1Sn7'
      db.api_secret   = 'qjhCau3p8EIPmZKAHyEArKn19H74FtEj'
      db.keep         = 5
    end
  end

  it 'should be a subclass of Storage::Base' do
    Backup::Storage::Baidu.
      superclass.should == Backup::Storage::Base
  end

  describe '#initialize' do
    after { Backup::Storage::Baidu.clear_defaults! }

    it 'should load pre-configured defaults through Base' do
      Backup::Storage::Baidu.any_instance.expects(:load_defaults!)
      storage
    end

    it 'should pass the model reference to Base' do
      storage.instance_variable_get(:@model).should == model
    end

    it 'should pass the storage_id to Base' do
      storage = Backup::Storage::Baidu.new(model, 'my_storage_id')
      storage.storage_id.should == 'my_storage_id'
    end

  end # describe '#initialize'

  describe '#connection' do
    let (:connection) { mock }
    let (:session) { mock }

    it "should return old connction if it exist" do
      storage.instance_variable_set(:@connection,connection)
      storage.send(:connection).should == connection
    end
  end

  describe '#transfer!' do
    let(:connection) { mock }
    let(:package) { mock }
    let(:file) { mock }
    let(:s) { sequence '' }

    before do
      storage.instance_variable_set(:@package, package)
      Backup::Config.stubs(:tmp_path).returns('/local/path')
      storage.stubs(:connection).returns(connection)
      file.stubs(:read).returns("foo")
    end

    it 'should transfer the package files' do
      pending
      # storage.expects(:remote_path_for).in_sequence(s).with(package).
      #     returns('remote/path')
      # package.stubs(:filenames).returns(['backup.tar.enc-aa','backup.tar.enc-ab'])
      # # first yield
      # Backup::Logger.expects(:info).in_sequence(s).with(
      #   "Storing 'remote/path/backup.tar.enc-aa'..."
      # )
      # connection.expects(:put).in_sequence(s).with(
      #   File.join('remote/path', 'backup.tar.enc-aa'), File.join('/local/path', 'backup.tar.enc-aa')
      # )
      # # second yield
      # Backup::Logger.expects(:info).in_sequence(s).with(
      #   "Storing 'remote/path/backup.tar.enc-ab'..."
      # )
      # connection.expects(:put).in_sequence(s).with(
      #   File.join('remote/path', 'backup.tar.enc-ab'), File.join('/local/path', 'backup.tar.enc-ab')
      # )

      # storage.send(:transfer!)
    end
  end # describe '#transfer!'

  describe '#remove!' do
    let(:package) { mock }
    let(:connection) { mock }
    let(:s) { sequence '' }

    before do
      storage.stubs(:storage_name).returns('Storage::Baidu')
      storage.stubs(:connection).returns(connection)
    end

    it 'should remove the package files' do
      storage.expects(:remote_path_for).in_sequence(s).with(package).
          returns('remote/path')
      # after both yields
      Backup::Logger.expects(:info).in_sequence(s).with(
        "Removeing 'remote/path' from Baidu..."
      )
      connection.expects(:delete).in_sequence(s).with('remote/path')

      storage.send(:remove!, package)
    end
  end # describe '#remove!'


end