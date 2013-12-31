require 'applicant_dispatch/strategies/filter_strategy'

describe "ApplicantDispatch::Filters::AvailabilityFilter" do
  subject { ApplicantDispatch::Filters::AvailabilityFilter }

  let(:applicant)                   { double }

  let(:craftsman_with_no_date)      { double(unavailable_until: nil) }
  let(:craftsman_with_past_date)    { double(unavailable_until: (Date.today - 1)) }
  let(:craftsman_with_future_date)  { double(unavailable_until: (Date.today + 1)) }
  let(:craftsman_with_current_date) { double(unavailable_until: Date.today) }

  let(:craftsmen_list)              { [craftsman_with_no_date, craftsman_with_past_date, craftsman_with_future_date, craftsman_with_current_date] }
  let(:available_craftsmen)         { [craftsman_with_no_date, craftsman_with_past_date] }
  let(:unavailable_craftsmen)       { [craftsman_with_future_date, craftsman_with_current_date] }

  context 'filtered through' do
    it 'returns craftsmen who are currently available' do
      filtered_craftsmen = subject.call(craftsmen_list, applicant)

      expect(filtered_craftsmen).to eq available_craftsmen
    end
  end

  context 'filtered out' do
    it 'does not return craftsmen that are unavailable' do
      filtered_craftsmen = subject.call(craftsmen_list, applicant)

      expect(filtered_craftsmen).not_to eq unavailable_craftsmen
    end
  end
end
