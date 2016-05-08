module UserTreeHelper
	def draw_tree(tree)
		@tree_content = tree.map do |node,children|
			@this_node = content_tag(:a, node.name) + draw_tree(children)
			content_tag(:li, @this_node.html_safe)
		end.join.html_safe
		content_tag(:ol, @tree_content) unless @tree_content.empty?
	end

	def user_chain(users)
		users.map do |user|
			content_tag(:li, content_tag(:a, user.name))
		end.join.html_safe
	end
end
