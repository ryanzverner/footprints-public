require 'applicant_dispatch/strategies/filter_strategy'

describe "ApplicantDispatch::Filters::AvailabilityFilter" do
  subject { ApplicantDispatch::Filters::AvailabilityFilter }

  let(:applicant)                   { double }

  let(:crafter_with_no_date)      { double(unavailable_until: nil) }
  let(:crafter_with_past_date)    { double(unavailable_until: (Date.today - 1)) }
  let(:crafter_with_future_date)  { double(unavailable_until: (Date.today + 1)) }
  let(:crafter_with_current_date) { double(unavailable_until: Date.today) }

  let(:crafters_list)              { [crafter_with_no_date, crafter_with_past_date, crafter_with_future_date, crafter_with_current_date] }
  let(:available_crafters)         { [crafter_with_no_date, crafter_with_past_date] }
  let(:unavailable_crafters)       { [crafter_with_future_date, crafter_with_current_date] }

  context 'filtered through' do
    it 'returns crafters who are currently available' do
      filtered_crafters = subject.call(crafters_list, applicant)

      expect(filtered_crafters).to eq available_crafters
    end
  end

  context 'filtered out' do
    it 'does not return crafters that are unavailable' do
      filtered_crafters = subject.call(crafters_list, applicant)

      expect(filtered_crafters).not_to eq unavailable_crafters
    end
  end
end
