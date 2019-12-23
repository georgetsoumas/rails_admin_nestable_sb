require 'rails_admin/abstract_model'

module RailsAdminNestable
  module Helper
    def nested_tree_nodes(tree_nodes = [])
      tree_nodes.map do |tree_node, sub_tree_nodes|
        li_classes = 'dd-item dd3-item'
        content_tag :li, class: li_classes, :'data-id' => tree_node.id do
          output = content_tag :div, 'drag', class: 'dd-handle dd3-handle'
          output += content_tag :div, class: 'dd3-content' do
            content = link_to @model_config.with(object: tree_node).object_label, edit_path(@abstract_model, tree_node.id)
            content += content_tag :div, action_links(tree_node), class: 'pull-right links'
          end

          output+= content_tag :ol, nested_tree_nodes(sub_tree_nodes), class: 'dd-list' if sub_tree_nodes && sub_tree_nodes.any?
          output
        end
      end.join.html_safe
    end

    def nested_family(tree_nodes = [])
      return if tree_nodes.nil?
      tree_nodes.map do |tree_node, sub_tree_nodes|
        li_classes = 'dd-item dd3-item'

        content_tag :li, class: li_classes, data: { id: tree_node.id, 'dragable': 'false' } do
          output = content_tag :div, 'drag', class: 'dd-handle dd3-handle'
          output += content_tag :div, class: 'dd3-content' do
            content = link_to @model_config.with(object: tree_node).object_label, edit_path(@abstract_model, tree_node.id)
            content += content_tag :div, action_links(@abstract_model, tree_node), class: 'pull-right links'
          end

          child_output = ""
          card_children = @child_model.where(@foreign_key => tree_node.id.to_s)
          card_children.each do |card|
            child_output += content_tag :li, class: 'dd-item dd3-item', data: { id: card.id, 'group': card.id  } do
              levelone = content_tag :div, 'drag', class: 'dd-handle dd3-handle'
              levelone += content_tag :div, class: 'dd3-content' do
                card_abstract = RailsAdmin::AbstractModel.new(to_model_name(@child_model.name))
                content = link_to card.punchline, edit_path(card_abstract, card.id)
                content += content_tag :div, action_links(card_abstract, card), class: 'pull-right links'
              end
            end
          end

          output+= content_tag :ol, child_output.html_safe, class: 'dd-list' if !child_output.empty?
          output
        end
      end.join.html_safe
    end

    def action_links(abstract, model)
      content_tag :ul, class: 'inline list-inline' do
        menu_for :member, abstract, model, true
      end
    end

    def to_model_name(param)
      param.split('~').collect(&:camelize).join('::')
    end

    def tree_max_depth
      @nestable_conf.options[:max_depth] || 'false'
    end
  end
end