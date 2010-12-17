require 'rack/session/abstract/id'
require 'rack/request'
require 'rack/response'

require 'digest/sha1'

module WildSoNet

  module Hazelcast

    class SessionStore

      def initialize app, config
        @app = app
      end

      def generate_sid
        Digest::SHA1.hexdigest(Kernel.rand(1000).to_s + Time.current.to_i.to_s)
      end

      def call env
        self.get_session(env)
        status, headers, content = @app.call(env)
        self.set_session(status, headers, content, env)
      end

      def set_session status, headers, content, env
        sid = env["students.session.id"]
        response = ::Rack::Response.new(content, status, headers)
        response.set_cookie("session.id", sid)
        response.to_a
      end

      def get_session env
        sid = ::Rack::Request.new(env).cookies["session.id"]
        sid = self.generate_sid if not sid
        env["rack.session"] = Session.new(sid)
        env["students.session.id"] = sid
      end

    end

    class Session

      def initialize sid
        @data = WildSoNet::Hazelcast.map("session.#{sid}")
      end

      def [] key
        value = @data[key.to_s]
        value ? Marshal.load(value) : value
      end

      def []= key, value
        @data[key.to_s] = Marshal.dump(value.to_s)
      end

      def clear
        @data.clear
      end

      def delete key
        @data.remove(key.to_s)
      end

      def destroy
        @data.clear
      end

      def key? key
        @data.containsKey(key.to_s)
      end

    end

  end

end