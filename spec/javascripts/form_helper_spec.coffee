#= require form_helper

describe "FormHelper", ->
  helper = null
  listenFixture = "#listen-fixture"
  updateFixture = "#update-fixture"

  beforeEach ->
    setFixtures("""
      <input type='text' id='listen-fixture'>
      <input type='text' id='update-fixture'>
      """)


  describe ".FillDateOnChange", ->
    beforeEach ->
      helper = new FormHelper.FillDateOnChange(listenFixture)
      helper.init(updateFixture)
      $(updateFixture).datepicker()

    describe "#init", ->
      it "assigns the element to update when the listen element is changed", ->
        expect(helper.updateElement).toEqual(updateFixture)

      it "listens for 'change' on the listenFixture", ->
        expect($(listenFixture)).toHandle("change")


    describe "#addDate", ->
      it "adds the date if the element is empty", ->
        date = moment(new Date()).format("MM/DD/YYYY")
        helper.addDate(updateFixture)
        expect($(updateFixture).val()).toEqual(date)

      it "doesn't add the date if the element is taken", ->
        $(updateFixture).val("filled date")
        helper.addDate(updateFixture)
        expect($(updateFixture).val()).toEqual("filled date")

  describe ".DisplayDivOnChange", ->
    beforeEach ->
      helper = new FormHelper.DisplayDivOnChange(listenFixture)
      helper.init(updateFixture)

    describe "#init", ->
      it "assigns element to show when the listen element is changed", ->
        expect(helper.updateElement).toEqual(updateFixture)
      it "listens for 'change' on the listenFixture", ->
        expect($(listenFixture)).toHandle("change")

    describe "#determineShowStatus", ->
      it "shows the element if the value is yes", ->
        $(listenFixture).val("yes")
        spyOn($(updateFixture), 'slideDown')
        helper.determineShowStatus($(listenFixture), $(updateFixture))
        expect($(updateFixture)).not.toBeHidden()

      it "hides the element if the value is not yes", ->
        helper.determineShowStatus($(listenFixture), $(updateFixture))
        expect($(updateFixture)).toHaveCss({overflow: "hidden"})
