window.Services = {}

class Services.Request
  @_post: (url, data, callback) ->
    $.ajax
      type: "POST"
      dataType: 'json'
      url : url
      data: data
      success: callback
      error: (xhr, status, error) ->
        if xhr.status == 401
          window.location.href = "/"

  @_get: (url, dataType, callback) ->
    $.ajax
      type: "GET"
      dataType: dataType
      url : url
      success: callback
