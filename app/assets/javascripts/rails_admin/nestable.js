(function($){
    //init
    $("#tree_nodes").nestable({
        maxDepth: 2,
        minDepth: 2,
        minDragDepth: 2
    });
    $("#rails_admin_nestable .btn").click(function(){
        var tree_nodes = $("#tree_nodes");
        var tree_url = tree_nodes.data('update-path');
        var tree_data = $("#tree_nodes").nestable('serialize');
        var self = $(this);
        self.attr("disabled", true);
        self.html('Updating');
        $("#result").html("");
        $.ajax ({
            url: tree_url,
            data: {
                tree_nodes: tree_data
            },
            method: 'POST',
            complete: function(){
                self.attr("disabled", false);
                self.html('Update');
            },
            success: function(data){
                $("#result").html(data);
            },
            error: function(data, status, e){
                console.log(data);
                var error = "";
                if(data.status == 0){
                    error = "Is the server up?";
                } else {
                    error = e;
                }
                $("#result").html("<span style = 'color: red'>Error: " + error + "</span>");
            }
        });
    });
  })(jQuery);