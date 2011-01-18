require 'rack/session/abstract/id'
require 'rack/request'
require 'rack/response'

require 'digest/sha1'

module Wildsonet

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
        session = env["rack.session"]
        Wildsonet::Hazelcast.map("sessions").put(sid, Marshal.dump(session.extract)) if session.changed? or session.cleared?
        response.set_cookie("session.id", sid)
        response.to_a
      end

      def get_session env
        sid = ::Rack::Request.new(env).cookies["session.id"]
        sid = self.generate_sid if not sid
        data = Wildsonet::Hazelcast.map("sessions").get(sid)
        unless data
          data = {}
        else
          data = Marshal.load(data)
        end
        env["rack.session"] = Session.new(data)
        env["students.session.id"] = sid
      end

    end

    class Session

      def initialize data
        @data = data
        @changes = {}
        @cleared = false
        @changed = false
      end

      def [] key
        if @changes[key]
          @changes[key]
        else
          @data[key]
        end
      end

      def []= key, value
        @changes[key] = value
        @changed = true
      end

      def clear
        @data.clear
        @changes = {}
        @changed = true
        @cleared = true
      end

      def delete key
        @data.remove(key)
        @changed = true
      end

      def destroy
        self.clear
      end

      def key? key
        stat = @data.key?(key)
        stat = @changes.key?(key) unless stat
        return stat
      end

      def changed?
        @changed
      end

      def cleared?
        @cleared
      end

      def extract base = nil
        base = @data unless base
        base.merge(@changes)
      end

    end

  end

end