module UserTreeHelper
	def draw_tree(tree)
		@tree_node = tree.children.map do |child|
			@this_node = content_tag(:a, child.name) + draw_tree(child)
			content_tag(:li, @this_node.html_safe)
		end.join.html_safe
		content_tag(:ul, @tree_node) unless @tree_node.empty?
	end
end
