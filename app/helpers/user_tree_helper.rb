module UserTreeHelper
	def draw_tree(tree)
		@tree_content = tree.map do |node,children|
			@child_nodes = draw_tree(children)

			@this_node_value =
				if @user == node
					''
				else
					content_tag(:span, (as_currency @user.earned_from(node)).to_s, class: 'earned-from')
				end

			@this_node = content_tag(:a, (node.name + @this_node_value).html_safe) + @child_nodes

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
