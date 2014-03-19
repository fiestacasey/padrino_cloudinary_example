(function() {
  $(document).ready(function() {
    var template;
    template = jQuery.validator.format("<div class=\"thumbnail\"><a href=\"{0}\" target=\"_blank\"><img src=\"{1}\"></a><a href=\"/images/destroy/{2}\" class=\"destroy\" data-method=\"delete\" data-remote=\"true\"><span class=\"glyphicon glyphicon-trash\"></span></a></div>");
    $("input[type=\"file\"][multiple]").fileupload({
      dataType: "json",
      type: "post",
      sequentialUploads: true,
      dropZone: $("#dropzone"),
      acceptFileTypes: /^image\/(gif|jpeg|png)$/,
      done: function(e, data) {
        return $.each(data.result, function(index, file) {
          $(template(file.full_path, file.thumb, file.id)).insertBefore("#dropzone .loading:eq(0)");
          return $("#dropzone .loading:eq(0)").remove();
        });
      },
      add: function(e, data) {
        $.each(data.files, function(index, file) {
          return $("<div class=\"thumbnail loading\"><img src=\"/images/ajax-loader.gif\"></div>").insertBefore("#dropzone .clearfix");
        });
        return data.submit();
      }
    });
    $(document).on('ajax:beforeSend', "#images .thumbnail .destroy", function(event, xhr, status) {
      return $("<div class=\"loading\"><img src=\"/images/ajax-loader.gif\"></div>").insertBefore($(this).parents(".thumbnail").hide());
    });
    $(document).on('ajax:success', "#images .thumbnail .destroy", function(xhr, data, status) {
      $(this).parents(".thumbnail").remove();
      return $("#dropzone .loading:eq(0)").remove();
    });
    return $(document).on('ajax:error', "#images .thumbnail .destroy", function(data, status, xhr) {
      $(this).parents(".thumbnail").show();
      return $("#dropzone .loading:eq(0)").remove();
    });
  });

}).call(this);
