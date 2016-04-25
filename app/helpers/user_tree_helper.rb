module UserTreeHelper
	def draw_tree(tree)
		@tree_content = tree.map do |node,children|
			@this_node = content_tag(:a, node.name) + draw_tree(children)
			content_tag(:li, @this_node.html_safe)
		end.join.html_safe
		content_tag(:ul, @tree_content) unless @tree_content.empty?
	end
end
