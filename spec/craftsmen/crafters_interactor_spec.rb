require 'spec_helpers/crafter_factory'

require './lib/crafters/crafters_interactor'

describe CraftersInteractor do
  let(:crafter) { SpecHelpers::CrafterFactory.new.create }
  let(:interactor) { described_class.new(crafter) }

  it 'updates attributes' do
    interactor.update({name: 'new name', 'skill' =>  2})

    expect(crafter.name).to eq 'new name'
  end

  it 'ensures that a skill is set' do
    interactor = CraftersInteractor.new(crafter)

    expect { interactor.update({name: 'new name', skill: ''}) }.to raise_error CraftersInteractor::InvalidData
  end

  it 'raises error for invalid availability date' do
    interactor = CraftersInteractor.new(crafter)

    expect{ interactor.update(unavailable_until: Date.today) }.to raise_error CraftersInteractor::InvalidData
  end
end
