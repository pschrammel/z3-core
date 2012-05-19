module Z3
  module Commands
    class DeleteObject < Z3::Command
      def render(res)
        render_no_content({}, 204)
      end
    end
  end
end