module WildSoNet
  module Hazelcast

    java_import "com.hazelcast.core.Hazelcast"

    def self.start
      @config = Config.new
      @instance = Hazelcast.newHazelcastInstance(@config)
    end

    def self.queue name
      Hazelcast.getQueue(name)
    end

    def self.map name
      Hazelcast.getMap(name)
    end

  end
end