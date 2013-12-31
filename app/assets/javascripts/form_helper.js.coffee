window.FormHelper = {}

class FormHelper.FillDateOnChange
  constructor: (listenElement) ->
    @listenElement = listenElement

  init: (updateElement) ->
    @updateElement = updateElement
    $(@listenElement).on "change", =>
      @addDate(@updateElement)

  addDate: (updateElement) ->
    if !$(updateElement).val()
      $(updateElement).datepicker('setDate', new Date())

class FormHelper.DisplayDivOnChange
  constructor: (listenElement) ->
    @listenElement = listenElement

  init: (updateElement) ->
    @updateElement = updateElement
    @determineShowStatus(@listenElement, @updateElement)
    $(@listenElement).on "change", =>
      @determineShowStatus(@listenElement, @updateElement)

  determineShowStatus: (listenElement, updateElement) ->
    value = $(listenElement).val()
    if value == "yes"
      $(updateElement).slideDown()
    else
      $(updateElement).slideUp()

$ ->
   new FormHelper.FillDateOnChange("[data-id=hired-select]").init("#decision_made_on")
   new FormHelper.DisplayDivOnChange("[data-id=hired-select]").init("#apprenticeship-date-selector")
