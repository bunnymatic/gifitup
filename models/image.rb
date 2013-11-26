class Image
  attr_accessor :filename
  attr_reader :store

  def initialize(filename = nil)
    @filename = filename
  end

  def save
  end

  private
  def store
    if ['MEMCACHIER_SERVERS', 'MEMCACHIER_USERNAME', 'MEMCACHIER_PASSWORD'].all?{|k| ENV.has_key? k}
      memcache_opts = {
        :username => ENV["MEMCACHIER_USERNAME"],
        :password => ENV["MEMCACHIER_PASSWORD"],
        :failover => true,
        :socket_timeout => 1.5,
        :socket_failure_delay => 0.2
      }
      @store ||= Dalli::Client.new(ENV["MEMCACHIER_SERVERS"].split(","), cache_opts)
    else
      @store ||= Dalli::Client.new('localhost:11211')
    end
  end

end
