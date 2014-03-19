$(document).ready ->

  template = jQuery.validator.format("<div class=\"thumbnail\"><a href=\"{0}\" target=\"_blank\"><img src=\"{1}\"></a><a href=\"/images/destroy/{2}\" class=\"destroy\" data-method=\"delete\" data-remote=\"true\"><span class=\"glyphicon glyphicon-trash\"></span></a></div>")
  $("input[type=\"file\"][multiple]").fileupload
    dataType: "json"
    type: "post"
    sequentialUploads: true
    dropZone: $("#dropzone")
    acceptFileTypes: /^image\/(gif|jpeg|png)$/
    done: (e, data) ->
      $.each data.result, (index, file) ->
        $(template(file.full_path, file.thumb, file.id)).insertBefore "#dropzone .loading:eq(0)"
        $("#dropzone .loading:eq(0)").remove()


    add: (e, data) ->
      $.each data.files, (index, file) ->
        $("<div class=\"thumbnail loading\"><img src=\"/images/ajax-loader.gif\"></div>").insertBefore "#dropzone .clearfix"

      data.submit()
      
  $(document).on 'ajax:beforeSend', "#images .thumbnail .destroy", (event, xhr, status)->
    $("<div class=\"loading\"><img src=\"/images/ajax-loader.gif\"></div>").insertBefore $(this).parents(".thumbnail").hide()

  $(document).on 'ajax:success', "#images .thumbnail .destroy", (xhr, data, status)->
    $(this).parents(".thumbnail").remove()
    $("#dropzone .loading:eq(0)").remove()

  $(document).on 'ajax:error', "#images .thumbnail .destroy", (data, status, xhr)->
    $(this).parents(".thumbnail").show()
    $("#dropzone .loading:eq(0)").remove()