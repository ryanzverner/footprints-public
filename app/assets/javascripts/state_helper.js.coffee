window.StateHelper = {}

class StateHelper.DatePicker
  constructor: (listenElement) ->
    @listenElement = listenElement

  init: ->
    @bindListenElement()

  bindListenElement: ->
    $(@listenElement).on "click", (event) =>
      @addDatePicker(event.target)
      @addDatepickerRemover()

  addDatePicker: (target) ->
    _that = this
    card = $(target).closest(".card")
    card.append("<div id='picker'/>")
    $("#picker").datepicker(onSelect: -> _that.postDate(@value, card))

    stateElementOffset = $(target).position().left
    offset = _that.getDatePickerPosition(card.width(), stateElementOffset)

    $(".hasDatepicker").css({"z-index": "1000", "position": "absolute", "margin-top": "10px", "margin-left": offset + "px" })

  getDatePickerPosition: (availableWidth, elementOffset) ->
    datePickerWidth = $(".ui-datepicker").width()

    if ((elementOffset + datePickerWidth) > availableWidth)
      availableWidth - datePickerWidth
    else
      elementOffset

  postDate: (date, card) ->
    data = {applicant: {}}
    data.applicant[@listenElement.slice(1)] = date
    Services.Request._post("/update_state/#{card.data("applicantId")}", data, (response) => @render(response, card))
    @removeDatePicker()

  render: (response, card) ->
    if response.success == "true"
      $(card).find(".current-state").removeClass("current-state")
      $(card).find(@listenElement).addClass("current-state")
      $('#flash-notices').empty()
    else
      $('#flash-notices').append("<p class='flash warning'>" + response.message + "</p>")
      window.location.href = "#flash-notices"

  addDatepickerRemover: ->
    $('body').append("<div id='close-picker'/>")
    $("#close-picker").css({"z-index": "999", "position": "fixed", "min-width": "100%", "min-height": "100%", "top": "0", "left": "0" })
    @bindDatepickerRemover()

  bindDatepickerRemover: ->
    $("#close-picker").on "click", =>
      @removeDatePicker()

  removeDatePicker: ->
    $("#picker").remove()
    $("#close-picker").remove()


class StateHelper.GenerateOfferLetterForm
  constructor: (listenElement) ->
    @listenElement = listenElement

  init: ->
    @bindListenElement()

  bindListenElement: ->
    $(@listenElement).on "click", (event) =>
      event.preventDefault()
      applicantId = $(event.target).closest(".card")
      Services.Request._get("/applicants/#{applicantId.data("applicantId")}/offer_letter_form", 'html', (response) => @openDialog(response, applicantId))

  download: (response) ->
    if response.success == "true"
      card = $("[data-applicant-id=#{response.applicantId}]")
      $(card).find(".current-state").removeClass("current-state")
      $(card).find(".offered_on").addClass("current-state")
      $("#offer-letter-form").remove()
      window.location.replace("/applicants/#{response.applicantId}/offer_letter.pdf?duration=#{response.duration}&pt_ft=#{response.pt_ft}&hours_per_week=#{response.hours_per_week}&withdraw_offer_date=#{response.withdraw_offer_date}")
    else
      $('#modal-errors').text(response.message)

  openDialog: (view, applicantId) ->
    $("#offer-letter-form").remove()
    applicantId.append(view)
    $("#offer-letter-form").dialog(@dialogOptions(applicantId))
    $("[data-id=start_date]").datepicker()
    $("[data-id=withdraw_offer_date]").datepicker()
    @disableDownloadButton()
    $("input").change(=> @validateInput())

  disableDownloadButton: ->
    $(".ui-button-text").css("color", "#CCCCCC")
    $("span:contains('Download')").parent().prop("disabled", true)

  enableDownloadButton: ->
    $(".ui-button-text").css("color", "#555555")
    $("span:contains('Download')").parent().prop("disabled", false)

  validateInput: ->
    confirmedWithAdmin = $("#confirmed_with_admin").prop('checked')
    validInputs = @isValidInputs()
    if confirmedWithAdmin && validInputs
      @enableDownloadButton()
    else
      @disableDownloadButton()

  isValidInputs: ->
    input_values = []
    $("#offer-letter-form input").each -> input_values.push($(this).val())
    input_values.every (x)-> x != ""

  dialogOptions: (applicantId) ->
    modal: true
    width: 500
    title: "Generate Offer Letter"
    buttons: [
      text: "Download",
      click: (event) =>
        @postEmploymentDates(@decisionFormValues(), applicantId)
    ]

  decisionFormValues: ->
    applicant:
      offered_on:           new Date()
      start_date:           $("[data-id=start_date]").val()
      duration:             $("[data-id=duration] option:selected").val()
      pt_ft:                "full time"
      hours_per_week:       "37.5"
      withdraw_offer_date:  $("[data-id=withdraw_offer_date]").val() || new Date()

  postEmploymentDates: (data, applicantId) ->
    Services.Request._post("/applicants/#{applicantId.data("applicantId")}/update_employment_dates", data, (response) => @download(response))


class StateHelper.ConfirmHireApplicant
  constructor: (listenElement) ->
    @listenElement = listenElement

  init: ->
    @bindListenElement()

  bindListenElement: ->
    $(@listenElement).on "click", (event) =>
      event.preventDefault()
      applicantId = $(event.target).closest(".applicant-actions")
      Services.Request._get("/applicants/#{applicantId.data("applicantId")}/hire", 'html', (response) => @openDialog(response, applicantId))

  openDialog: (view, applicantId) ->
    $("#confirm-hire").remove()
    applicantId.append(view)
    $("#confirm-hire").dialog(@dialogOptions(applicantId))

  dialogOptions: (applicantId) ->
    modal: true
    width: 500
    title: "Hire Applicant"
    buttons: [
      (text: "Onboarding Forms",
      click: (event) =>
        window.location.replace("/applicants/#{applicantId.data("applicantId")}/onboarding_letters.pdf")),
      (text: "Submit",
      click: (event) =>
        @postDecision(@confirmHireValues(), applicantId))
    ]

  confirmHireValues: ->
    applicant:
      decision_made_on: new Date()
      hired: "yes"

  postDecision: (data, applicantId) ->
    $("#confirm-hire form:first-child").submit();

  render: (response) ->
    if response.success == "true"
      window.location.reload()
    else
      $('#flash-notices').append("<p class='flash warning'>" + response.message + "</p>")
      window.location.href = "#flash-notices"
      $("#confirm-hire").remove()


$ ->
  for state in [".applied_on", ".initial_reply_on", ".sent_challenge_on", ".completed_challenge_on", ".reviewed_on"]
    new StateHelper.DatePicker(state).init()

  new StateHelper.GenerateOfferLetterForm(".offered_on").init()
  new StateHelper.ConfirmHireApplicant(".decision_made_on").init()
