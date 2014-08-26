class OpenProject::OpenIDConnect::Hooks < Redmine::Hook::ViewListener
  def view_layouts_base_body_bottom(options = {})
    op_src = 'http://localhost:3000/auth/check_session'
    rp_src = 'http://localhost:3001/auth/check_session'
    %Q{\n
      <iframe
        id="openid_connect_provider"
        src="#{op_src}"
        style="position: fixed; top: 3px; left: 3px; background: green; border: 1px solid black; width: 110px; height: 48px; z-index: 11000"
      ></iframe>\n
      <iframe
        id="openid_connect_relying_party"
        src="#{rp_src}"
        style="position: fixed; top: 3px; left: 113px; background: blue; border: 1px solid black; width: 110px; height: 48px; z-index: 11000"
      ></iframe>\n}
  end
end
