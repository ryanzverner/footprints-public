require 'spec_helper'
require 'ar_repository/models/monthly_apprentice_salary'

describe MonthlyApprenticeSalary do
  let(:repo) { Footprints::Repository.monthly_apprentice_salary }

  it "only allows a duration once per location" do
    chicago_3_month = repo.create(:duration => 3,
                                  :location => 'Chicago',
                                  :amount => 500.00)

    expect { repo.create(:duration => 3,
                         :location => 'Chicago',
                         :amount => 700.00)
    }.to raise_error(Footprints::RecordNotValid)
  end
end
