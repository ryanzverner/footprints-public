module ApplicantDispatch
  class RecordManager
    def expire_assigned_crafter_records
      AssignedCrafterRecord.all.each do |record|
        record.update_attribute(:current, false) if record.created_at < 10.days.ago
      end
    end
  end
end
