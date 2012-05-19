module Z3
  module Commands
    class HeadBucket < Z3::Command
      def render(res)
        render_no_content()
      end

      #200 if exists and permission
      #404 if not there
      #403 if no permission
    end
  end
end